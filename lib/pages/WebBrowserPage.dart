import 'package:flutter/material.dart';
import '../widgets/web_component.dart';
import '../services/isar_service.dart';

class WebBrowserPage extends StatefulWidget {
  const WebBrowserPage({super.key});

  @override
  State<WebBrowserPage> createState() => _WebBrowserPageState();
}

class _WebBrowserPageState extends State<WebBrowserPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      // 从 Isar 读取 key 为 'default_home' 的配置
      future: IsarService.getSetting('default_home'),
      builder: (context, snapshot) {
        // 如果还在加载，显示进度条
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 获取配置的网址，如果没有设置，则默认为百度
        String homeUrl =
            snapshot.data ?? 'https://hv7dz1.qgzyxhpx.xyz/category/wpcz/';

        // 关键点：使用 UniqueKey 确保当设置改变重新进入时，组件能正确重载
        return WebComponent(key: ValueKey(homeUrl), initialUrl: homeUrl);
      },
    );
  }
}
