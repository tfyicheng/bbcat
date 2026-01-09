import 'package:bbcat/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../services/api_service.dart';
import 'sub_list_page.dart';

class HomePage extends StatefulWidget {
  final Isar isar;
  const HomePage({super.key, required this.isar});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _platforms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true); // 触发刷新时显示转圈
    try {
      var data = await ApiService.getPlatforms();

      String result = await SyncService.syncFavorites(widget.isar);

      setState(() {
        _platforms = data;
        _isLoading = false;
      });

      // 提示更新结果
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    } catch (e) {
      setState(() => _isLoading = false);
      // 可选：添加一个简单的错误提示
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("加载失败，请检查网络")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("直播平台"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadData(), // 点击调用加载方法
            tooltip: "刷新数据",
          ),
        ],
      ),
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
              itemCount: _platforms.length,
              itemBuilder: (context, index) {
                var item = _platforms[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubListPage(
                          title: item['title'],
                          address: item['address'],
                          isar: widget.isar,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(item['xinimg'], fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black45,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            item['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
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
