import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'dart:math';
import '../services/api_service.dart';
import '../services/video_check_service.dart';
import '../widgets/video_player_component.dart';
import '../models/favorite_zhubo.dart';
import 'package:visibility_detector/visibility_detector.dart'; // 导入可见性检测包

class VideoStreamPage extends StatefulWidget {
  final Isar isar;
  final bool isCurrentTab; // 新增：是否是当前激活的 Tab
  const VideoStreamPage({
    super.key,
    required this.isar,
    required this.isCurrentTab,
  });

  @override
  State<VideoStreamPage> createState() => _VideoStreamPageState();
}

class _VideoStreamPageState extends State<VideoStreamPage> {
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> _videoPool = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isPageVisible = true; // 记录当前页面是否可见
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initRandomPool();
  }

  // 1. 初始化或重置随机池 (点击刷新时调用)
  Future<void> _initRandomPool() async {
    if (mounted) setState(() => _isLoading = true);

    _videoPool = []; // 先清空池子
    await _loadMoreVideos(); // 抓取第一波有效源

    if (mounted) setState(() => _isLoading = false);
  }

  // 2. 核心：并发检测有效源，防止 ANR
  Future<void> _loadMoreVideos() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    try {
      final allPlatforms = await ApiService.getPlatforms();
      if (allPlatforms.isEmpty) {
        _isLoadingMore = false;
        return;
      }

      // 给 UI 线程喘息机会
      await Future.delayed(Duration.zero);

      // 随机选平台并抓取
      var random = Random();
      allPlatforms.shuffle();
      var selectedPlatforms = allPlatforms.take(3 + random.nextInt(3)).toList();

      List<Map<String, dynamic>> tempCandidates = [];
      for (var pf in selectedPlatforms) {
        try {
          final list = await ApiService.getZhuboList(pf['address']);
          tempCandidates.addAll(list.cast<Map<String, dynamic>>());
        } catch (_) {}
      }
      tempCandidates.shuffle();

      // --- 并发检测：防止卡死的核心 ---
      // 每次只从候选里挑 15 条进行检测
      final limitedCandidates = tempCandidates.take(15).toList();

      // 使用 Future.wait 并行发出 HEAD 请求
      List<Future<Map<String, dynamic>?>> checkTasks = limitedCandidates.map((
        item,
      ) async {
        // 重复检测
        if (_videoPool.any((v) => v['title'] == item['title'])) return null;
        // 有效性检测
        bool isValid = await VideoCheckService.checkUrl(item['address']);
        return isValid ? item : null;
      }).toList();

      final results = await Future.wait(checkTasks);
      final validatedList = results
          .whereType<Map<String, dynamic>>()
          .take(5)
          .toList();

      if (mounted) {
        setState(() {
          _videoPool.addAll(validatedList);
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      _isLoadingMore = false;
    }
  }

  // 3. 收藏/取消收藏逻辑
  Future<void> _toggleFavorite(Map<String, dynamic> video) async {
    final title = video['title'];
    final address = video['address'];
    final img = video['img'];

    final existing = await widget.isar.favoriteZhubos
        .where()
        .filter()
        .titleEqualTo(title)
        .findFirst();

    await widget.isar.writeTxn(() async {
      if (existing != null) {
        await widget.isar.favoriteZhubos.delete(existing.id);
        _showMsg("已从收藏夹移除");
      } else {
        final newFav = FavoriteZhubo()
          ..title = title
          ..img = img
          ..address = address
          ..updateTime = DateTime.now();
        await widget.isar.favoriteZhubos.put(newFav);
        _showMsg("已成功收藏");
      }
    });
    // 强制刷新当前页 UI 状态
    setState(() {});
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. 全局加载状态判断
    if (_isLoading && _videoPool.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    // 2. 使用 VisibilityDetector 监听整个页面的可见性（解决离开页面继续播放的问题）
    return VisibilityDetector(
      key: const Key('video-stream-page-visibility-key'),
      onVisibilityChanged: (visibilityInfo) {
        // visibleFraction 为 0 表示页面完全不可见（如切换到了其他 Tab）
        bool isVisible = visibilityInfo.visibleFraction > 0;
        if (_isPageVisible != isVisible) {
          setState(() {
            _isPageVisible = isVisible;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        // 延伸到状态栏
        extendBodyBehindAppBar: true,
        body: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _videoPool.length,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
            // 预加载逻辑：滑到最后两个时开始补充新内容
            if (index >= _videoPool.length - 2) {
              _loadMoreVideos();
            }
          },
          itemBuilder: (context, index) {
            print("--- 检查播放状态 ---");
            print("Tab是否选中: ${widget.isCurrentTab}");
            print("页面是否可见: $_isPageVisible");
            print("是否是当前这一页: ${_currentIndex == index}");

            final video = _videoPool[index];

            return Stack(
              children: [
                // 第一层：全屏播放器背景
                Positioned.fill(
                  child: VideoPlayerComponent(
                    // 增加 index 确保每个视频组件的唯一性
                    key: ValueKey("${video['address']}_$index"),
                    videoData: video,
                    isar: widget.isar,
                    // 关键优化：只有当“页面整体可见”且“当前正处于这一页”时才激活加载/播放
                    // isPageActive: _isPageVisible && _currentIndex == index,
                    // 联动逻辑：主菜单激活 && 页面可见 && PageView 索引匹配
                    isPageActive:
                        widget.isCurrentTab &&
                        _isPageVisible &&
                        _currentIndex == index,
                  ),
                ),

                // 第二层：底部装饰渐变阴影（从透明到黑色，增强文字对比度）
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 260,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),

                // 第三层：右侧功能菜单（换一批 / 收藏 / 复制）
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Column(
                    children: [
                      _buildSideAction(
                        icon: Icons.refresh_rounded,
                        label: "换一批",
                        onTap: _initRandomPool, // 点击重置随机池并刷新
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // 第四层：左下角主播信息显示
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "@${video['title']}",
                      //   style: const TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //     shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                      //   ),
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.live_tv,
                      //       color: Colors.redAccent,
                      //       size: 16,
                      //     ),
                      //     const SizedBox(width: 6),
                      //     Text(
                      //       "@${video['address']}",
                      //       style: TextStyle(
                      //         color: Colors.white.withOpacity(0.8),
                      //         fontSize: 13,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSideAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
