import 'package:isar/isar.dart';

// 必须运行命令生成这个文件: flutter pub run build_runner build
part 'app_storage.g.dart';

// 1. 设置表
@collection
class AppSettings {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true) // 加上这个！让 Key 具备唯一性并支持自动替换
  late String key;

  late String value;
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