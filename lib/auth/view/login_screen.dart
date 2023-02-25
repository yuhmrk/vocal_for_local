import 'package:flutter/material.dart';
import 'package:vocal_for_local/auth/controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              "Vocal for Local",
              style: TextStyle(
                fontSize: 45,
              ),
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
              onPressed: () {
                signup(context);
              },
              child: const Text("Login with Google"))
        ],
      ),
    );
  }
}
