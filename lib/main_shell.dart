import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'package:flutter/services.dart';
// 导入刚才写的三个页面
import 'pages/home_page.dart';
import 'pages/video_page.dart';
import 'pages/mine_page.dart';
import 'pages/WebBrowserPage.dart';
import 'pages/summary_page.dart';
import 'package:isar/isar.dart';

class MainShell extends StatefulWidget {
  final Isar isar;
  const MainShell({super.key, required this.isar});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with WindowListener, WidgetsBindingObserver {
  // 1. 定义一个索引，记录当前选中的是第几个菜单
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 4. 将 isar 实例分发给需要它的子页面
    //_pages = [
    //   HomePage(isar: widget.isar), // 传入 isar
    //   SummaryPage(isar: widget.isar), // 传入 isar
    //   VideoStreamPage(
    //     isar: widget.isar,
    //     isCurrentTab: _currentIndex == 2,
    //   ), // 如果这个页面暂时不需要 isar 保持不变
    //   const WebBrowserPage(),
    //   ProfilePage(isar: widget.isar), // 传入 isar
    // ];
    windowManager.addListener(this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // 3. 销毁监听器，防止内存泄漏
    windowManager.removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 4. 实现监听方法：拦截点击右上角“X”的行为
  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      // 如果设置了阻止关闭，则执行隐藏
      await windowManager.hide();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 当 App 回到前台时，强制刷新 UI，这会触发 VideoStreamPage 的重新构建
      setState(() {});
    }
  }

  DateTime? _lastPressedAt; // 记录上次点击时间

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(isar: widget.isar),
      SummaryPage(isar: widget.isar),
      VideoStreamPage(
        isar: widget.isar,
        // 这里的 _currentIndex 是 MainShell 当前选中的底部菜单索引
        // 假设视频流页面在第 3 个位置（索引为 2）
        isCurrentTab: _currentIndex == 2,
      ),
      const WebBrowserPage(),
      ProfilePage(isar: widget.isar),
    ];

    // 获取屏幕宽度，判断是否为宽屏（Windows/平板）
    bool isWideScreen = MediaQuery.of(context).size.width > 600;

    return PopScope(
      canPop: false, // 设置为 false，拦截默认的返回行为
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        // 如果两次点击时间间隔小于 2 秒，则退出
        if (Platform.isAndroid &&
            (_lastPressedAt == null ||
                DateTime.now().difference(_lastPressedAt!) >
                    const Duration(seconds: 2))) {
          _lastPressedAt = DateTime.now();

          // 这里可以使用你项目里已有的消息提示组件
          // 如果没有，可以用最原生的 ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('再按一次退出应用'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating, // 浮动样式，适合直播类 App
            ),
          );
          return;
        }

        // 符合退出条件
        // 对于 Android，推荐使用 SystemNavigator.pop() 彻底退出
        SystemNavigator.pop();
      },
      child: Scaffold(
        // appBar: AppBar(title: const Text("多端应用")),

        // body 决定了显示哪个页面
        body: Row(
          children: [
            // 如果是宽屏，显示左侧导航栏 (Windows 适配)
            if (isWideScreen)
              NavigationRail(
                selectedIndex: _currentIndex,
                // 点击左侧菜单时触发
                onDestinationSelected: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('主页'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.summarize),
                    label: Text('汇总'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.video_library),
                    label: Text('随机'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.web),
                    label: Text('浏览'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('我的'),
                  ),
                ],
              ),

            // 真正的页面内容
            Expanded(
              child: Container(
                color: Colors.grey[100],

                // child: _pages[_currentIndex], // 根据索引显示对应的页面
                child: IndexedStack(
                  index: _currentIndex, // 告诉它当前显示哪一个
                  children: _pages, // 所有的页面都会被加载并保存在内存中
                ),
              ),
            ),
          ],
        ),

        // 如果是窄屏，显示底部导航栏 (Android 适配)
        bottomNavigationBar: isWideScreen
            ? null
            : BottomNavigationBar(
                currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                // 点击底部菜单时触发
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: '主页'),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.summarize),
                    label: '汇总',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.video_library),
                    label: '随机',
                  ),
                  BottomNavigationBarItem(icon: Icon(Icons.web), label: '浏览'),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: '我的',
                  ),
                ],
              ),
      ),
    );
  }
}
