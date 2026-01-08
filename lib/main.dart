import 'package:flutter/material.dart';
import 'package:bbcat/services/isar_service.dart';
import 'main_shell.dart';
import 'pages/fake_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化数据库
  await IsarService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const RootController(), // 使用控制器作为首页
    );
  }
}

class RootController extends StatefulWidget {
  const RootController({super.key});

  @override
  State<RootController> createState() => _RootControllerState();
}

class _RootControllerState extends State<RootController> {
  bool _isUnlocked = false; // 是否已进入主应用的标记

  @override
  Widget build(BuildContext context) {
    // 逻辑分流
    if (_isUnlocked) {
      return const MainShell(); // 已解锁，进入主程序
    } else {
      return FakeFeedbackPage(
        onUnlocked: () {
          setState(() {
            _isUnlocked = true; // 触发解锁，重新构建 UI
          });
        },
      );
    }
  }
}
