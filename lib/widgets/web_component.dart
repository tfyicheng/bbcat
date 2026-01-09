import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/isar_service.dart'; // 引入你的数据库服务

class WebComponent extends StatefulWidget {
  final String initialUrl;
  final bool showAppBar;

  const WebComponent({
    super.key,
    required this.initialUrl,
    this.showAppBar = true,
  });

  @override
  State<WebComponent> createState() => _WebComponentState();
}

class _WebComponentState extends State<WebComponent> {
  late WebViewController _controller;
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _urlController.text = widget.initialUrl;
    _initController();
  }

  void _initController() {
    if (Platform.isAndroid || Platform.isIOS) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) => setState(() => _isLoading = true),
            onPageFinished: (url) {
              setState(() {
                _isLoading = false;
                _urlController.text = url;
              });
              // 异步保存历史记录
              _controller?.getTitle().then((title) {
                IsarService.saveHistory(url, title ?? "无标题");
              });
            },
            onNavigationRequest: _handleDeepLink,
          ),
        )
        ..loadRequest(Uri.parse(widget.initialUrl));
    }
  }

  Future<NavigationDecision> _handleDeepLink(NavigationRequest request) async {
    if (request.url.startsWith('http')) return NavigationDecision.navigate;
    try {
      final url = Uri.parse(request.url);
      if (await canLaunchUrl(url))
        await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {}
    return NavigationDecision.prevent;
  }

  // 搜索/跳转逻辑
  void _onSearch() {
    String url = _urlController.text.trim();
    if (url.isEmpty) return;
    if (!url.contains('.')) {
      url = 'https://www.baidu.com/s?wd=$url';
    } else if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    _controller?.loadRequest(Uri.parse(url));
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // 如果是 Windows，显示一个占位 UI，不渲染 WebViewWidget
    if (Platform.isWindows) {
      return Scaffold(
        appBar: widget.showAppBar
            ? AppBar(title: Text("浏览器 (Windows模式)"))
            : null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.desktop_windows, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text("Windows 端内嵌网页暂未开启"),
              TextButton(
                onPressed: () => launchUrl(Uri.parse(_urlController.text)),
                child: const Text("点击使用外部浏览器打开"),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _controller.canGoBack()) {
          await _controller.goBack();
        } else {
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: widget.showAppBar
            ? AppBar(
                titleSpacing: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    if (await _controller.canGoBack()) {
                      await _controller.goBack();
                    } else if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
                title: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      hintText: "搜索或输入网址",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                // --- 这里补回右侧的两个菜单按钮 ---
                actions: [
                  IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: _onSearch,
                  ),
                  _buildMenu(),
                ],
                bottom: _isLoading
                    ? const PreferredSize(
                        preferredSize: Size.fromHeight(2),
                        child: LinearProgressIndicator(minHeight: 2),
                      )
                    : null,
              )
            : null,
        body: WebViewWidget(controller: _controller),
      ),
    );
  }

  // 补回弹出菜单
  Widget _buildMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        switch (value) {
          case 'forward':
            if (await _controller.canGoForward()) await _controller.goForward();
            break;
          case 'refresh':
            await _controller.reload();
            break;
          case 'favorite':
            final url = await _controller.currentUrl() ?? "";
            final title = await _controller.getTitle() ?? "未命名网页";
            if (url.isNotEmpty) {
              await IsarService.saveWebFavorite(url, title);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("已加入收藏夹"),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'forward',
          child: ListTile(
            leading: Icon(Icons.arrow_forward),
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
            leading: Icon(Icons.star_border, color: Colors.orange),
            title: Text("收藏网页"),
          ),
        ),
      ],
    );
  }
}
