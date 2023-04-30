import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vocal_for_local/auth/view/login_screen.dart';
import 'package:vocal_for_local/utils/firebase_main.dart';
import 'package:vocal_for_local/utils/shared_preference.dart';

import '../../utils/custom_dialoge.dart';
import '../../utils/firebase_consts.dart';

class DashboardController {
  Future<void> signout(BuildContext context) async {
    bool isSuccess = false;
    try {
      isSuccess = await FirebaseMain().googleLogout();
      if (isSuccess) {
        Shared_Preference.setBool(SharedPreferenceKeys.isLogin, false);
        Shared_Preference.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            (route) => false);
      }
    } catch (error) {
      if (error == FirebaseCollections.noInternetString) {
        CustomDialog().dialog(
            context: context,
            onPress: () {
              Navigator.pop(context);
              signout(context);
            },
            isCancelAvailable: true,
            successButtonName: "Retry",
            title: "No internet connection",
            content: "check your internet connectivity");
      }
    }
  }
}
