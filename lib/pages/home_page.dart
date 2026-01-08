import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("主页内容", style: TextStyle(fontSize: 24)),
          SizedBox(height: 20), // 添加间距
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(), // 边框
                labelText: '请输入内容', // 标签
                hintText: '在这里输入...', // 提示文字
              ),
            ),
          ),
        ],
      ),
    );
  }
}
