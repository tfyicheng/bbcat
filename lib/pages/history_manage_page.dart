import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/isar_service.dart';
import '../models/browsing_history.dart';
import '../widgets/web_component.dart';
// import 'package:intl/intl.dart'; // 建议在 pubspec.yaml 添加 intl 插件用于格式化时间

class HistoryManagePage extends StatefulWidget {
  const HistoryManagePage({super.key});

  @override
  State<HistoryManagePage> createState() => _HistoryManagePageState();
}

class _HistoryManagePageState extends State<HistoryManagePage> {
  List<BrowsingHistory> _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // 加载数据
  Future<void> _loadHistory() async {
    final data = await IsarService.getAllHistory();
    setState(() {
      _historyList = data;
    });
  }

  // 确认清空对话框
  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("确认清空"),
        content: const Text("是否要删除所有浏览记录？此操作不可撤销。"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () async {
              await IsarService.clearAllHistory();
              Navigator.pop(ctx);
              _loadHistory(); // 刷新
            },
            child: const Text("全部清空", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("浏览记录"),
        actions: [
          if (_historyList.isNotEmpty)
            TextButton(
              onPressed: _showClearAllDialog,
              child: const Text(
                "清空",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
        ],
      ),
      body: _historyList.isEmpty
          ? const Center(
              child: Text("暂无记录", style: TextStyle(color: Colors.grey)),
            )
          : ListView.separated(
              itemCount: _historyList.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 70),
              itemBuilder: (context, index) {
                final item = _historyList[index];
                // 格式化时间：MM-dd HH:mm
                // final timeStr = DateFormat('MM-dd HH:mm').format(item.visitTime);
                final timeStr = item.visitTime;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: const Icon(
                      Icons.history,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "$timeStr  |  ${item.url}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.copy_all,
                      size: 18,
                      color: Colors.grey,
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
                  onTap: () {
                    // 点击历史记录，打开浏览器组件查看
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WebComponent(initialUrl: item.url),
                      ),
                    ).then((_) => _loadHistory()); // 返回时刷新列表
                  },
                );
              },
            ),
    );
  }
}
