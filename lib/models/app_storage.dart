import 'package:isar/isar.dart';

// 必须运行命令生成这个文件: flutter pub run build_runner build
part 'app_storage.g.dart';

// 1. 设置表
@collection
class AppSettings {
  Id id = 0; // 每个模型都需要一个 Id，0 代表自动增长或固定主键

  @Index(unique: true)
  late String key; // 设置项的名称，如 "selected_mask"

  String? value; // 设置项的值
}

// 2. 收藏表
// @collection
// class CollectionItem {
//   Id id = Isar.autoIncrement; // 自动增长 ID

//   late String title;    // 标题
//   late String url;      // 视频或链接地址
//   late String coverUrl; // 封面图
  
//   @Index()
//   late DateTime createTime; // 收藏时间，方便排序
// }