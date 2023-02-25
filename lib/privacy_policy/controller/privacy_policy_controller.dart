import '../../api_services/api_services.dart';
import '../../api_services/environment.dart';

class PrivacyPolicyController {
  static Future privacyPolicy() async {
    String params = "?token=n9odeaDrTpLxhlS7140WHRGSmIwKpKP7";
    Uri ppUrl = Uri.parse(Environment.base_url + EndPoints.live + params);
    dynamic ppApiCall = await ApiServices.getMethod(ppUrl);
    return ppApiCall.body;
  }
}
