import 'package:bbcat/models/browsing_history.dart';
import 'package:bbcat/models/favorite_zhubo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/app_storage.dart'; // 包含 AppSettingsSchema
import '../models/web_favorite.dart'; // 包含 WebFavoriteSchema

class IsarService {
  // 统一使用这一个实例
  static Isar? _instance;

  // 获取数据库实例（单例模式）
  static Future<Isar> get db async {
    // 1. 如果已存在且开启，直接返回
    if (_instance != null && _instance!.isOpen) {
      return _instance!;
    }

    // 2. 检查是否有已经存在的实例（防止热重载冲突）
    final existingInstance = Isar.getInstance();
    if (existingInstance != null) {
      _instance = existingInstance;
      return _instance!;
    }

    // 3. 执行打开逻辑：【注意】这里必须包含所有 Schema！！
    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        FavoriteZhuboSchema, // 直播收藏模型
        AppSettingsSchema, // 设置模型
        WebFavoriteSchema, // 网页收藏模型
        BrowsingHistorySchema, // 浏览历史模型
      ],
      directory: dir.path,
      inspector: true,
    );

    print("✅ Isar 实例启动成功");
    return _instance!;
  }

  // 为了兼容你之前的 init 调用，保留此方法但指向 db
  static Future<void> init() async {
    await db;
  }

  // --- 设置相关方法 ---

  // 保存设置项
  static Future<void> saveSetting(String key, String value) async {
    final isarInst = await db;

    // 1. 查找是否已经存在该 Key 的设置
    final existing = await isarInst.appSettings
        .filter()
        .keyEqualTo(key) // 确保这里是根据唯一的 Key 来找
        .findFirst();

    await isarInst.writeTxn(() async {
      final setting = AppSettings()
        ..key = key
        ..value = value;

      if (existing != null) {
        // 2. 关键：如果找到了，必须把旧的 ID 赋给新对象，Isar 才会执行“更新”而不是“新增”
        setting.id = existing.id;
      }

      // 3. 执行写入
      await isarInst.appSettings.put(setting);
    });
  }

  static Future<String?> getSetting(String key) async {
    final isarInst = await db;
    final setting = await isarInst.appSettings
        .filter()
        .keyEqualTo(key)
        .findFirst();
    return setting?.value;
  }

  // --- 网页收藏相关方法 ---

  static Future<void> saveWebFavorite(String url, String title) async {
    final isarInst = await db;

    await isarInst.writeTxn(() async {
      // 1. 先检查是否已经收藏过这个链接
      final existing = await isarInst.webFavorites
          .filter()
          .urlEqualTo(url)
          .findFirst();

      final favorite = WebFavorite()
        ..url = url
        ..title = title
        ..createTime = DateTime.now();

      if (existing != null) {
        // 2. 如果已存在，把旧的 ID 赋给新对象，执行更新操作
        favorite.id = existing.id;
      }

      // 3. 执行 put（现在不会报错了，因为 ID 相同会执行更新）
      await isarInst.webFavorites.put(favorite);
    });
  }

  static Future<List<WebFavorite>> getAllWebFavorites() async {
    final isarInst = await db;
    return await isarInst.webFavorites.where().sortByCreateTimeDesc().findAll();
  }

  static Future<void> deleteWebFavorite(int id) async {
    final isarInst = await db;
    await isarInst.writeTxn(() async {
      await isarInst.webFavorites.delete(id);
    });
  }

  // 1. 在 Isar.open 的 Schema 列表里加上 BrowsingHistorySchema
  //

  // 2. 保存记录并自动清理超过限制的数据
  static Future<void> saveHistory(String url, String title) async {
    final isarInst = await db;

    // 获取用户设置的限制数量，默认300
    String? limitStr = await getSetting('history_limit');
    int limit = int.tryParse(limitStr ?? '') ?? 300;

    await isarInst.writeTxn(() async {
      // 插入新记录
      final history = BrowsingHistory()
        ..url = url
        ..title = title
        ..visitTime = DateTime.now();
      await isarInst.browsingHistorys.put(history);

      // 自动清理：查询超出 limit 数量的最旧记录并删除
      final count = await isarInst.browsingHistorys.count();
      if (count > limit) {
        final oldRecords = await isarInst.browsingHistorys
            .where()
            .sortByVisitTime() // 升序，最旧的在前面
            .limit(count - limit)
            .findAll();

        final oldIds = oldRecords.map((e) => e.id).toList();
        await isarInst.browsingHistorys.deleteAll(oldIds);
      }
    });
  }

  // 3. 获取所有历史
  static Future<List<BrowsingHistory>> getAllHistory() async {
    final isarInst = await db;
    return await isarInst.browsingHistorys
        .where()
        .sortByVisitTimeDesc()
        .findAll();
  }

  // 4. 清空所有历史
  static Future<void> clearAllHistory() async {
    final isarInst = await db;
    await isarInst.writeTxn(() async {
      await isarInst.browsingHistorys.clear();
    });
  }
}
