import 'package:isar/isar.dart';

part 'favorite_zhubo.g.dart';

@collection
class FavoriteZhubo {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String title; // 用标题作为唯一标识进行匹配更新

  late String img;
  late String address;
  late DateTime updateTime; // 用于排序：更新过的排在前面
}
