import 'package:flutter/material.dart';
import 'dart:io';
// 导入刚才写的三个页面
import 'pages/home_page.dart';
import 'pages/video_page.dart';
import 'pages/mine_page.dart';
import 'pages/WebBrowserPage.dart';
import 'package:isar/isar.dart';

class MainShell extends StatefulWidget {
  final Isar isar;
  const MainShell({super.key, required this.isar});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // 1. 定义一个索引，记录当前选中的是第几个菜单
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 4. 将 isar 实例分发给需要它的子页面
    _pages = [
      HomePage(isar: widget.isar), // 传入 isar
      const VideoPage(), // 如果这个页面暂时不需要 isar 保持不变
      const WebBrowserPage(),
      ProfilePage(isar: widget.isar), // 传入 isar
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度，判断是否为宽屏（Windows/平板）
    bool isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
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
                  icon: Icon(Icons.video_library),
                  label: Text('视频流'),
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
                  icon: Icon(Icons.video_library),
                  label: '视频流',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.web), label: '浏览'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
              ],
            ),
    );
  }
}
