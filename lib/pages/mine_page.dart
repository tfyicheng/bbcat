import 'package:bbcat/pages/history_manage_page.dart';
import 'package:bbcat/pages/web_favorites_manage_page.dart';
import 'package:bbcat/pages/fav_list_page.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'settings_page.dart'; // 稍后创建

class ProfilePage extends StatelessWidget {
  final Isar isar;
  const ProfilePage({super.key, required this.isar});

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
                "用户N",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // 功能列表
        // _buildMenuTile(context, Icons.favorite_outline, "我的收藏", () {}),
        _buildMenuTile(context, Icons.live_tv, "直播收藏", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // 确保你的个人中心类中持有 isar 变量并能正确传递
              builder: (context) => FavListPage(isar: isar),
            ),
          );
        }),

        _buildMenuTile(context, Icons.bookmark_border, "网页收藏", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WebFavoritesManagePage(),
            ),
          );
        }),

        _buildMenuTile(context, Icons.history, "浏览记录", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryManagePage()),
          );
        }),
        // _buildMenuTile(context, Icons.history, "播放记录", () {}),
        _buildMenuTile(context, Icons.settings_outlined, "设置", () {
          // 点击进入设置页面
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        }),
        // _buildMenuTile(context, Icons.info_outline, "关于我们", () {}),
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
