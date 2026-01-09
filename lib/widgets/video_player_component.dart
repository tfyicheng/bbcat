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

  const VideoPlayerComponent({
    super.key,
    required this.videoData,
    required this.isar,
  });

  @override
  State<VideoPlayerComponent> createState() => _VideoPlayerComponentState();
}

class _VideoPlayerComponentState extends State<VideoPlayerComponent> {
  bool _isFavorited = false;

  late final Player _player;
  late final VideoController _controller;

  @override
  void initState() {
    super.initState();
    // 3. 初始化播放器
    _player = Player();
    _controller = VideoController(_player);

    // 4. 开始播放视频流
    _player.open(Media(widget.videoData['address']));

    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    // 5. 必须销毁播放器，否则会内存泄漏或声音卡顿
    _player.dispose();
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
