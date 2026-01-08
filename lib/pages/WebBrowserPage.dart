import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebBrowserPage extends StatefulWidget {
  const WebBrowserPage({super.key});

  @override
  State<WebBrowserPage> createState() => _WebBrowserPageState();
}

class _WebBrowserPageState extends State<WebBrowserPage> {
  late final WebViewController _controller;
  final TextEditingController _urlController = TextEditingController(
    text: 'https://www.baidu.com',
  );
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 初始化控制器
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // 允许 JS
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _isLoading = true),
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
              _urlController.text = url; // 页面跳转后同步输入框地址
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_urlController.text));
  }

  // 执行跳转
  void _handleLoadUrl() {
    String url = _urlController.text;
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    _controller.loadRequest(Uri.parse(url));
    FocusScope.of(context).unfocus(); // 隐藏键盘
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                hintText: "输入网址...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onSubmitted: (_) => _handleLoadUrl(),
            ),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _handleLoadUrl),
          _buildMenu(), // 菜单按钮
        ],
        bottom: _isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(minHeight: 2),
              )
            : null,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  // 展开菜单
  Widget _buildMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        switch (value) {
          case 'back':
            if (await _controller.canGoBack()) await _controller.goBack();
            break;
          case 'forward':
            if (await _controller.canGoForward()) await _controller.goForward();
            break;
          case 'refresh':
            await _controller.reload();
            break;
          case 'favorite':
            // 这里可以调用 IsarService 保存当前网址
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("已保存到收藏")));
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'back',
          child: ListTile(
            leading: Icon(Icons.arrow_back_ios),
            title: Text("上一页"),
          ),
        ),
        const PopupMenuItem(
          value: 'forward',
          child: ListTile(
            leading: Icon(Icons.arrow_forward_ios),
            title: Text("下一页"),
          ),
        ),
        const PopupMenuItem(
          value: 'refresh',
          child: ListTile(leading: Icon(Icons.refresh), title: Text("刷新")),
        ),
        const PopupMenuItem(
          value: 'favorite',
          child: ListTile(
            leading: Icon(Icons.star_border),
            title: Text("添加收藏"),
          ),
        ),
      ],
    );
  }
}
