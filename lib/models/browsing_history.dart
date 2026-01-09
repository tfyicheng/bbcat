import 'package:isar/isar.dart';

part 'browsing_history.g.dart';

@collection
class BrowsingHistory {
  Id id = Isar.autoIncrement;

  @Index() // 索引网址，方便查询
  late String url;

  late String title;

  @Index() // 索引时间，方便排序和删除旧记录
  late DateTime visitTime;
}
