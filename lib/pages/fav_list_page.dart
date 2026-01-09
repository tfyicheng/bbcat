import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/favorite_zhubo.dart';
// 1. 修正导入：直接导入你的组件
import '../widgets/video_player_component.dart';
import '../services/sync_service.dart';

class FavListPage extends StatefulWidget {
  final Isar isar;
  const FavListPage({super.key, required this.isar});

  @override
  State<FavListPage> createState() => _FavListPageState();
}

class _FavListPageState extends State<FavListPage> {
  List<FavoriteZhubo> _favs = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() async {
    final data = await widget.isar.favoriteZhubos
        .where()
        .sortByUpdateTimeDesc() // 更新过的排在前面
        .findAll();
    setState(() => _favs = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("直播收藏"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              // 手动触发同步
              String msg = await SyncService.syncFavorites(widget.isar);
              _refreshList();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(msg)));
            },
          ),
        ],
      ),
      body: _favs.isEmpty
          ? const Center(child: Text("暂无收藏"))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: _favs.length,
              itemBuilder: (context, index) {
                final fav = _favs[index];
                return GestureDetector(
                  onTap: () async {
                    // 2. 跳转到视频播放组件，传参格式保持一致
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerComponent(
                          isar: widget.isar,
                          videoData: {
                            'title': fav.title,
                            'address': fav.address,
                            'img': fav.img,
                          },
                        ),
                      ),
                    );

                    // 返回后刷新列表（以防有更新）
                    _refreshList();
                  },
                  child: _buildItemCard(fav),
                );
              },
            ),
    );
  }

  // 卡片外观与二级页面保持一致
  Widget _buildItemCard(FavoriteZhubo fav) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            fav.img,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black45,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              fav.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
