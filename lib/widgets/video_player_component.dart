import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/favorite_zhubo.dart';
import 'package:media_kit/media_kit.dart'; // 1. 导入 media_kit
import 'package:media_kit_video/media_kit_video.dart'; // 2. 导入视频渲染库
import 'package:flutter/services.dart';

// 假设你在构造函数中传入了 isar 实例
class VideoPlayerComponent extends StatefulWidget {
  final Map<String, dynamic> videoData;
  final Isar isar;
  final bool isPageActive; // 新增：当前页面是否处于激活状态

  const VideoPlayerComponent({
    super.key,
    required this.videoData,
    required this.isar,
    this.isPageActive = true, // 默认激活
  });

  @override
  State<VideoPlayerComponent> createState() => _VideoPlayerComponentState();
}

class _VideoPlayerComponentState extends State<VideoPlayerComponent>
    with WidgetsBindingObserver {
  bool _isFavorited = false;

  late final Player _player;
  late final VideoController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _player = Player();
    _controller = VideoController(_player);

    // 1. 先设置媒体源
    _player.open(Media(widget.videoData['address']), play: false); // 默认不自动播放

    // 2. 根据初始状态决定是否播放
    if (widget.isPageActive) {
      print("初始化：激活状态，开始播放");
      //_player.play();
      // 如果希望绝对实时，避免延迟积累,可以重新 open 这个地址，强制播放器拉取最新的切片
      _player.open(Media(widget.videoData['address']));
    } else {
      print("初始化：非激活状态，保持暂停");
    }
    _checkFavoriteStatus();
  }

  //监听父组件传来的状态变化
  @override
  void didUpdateWidget(VideoPlayerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPageActive != oldWidget.isPageActive) {
      if (widget.isPageActive) {
        print("页面激活，继续播放");
        //_player.play(); // 回到页面，继续播放
        _player.open(Media(widget.videoData['address']));
      } else {
        print("页面离开，暂停播放");
        _player.pause(); // 离开页面，立即暂停
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 只有当当前 Tab 是视频页时，才处理后台返回逻辑
    if (!widget.isPageActive) return;

    if (state == AppLifecycleState.resumed) {
      print("检测到 App 从后台回到前台，且处于视频 Tab，尝试恢复直播...");
      // 强制重新拉流，解决画面冻结问题
      _player.open(Media(widget.videoData['address']));
    } else if (state == AppLifecycleState.paused) {
      print("检测到 App 进入后台，暂停播放节省流量");
      _player.pause();
    }
  }

  @override
  void dispose() {
    // 5. 必须销毁播放器，否则会内存泄漏或声音卡顿
    _player.dispose();
    WidgetsBinding.instance.removeObserver(this); // 销毁监听器
    super.dispose();
  }

  // 检查当前直播间是否已收藏（Title 和 Address 全匹配）
  Future<void> _checkFavoriteStatus() async {
    final title = widget.videoData['title'];
    final address = widget.videoData['address'];

    final existing = await widget.isar.favoriteZhubos
        .where()
        .filter()
        .titleEqualTo(title)
        .addressEqualTo(address)
        .findFirst();

    setState(() {
      _isFavorited = existing != null;
    });
  }

  // 收藏/取消收藏的核心逻辑
  Future<void> _toggleFavorite() async {
    final title = widget.videoData['title'];
    final address = widget.videoData['address'];
    final img = widget.videoData['img'];

    // 1. 查找是否存在相同标题的收藏
    final existingTitle = await widget.isar.favoriteZhubos
        .where()
        .filter()
        .titleEqualTo(title)
        .findFirst();

    await widget.isar.writeTxn(() async {
      if (existingTitle != null) {
        if (existingTitle.address == address) {
          // A. Title 和 Address 全对得上 -> 取消收藏
          await widget.isar.favoriteZhubos.delete(existingTitle.id);
          _showToast("已取消收藏");
        } else {
          // B. Title 一样但 Address 不一样 -> 更新地址和图片
          existingTitle.address = address;
          existingTitle.img = img;
          existingTitle.updateTime = DateTime.now();
          await widget.isar.favoriteZhubos.put(existingTitle);
          _showToast("已更新直播源地址");
        }
      } else {
        // C. 全新的主播 -> 新增收藏
        final newFav = FavoriteZhubo()
          ..title = title
          ..img = img
          ..address = address
          ..updateTime = DateTime.now();
        await widget.isar.favoriteZhubos.put(newFav);
        _showToast("已添加到收藏");
      }
    });

    // 重新检查图标状态
    _checkFavoriteStatus();
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // 使用 Stack 让视频在底部，AppBar 在上层
      body: Stack(
        children: [
          // 6. 核心渲染区域：显示视频
          Center(
            child: Video(
              controller: _controller,
              fill: Colors.black, // 视频未加载时的背景
            ),
          ),

          // 7. UI 层
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black26, // 半透明背景，防止看不见白色的返回键
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                widget.videoData['title'] ?? '直播间',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white),
                  tooltip: '复制直播链接',
                  onPressed: () {
                    final address = widget.videoData['address'];
                    if (address != null) {
                      Clipboard.setData(ClipboardData(text: address));
                      _showToast("链接已复制到剪贴板");
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited ? Colors.red : Colors.white,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
