import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bbcat/services/isar_service.dart';
import 'package:media_kit/media_kit.dart';
import 'package:isar/isar.dart'; // 必须导入 Isar
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'main_shell.dart';
import 'pages/fake_page.dart';

void main() async {
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //只调用一次 runApp，并将 isar 传进去
  final isar = await IsarService.db;

  // 初始化播放器
  MediaKit.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    // 必须初始化 windowManager
    await windowManager.ensureInitialized();

    windowManager.setIcon('windows/runner/resources/app_icon.ico');

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 600),
      center: true,
      title: "BBCat",
      // 拦截关闭按钮，不让应用真正退出
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      // 关键：设置关闭按钮为隐藏而非退出
      await windowManager.setPreventClose(true);
    });

    // 初始化托盘
    initSystemTray();
  }

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

// 托盘初始化与事件监听
class TrayHandler extends TrayListener {
  @override
  void onTrayIconMouseDown() {
    // 点击图标：显示并聚焦窗口
    windowManager.show();
    windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() {
    // 右键点击：tray_manager 会自动弹出菜单（如果在 init 中设置了）
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'exit_app') {
      // 真正的退出逻辑
      windowManager.setPreventClose(false);
      windowManager.close();
    } else if (menuItem.key == 'show_window') {
      windowManager.show();
    }
  }
}

Future<void> initSystemTray() async {
  // 设置托盘图标
  await trayManager.setIcon('assets/app_icon.ico');
  await trayManager.setToolTip('BBCat');
  // 设置托盘菜单
  List<MenuItem> items = [
    MenuItem(key: 'show_window', label: '显示窗口'),
    MenuItem.separator(),
    MenuItem(key: 'exit_app', label: '退出应用'),
  ];
  await trayManager.setContextMenu(Menu(items: items));

  // 注册监听
  trayManager.addListener(TrayHandler());
}
