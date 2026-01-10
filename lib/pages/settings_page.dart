import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; // 需要在 pubspec.yaml 添加此插件
import '../services/isar_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const platform = MethodChannel('com.example.bbcat/icon_switch');
  String? _selectedAlias = ".MainActivity";
  String _cacheSize = "0.00 MB"; // 用于展示缓存大小
  String _historyLimit = "300"; // 浏览记录保留上限，默认300条
  String _summaryLimit = "200"; // 汇总数据上限，默认200条
  String _defaultHome = "https://m.baidu.com"; // 默认主页

  final Map<String?, Map<String, dynamic>> _maskOptions = {
    ".MainActivity": {"name": "默认模式 (bbcat)", "icon": Icons.apps},
    ".MainActivitySet": {"name": "设置", "icon": Icons.settings},
    ".MainActivityCalendar": {"name": "日历", "icon": Icons.calendar_today},
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _calculateCache(); // 初始化时计算缓存
  }

  Future<void> _loadSettings() async {
    final val = await IsarService.getSetting("selected_mask");
    if (val != null) {
      setState(() => _selectedAlias = val);
    }

    final home = await IsarService.getSetting('default_home');
    if (home != null) {
      setState(() => _defaultHome = home);
    }

    final limit = await IsarService.getSetting('history_limit');
    if (limit != null) {
      setState(() {
        _historyLimit = limit;
      });
    }

    final summaryLimit = await IsarService.getSetting('summary_limit');
    if (summaryLimit != null) {
      setState(() {
        _summaryLimit = summaryLimit;
      });
    }
  }

  // --- 核心功能：计算缓存大小 ---
  Future<void> _calculateCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      setState(() {
        _cacheSize = "${(value / (1024 * 1024)).toStringAsFixed(2)} MB";
      });
    } catch (e) {
      debugPrint("计算缓存失败: $e");
    }
  }

  // 递归计算文件夹大小
  Future<double> _getTotalSizeOfFilesInDir(FileSystemEntity file) async {
    if (file is File) return (await file.length()).toDouble();
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      for (final FileSystemEntity child in children) {
        total += await _getTotalSizeOfFilesInDir(child);
      }
      return total;
    }
    return 0;
  }

  // --- 核心功能：清理缓存 ---
  Future<void> _clearCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.listSync().forEach((child) {
          child.deleteSync(recursive: true);
        });
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("缓存已清理完成")));
      _calculateCache(); // 清理后重新计算
    } catch (e) {
      debugPrint("清理失败: $e");
    }
  }

  // 图标切换逻辑 (保持之前的原生通道调用)
  void _handleMaskChange(String? value) async {
    if (value == null) return;
    setState(() => _selectedAlias = value);
    await IsarService.saveSetting("selected_mask", value);
    if (Platform.isAndroid) {
      try {
        await platform.invokeMethod('changeIcon', {'aliasName': value});
        _showSuccessDialog();
      } on PlatformException catch (e) {
        debugPrint("原生切换失败: ${e.message}");
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("设置成功"),
        content: const Text("应用图标将在返回桌面后刷新。"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("确定"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("设置")),
      body: ListView(
        children: [
          _buildSectionTitle("图标伪装 (仅 Android)"),
          ..._maskOptions.entries.map((entry) {
            return RadioListTile<String?>(
              title: Text(entry.value["name"]),
              secondary: Icon(entry.value["icon"]),
              value: entry.key,
              groupValue: _selectedAlias,
              onChanged: _handleMaskChange,
            );
          }),
          const Divider(),
          _buildSectionTitle("系统维护"),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text("清除应用缓存"),
            subtitle: const Text("包含视频分片、网页临时文件等"),
            trailing: Text(
              _cacheSize,
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () => _showClearConfirmDialog(),
          ),
          ListTile(
            title: const Text("自定义默认主页"),
            subtitle: Text(_defaultHome),
            trailing: const Icon(Icons.home_outlined),
            onTap: () => _showHomeSettingDialog(),
          ),
          ListTile(
            title: const Text("浏览记录保留上限"),
            subtitle: Text(_historyLimit), // 从 Isar 读取的值
            trailing: const Icon(Icons.edit_note),
            onTap: () => _showLimitDialog(),
          ),
          ListTile(
            title: const Text("汇总数据上限"),
            subtitle: Text(_summaryLimit), // 从 Isar 读取的值
            trailing: const Icon(Icons.edit_note),
            onTap: () {
              _showsummaryDialog();
            },
          ),
          // SwitchListTile(
          //   secondary: const Icon(Icons.dark_mode_outlined),
          //   title: const Text("深色模式"),
          //   value: Theme.of(context).brightness == Brightness.dark,
          //   onChanged: (v) {
          //     // 这里预留深色模式切换逻辑
          //   },
          // ),
        ],
      ),
    );
  }

  void _showClearConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("确认清理"),
        content: Text("将清理约 $_cacheSize 的缓存文件，不影响个人收藏数据。"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _clearCache();
            },
            child: const Text("立即清理", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showHomeSettingDialog() {
    final controller = TextEditingController(text: _defaultHome);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("设置默认主页"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "请输入完整的网址 (http/https)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () async {
              String url = controller.text.trim();
              if (url.isNotEmpty) {
                await IsarService.saveSetting('default_home', url);
                setState(() => _defaultHome = url);
                Navigator.pop(ctx);
              }
            },
            child: const Text("保存"),
          ),
        ],
      ),
    );
  }

  void _showLimitDialog() {
    final TextEditingController controller = TextEditingController(
      text: _historyLimit,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("修改保留上限"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number, // 只能输入数字
          decoration: const InputDecoration(hintText: "请输入数字", suffixText: "条"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () async {
              String newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                // 保存到数据库
                await IsarService.saveSetting('history_limit', newValue);
                setState(() {
                  _historyLimit = newValue;
                });
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: const Text("确定"),
          ),
        ],
      ),
    );
  }

  void _showsummaryDialog() {
    final TextEditingController controller = TextEditingController(
      text: _summaryLimit,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("修改汇总上限"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number, // 只能输入数字
          decoration: const InputDecoration(hintText: "请输入数字", suffixText: "条"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () async {
              String newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                // 保存到数据库
                await IsarService.saveSetting('summary_limit', newValue);
                setState(() {
                  _summaryLimit = newValue;
                });
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: const Text("确定"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
