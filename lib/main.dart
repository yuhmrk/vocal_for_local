import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal_for_local/dashboard/view/dashboard.dart';
import 'package:vocal_for_local/utils/colors.dart';
import 'package:vocal_for_local/utils/shared_preference.dart';
import 'auth/view/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Shared_Preference.init();
  // initializing the firebase app
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocal for local',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ThemeColors.primaryColor,
        fontFamily: 'noto_sans',
        textTheme: const TextTheme(
          headline2: TextStyle(
              fontFamily: "noto_sans", fontSize: 16, color: Colors.amberAccent),
        ),
      ),
      home: LoaderOverlay(
        duration: const Duration(milliseconds: 250),
        reverseDuration: const Duration(milliseconds: 250),
        child: Shared_Preference.getBool(SharedPreferenceKeys.isLogin) == true
            ? const Dashboard()
            : const LoginScreen(),
      ),
    );
  }
}
