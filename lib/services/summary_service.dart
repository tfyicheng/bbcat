import '../services/api_service.dart';

class SummaryService {
  static Future<List<Map<String, dynamic>>> getAggregatedData(int limit) async {
    List<Map<String, dynamic>> allData = [];
    Set<String> titles = {}; // 用于快速去重

    // 1. 获取首页所有平台
    final platforms = await ApiService.getPlatforms();
    if (platforms.length < 2) return [];

    // 2. 从第二个平台开始遍历 (index 1 开始)
    for (int i = 1; i < platforms.length; i++) {
      if (allData.length >= limit) break; // 达到设置限制，停止遍历

      try {
        final subList = await ApiService.getZhuboList(platforms[i]['address']);

        for (var item in subList) {
          if (allData.length >= limit) break;

          String title = item['title'] ?? "";
          // 3. 根据标题去重
          if (!titles.contains(title)) {
            titles.add(title);
            allData.add(item);
          }
        }
      } catch (e) {
        print("跳过请求失败的平台: ${platforms[i]['title']}");
      }
    }
    return allData;
  }
}
