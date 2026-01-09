import 'package:bbcat/widgets/video_player_component.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../services/api_service.dart';

class SubListPage extends StatefulWidget {
  final String title;
  final String address;
  final Isar isar;
  const SubListPage({
    super.key,
    required this.title,
    required this.address,
    required this.isar,
  });

  @override
  State<SubListPage> createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage> {
  List<dynamic> _zhuboList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    var data = await ApiService.getZhuboList(widget.address);
    setState(() {
      _zhuboList = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: _zhuboList.length,
              itemBuilder: (context, index) {
                var item = _zhuboList[index];
                return GestureDetector(
                  onTap: () {
                    // 这里就是拿到播放地址 item['address']
                    // print("播放地址: ${item['address']}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerComponent(
                          isar: widget.isar,
                          videoData: item,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(item['img'], fit: BoxFit.cover),
                      ),
                      Positioned.fill(
                        child: Image.network(
                          item['img'] ?? '', // 确保字段存在
                          fit: BoxFit.cover,
                          // 1. 处理加载状态（可选，增加体验）
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          // 2. 核心：处理图片加载失败，防止页面崩溃
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "图片失效",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
