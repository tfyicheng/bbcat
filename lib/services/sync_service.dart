import 'dart:convert';
import 'package:bbcat/models/app_storage.dart';
import 'package:bbcat/services/isar_service.dart';
import 'package:bbcat/services/summary_service.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import '../models/favorite_zhubo.dart';
import 'api_service.dart';

class SyncService {
  static bool _isSyncing = false; // 防止重复同步

  static Future<String> syncFavorites1(Isar isar) async {
    if (_isSyncing) return "正在同步中...";
    _isSyncing = true;

    try {
      final favorites = await isar.favoriteZhubos.where().findAll();
      if (favorites.isEmpty) {
        _isSyncing = false;
        return "更新收藏 0/0 个";
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
      return "已更新收藏 $updatedCount/${favorites.length} 个";
    } catch (e) {
      _isSyncing = false;
      print("更新失败: $e");
      return "更新失败: $e";
    }
  }

  static Future<String> syncFavorites(Isar isar) async {
    if (_isSyncing) return "正在同步中...";
    _isSyncing = true;

    try {
      final favorites = await isar.favoriteZhubos.where().findAll();
      if (favorites.isEmpty) {
        _isSyncing = false;
        return "更新收藏 0/0 个";
      }

      int updatedCount = 0;
      final platforms = await ApiService.getPlatforms();

      for (var pf in platforms) {
        try {
          // --- 关键改进 1：对单个平台的请求进行捕获，防止一个报错导致全盘崩溃 ---
          final subList = await ApiService.getZhuboList(pf['address']);

          // 增加一层判断：如果 subList 为空，跳过当前平台
          if (subList == null || subList.isEmpty) continue;

          for (var fav in favorites) {
            // 查找标题匹配的主播
            final latestData = subList.firstWhere(
              (item) => item['title'] == fav.title,
              orElse: () => null,
            );

            if (latestData != null) {
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
        } catch (pfError) {
          // --- 关键改进 2：记录哪个平台出错了，但不 return，继续跑下一个平台 ---
          print("跳过出错平台 ${pf['title']}: $pfError");
          continue;
        }
      }
      _isSyncing = false;
      return "已更新收藏 $updatedCount/${favorites.length} 个";
    } catch (e) {
      _isSyncing = false;
      print("全局同步逻辑异常: $e");
      return "同步异常，请检查网络";
    }
  }

  static bool _isSummarySyncing = false;

  static Future<String> syncFromSummary(Isar isar) async {
    print("syncFromSummary: 开始同步");
    if (_isSummarySyncing) return "汇总同步中...";
    _isSummarySyncing = true;

    try {
      // 1. 获取本地所有收藏
      final favorites = await isar.favoriteZhubos.where().findAll();
      if (favorites.isEmpty) {
        _isSummarySyncing = false;
        return "没有收藏的主播";
      }

      // 2. 获取当前的汇总限制设置
      final settings = await IsarService.getSetting('summary_limit');
      int limit = int.tryParse(settings ?? '') ?? 200;

      // 3. 直接调用之前写好的 SummaryService 获取聚合数据
      // 这样就自动继承了：跳过首平台、去重、数量限制、错误容错
      final List<Map<String, dynamic>> summaryData =
          await SummaryService.getAggregatedData(limit);

      if (summaryData.isEmpty) {
        _isSummarySyncing = false;
        return "汇总数据获取失败";
      }

      int updatedCount = 0;

      // 4. 比对更新
      for (var fav in favorites) {
        // 在汇总数据中寻找同名的主播
        final latest = summaryData.firstWhere(
          (item) => item['title'] == fav.title,
          orElse: () => {},
        );

        if (latest.isNotEmpty) {
          // 如果地址或封面变了，则更新
          if (fav.address != latest['address'] || fav.img != latest['img']) {
            await isar.writeTxn(() async {
              fav.address = latest['address'];
              fav.img = latest['img'];
              fav.updateTime = DateTime.now();
              await isar.favoriteZhubos.put(fav);
            });
            updatedCount++;
          }
        }
      }

      _isSummarySyncing = false;
      return "汇总同步完成：更新收藏 $updatedCount 个";
    } catch (e) {
      _isSummarySyncing = false;
      print("汇总同步错误: $e");
      return "同步失败";
    }
  }
}
