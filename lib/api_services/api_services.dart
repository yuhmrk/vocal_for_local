import 'package:http/http.dart' as http;

class ApiServices {
  static Future getMethod(Uri url) async {
    return await http.get(url);
  }
}
