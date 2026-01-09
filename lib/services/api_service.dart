import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://api.hclyz.com:81/mf/";

  // 获取首页平台列表
  static Future<List<dynamic>> getPlatforms() async {
    final response = await http.get(Uri.parse("${baseUrl}json.txt"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['pingtai'];
    }
    return [];
  }

  // 获取二级主播列表
  static Future<List<dynamic>> getZhuboList(String address) async {
    // 拼接地址
    final response = await http.get(Uri.parse("$baseUrl$address"));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      return data['zhubo'];
    }
    return [];
  }
}
