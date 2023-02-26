import 'package:flutter/material.dart';
import 'package:vocal_for_local/auth/controller/auth_controller.dart';
import 'package:vocal_for_local/utils/colors.dart';

import '../../dashboard/view/dashboard.dart';
import '../../utils/shared_preference.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAgreeTc = false;
  double height = 0.0;
  double width = 0.0;
  bool _loding = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/app_icon_splash/app_icon.jpg", fit: BoxFit.fill),
          Row(
            children: [
              Checkbox(
                  value: isAgreeTc,
                  activeColor: ThemeColors.checkBoxActiveColor,
                  onChanged: (value) {
                    setState(() {
                      isAgreeTc = !isAgreeTc;
                    });
                  }),
              Container(
                width: width / 1.3,
                child: const Text(
                  "I agree the Terms&condition of the application",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          _loding == true
              ? CircularProgressIndicator(
                  color: ThemeColors.primaryColor,
                )
              : ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text("Login with Google"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.primaryColor,
                    minimumSize: Size(width / 1.5, height * 0.06),
                  ),
                  onPressed: isAgreeTc == true
                      ? () async {
                          setState(() {
                            _loding = true;
                          });
                          bool isLogin = false;
                          isLogin = await signup(context);
                          if (isLogin == true) {
                            Shared_Preference.setBool(
                                SharedPreferenceKeys.isLogin, true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard()));
                          }
                          setState(() {
                            _loding = false;
                          });
                        }
                      : null,
                )
        ],
      ),
    );
  }
}
