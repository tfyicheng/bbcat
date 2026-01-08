import 'package:flutter/material.dart';

class FakeFeedbackPage extends StatefulWidget {
  final VoidCallback onUnlocked; // 定义一个解锁后的回调

  const FakeFeedbackPage({super.key, required this.onUnlocked});

  @override
  State<FakeFeedbackPage> createState() => _FakeFeedbackPageState();
}

class _FakeFeedbackPageState extends State<FakeFeedbackPage> {
  int _clickCount = 0; // 记录点击次数

  void _handleVersionClick() {
    _clickCount++;
    if (_clickCount >= 2) {
      // 点击5次触发解锁
      widget.onUnlocked();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("问题反馈"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: "请描述您遇到的问题...",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("反馈已提交，我们会尽快处理"))),
              child: const Text("提交反馈"),
            ),
            const Spacer(),
            // 底部版本号，点击5次“破防”
            GestureDetector(
              onTap: _handleVersionClick,
              child: Text(
                "Version 1.0.2", // 看起来很平常的版本号
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
