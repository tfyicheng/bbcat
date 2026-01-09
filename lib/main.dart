import 'package:flutter/material.dart';
import 'package:bbcat/services/isar_service.dart';
import 'package:media_kit/media_kit.dart';
import 'package:isar/isar.dart'; // 必须导入 Isar
import 'main_shell.dart';
import 'pages/fake_page.dart';

void main() async {
  // 1. 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 初始化播放器
  MediaKit.ensureInitialized();

  // 3. 初始化数据库并获取实例
  // 注意：修改你的 IsarService.init() 让它返回 Isar 实例
  // final isar = await IsarService.init();
  final isar = await IsarService.db;
  // 4. 只调用一次 runApp，并将 isar 传进去
  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      // 将 isar 传给 RootController
      home: RootController(isar: isar),
    );
  }
}

class RootController extends StatefulWidget {
  final Isar isar;
  const RootController({super.key, required this.isar});

  @override
  State<RootController> createState() => _RootControllerState();
}

class _RootControllerState extends State<RootController> {
  bool _isUnlocked = false;

  @override
  Widget build(BuildContext context) {
    if (_isUnlocked) {
      // 5. 解锁后，将 isar 传给 MainShell
      return MainShell(isar: widget.isar);
    } else {
      return FakeFeedbackPage(
        onUnlocked: () {
          setState(() {
            _isUnlocked = true;
          });
        },
      );
    }
  }
}
