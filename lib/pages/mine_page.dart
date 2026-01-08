import 'package:flutter/material.dart';
import 'settings_page.dart'; // 稍后创建

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        // 用户简略信息区
        const Center(
          child: Column(
            children: [
              CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
              SizedBox(height: 10),
              Text(
                "开发者用户",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // 功能列表
        _buildMenuTile(context, Icons.favorite_outline, "我的收藏", () {}),
        _buildMenuTile(context, Icons.history, "播放记录", () {}),
        _buildMenuTile(context, Icons.settings_outlined, "设置", () {
          // 点击进入设置页面
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        }),
        _buildMenuTile(context, Icons.info_outline, "关于我们", () {}),
      ],
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
