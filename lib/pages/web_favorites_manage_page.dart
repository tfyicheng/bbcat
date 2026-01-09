import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 导入剪贴板服务
import '../services/isar_service.dart';
import '../models/web_favorite.dart';
import '../widgets/web_component.dart';

class WebFavoritesManagePage extends StatefulWidget {
  const WebFavoritesManagePage({super.key});

  @override
  State<WebFavoritesManagePage> createState() => _WebFavoritesManagePageState();
}

class _WebFavoritesManagePageState extends State<WebFavoritesManagePage> {
  List<WebFavorite> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await IsarService.getAllWebFavorites();
    setState(() => _favorites = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("网页收藏")),
      body: _favorites.isEmpty
          ? const Center(child: Text("暂无收藏"))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 1),
              itemCount: _favorites.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 10), // 分割线
              itemBuilder: (context, index) {
                final item = _favorites[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),
                  // leading: CircleAvatar(
                  //   backgroundColor: Theme.of(
                  //     context,
                  //   ).primaryColor.withOpacity(0.1),
                  //   child: Icon(
                  //     Icons.language,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  // ),
                  // 标题：字号小一点，最多显示两行
                  title: Text(
                    item.title.isEmpty ? "未命名网页" : item.title,
                    style: const TextStyle(
                      fontSize: 14, // 较小的字号
                      fontWeight: FontWeight.w500,
                      height: 1.3, // 行高
                    ),
                    maxLines: 2, // 最多两行
                    overflow: TextOverflow.ellipsis, // 超出显示省略号
                  ),
                  // 副标题：显示网址，单行
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item.url,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 尾部按钮区域：复制 + 删除
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // 关键：让 Row 宽度自适应内容
                    children: [
                      // 复制按钮
                      IconButton(
                        icon: const Icon(
                          Icons.copy_rounded,
                          size: 20,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item.url));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("链接已复制"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      // 删除按钮
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 22,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _confirmDelete(item),
                      ),
                    ],
                  ),
                  onTap: () {
                    // 点击使用通用的 WebComponent 查看
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WebComponent(initialUrl: item.url),
                      ),
                    ).then((_) => _loadData()); // 返回时刷新列表
                  },
                );
              },
            ),
    );
  }

  void _confirmDelete(WebFavorite item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("取消收藏"),
        content: const Text("确定要从收藏夹中移除吗？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () async {
              await IsarService.deleteWebFavorite(item.id);
              Navigator.pop(ctx);
              _loadData();
            },
            child: const Text("确认删除", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
