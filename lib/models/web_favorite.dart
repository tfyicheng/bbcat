import 'package:isar/isar.dart';

// 记得运行 build_runner 生成代码
part 'web_favorite.g.dart';

@collection
class WebFavorite {
  Id id = Isar.autoIncrement;

  @Index(unique: true) // 网址唯一，防止重复收藏
  late String url;

  late String title; // 网页标题

  late DateTime createTime; // 收藏时间
}
