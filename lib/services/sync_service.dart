import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import '../models/favorite_zhubo.dart';
import 'api_service.dart';

class SyncService {
  static bool _isSyncing = false; // 防止重复同步

  static Future<String> syncFavorites(Isar isar) async {
    if (_isSyncing) return "正在同步中...";
    _isSyncing = true;

    try {
      final favorites = await isar.favoriteZhubos.where().findAll();
      if (favorites.isEmpty) {
        _isSyncing = false;
        return "更新 0/0 个";
      }

      int updatedCount = 0;
      final platforms = await ApiService.getPlatforms();

      for (var pf in platforms) {
        final subList = await ApiService.getZhuboList(pf['address']);

        for (var fav in favorites) {
          // 查找标题匹配的主播
          final latestData = subList.firstWhere(
            (item) => item['title'] == fav.title,
            orElse: () => null,
          );

          if (latestData != null) {
            // 如果链接或图片变了，则更新并提升排序
            if (fav.address != latestData['address'] ||
                fav.img != latestData['img']) {
              await isar.writeTxn(() async {
                fav.address = latestData['address'];
                fav.img = latestData['img'];
                fav.updateTime = DateTime.now();
                await isar.favoriteZhubos.put(fav);
              });
              updatedCount++;
            }
          }
        }
      }
      _isSyncing = false;
      return "已更新 $updatedCount/${favorites.length} 个";
    } catch (e) {
      _isSyncing = false;
      return "更新失败: $e";
    }
  }
}
