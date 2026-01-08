import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ResponsiveHomePage(),
    );
  }
}

class ResponsiveHomePage extends StatelessWidget {
  const ResponsiveHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('😘·Demo')),
      // 逻辑：宽度小于 600 使用底部导航（手机），大于 600 使用侧边栏（电脑）
      body: Row(
        children: [
          if (width >= 600)
            NavigationRail(
              extended: width > 900, // 屏幕够宽时展开文字
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('首页'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('设置'),
                ),
              ],
              selectedIndex: 0,
            ),
          const VerticalDivider(thickness: 1, width: 1),
          const Expanded(child: Center(child: Text('这里是主内容区域'))),
        ],
      ),
      bottomNavigationBar: width < 600
          ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: '设置',
                ),
              ],
            )
          : null,
    );
  }
}
