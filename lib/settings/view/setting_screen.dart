import 'package:flutter/material.dart';

import '../../dashboard/controller/controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
            onPressed: () {
              signout(context);
            },
            icon: Icon(Icons.login_outlined),
            label: Text("Logout")),
      ),
    );
  }
}
