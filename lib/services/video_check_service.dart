import 'package:http/http.dart' as http;

class VideoCheckService {
  static Future<bool> checkUrl(String url) async {
    try {
      // 1. 必须使用 head 方法，只拿 header，不拿 body
      final response = await http
          .head(Uri.parse(url))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) return true;

      // 2. 有些直播服务器不支持 HEAD 请求，会返回 405，这时再尝试用 GET 但只读一丁点数据
      if (response.statusCode == 405 || response.statusCode == 404) {
        // 如果 HEAD 不行，可以尝试发起一个普通的客户端连接，成功即关闭
        final client = http.Client();
        try {
          final request = http.Request('GET', Uri.parse(url));
          // 关键：通过 send 发送请求，手动关闭流，不读 body
          final streamedResponse = await client
              .send(request)
              .timeout(const Duration(seconds: 2));
          streamedResponse.stream.listen((_) {}).cancel(); // 立即取消监听
          return streamedResponse.statusCode == 200;
        } finally {
          client.close();
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
