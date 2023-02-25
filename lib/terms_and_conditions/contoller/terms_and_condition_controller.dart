import 'package:logger/logger.dart';
import 'package:vocal_for_local/api_services/api_services.dart';
import '../../api_services/environment.dart';

class TermsAndConditionController {
  static Future termsAndCondition() async {
    String params = "?token=n9odeaDrTpLxhlS7140WHRGSmIwKpKP7";
    Uri tcUrl = Uri.parse(Environment.base_url + EndPoints.live + params);
    dynamic tcApiCall = await ApiServices.getMethod(tcUrl);
    return tcApiCall.body;
  }
}
