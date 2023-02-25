import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vocal_for_local/auth/view/login_screen.dart';
import 'package:vocal_for_local/utils/shared_preference.dart';

Future<void> signout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Shared_Preference.setBool(SharedPreferenceKeys.isLogin, false);
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
}
