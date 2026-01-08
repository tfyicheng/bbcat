import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/app_storage.dart';

class IsarService {
  static late Isar isar;

  // 1. 初始化数据库
  static Future<void> init() async {
    // 获取不同平台下的存储目录
    final dir = await getApplicationDocumentsDirectory();

    // 打开数据库，并注册我们定义的模型CollectionItemSchema,
    isar = await Isar.open(
      [AppSettingsSchema],
      directory: dir.path,
      inspector: true, // 确保这个设为 true
    );

    print("✅ Isar 初始化成功，请在调试控制台中寻找 Inspector 链接");
  }

  // --- 设置相关方法 ---

  // 保存设置项
  static Future<void> saveSetting(String key, String value) async {
    final setting = AppSettings()
      ..key = key
      ..value = value;

    // 使用 putByKey 逻辑（先找再存）
    await isar.writeTxn(() async {
      final existing = await isar.appSettings
          .filter()
          .keyEqualTo(key)
          .findFirst();
      if (existing != null) {
        setting.id = existing.id;
      }
      await isar.appSettings.put(setting);
    });
  }

  // 读取设置项
  static Future<String?> getSetting(String key) async {
    final setting = await isar.appSettings.filter().keyEqualTo(key).findFirst();
    return setting?.value;
  }

  // --- 收藏相关方法 ---

  // 添加收藏
  // static Future<void> addCollection(CollectionItem item) async {
  //   await isar.writeTxn(() async {
  //     await isar.collectionItems.put(item);
  //   });
  // }

  // // 获取所有收藏（按时间倒序）
  // static Future<List<CollectionItem>> getAllCollections() async {
  //   return await isar.collectionItems.where().sortByCreateTimeDesc().findAll();
  // }

  // // 删除收藏
  // static Future<void> deleteCollection(int id) async {
  //   await isar.writeTxn(() async {
  //     await isar.collectionItems.delete(id);
  //   });
  // }
}
