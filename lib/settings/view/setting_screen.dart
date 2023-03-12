import 'package:flutter/material.dart';

import '../../dashboard/controller/dashboard_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
            onPressed: () {
              DashboardController().signout(context);
            },
            icon: Icon(Icons.login_outlined),
            label: Text("Logout")),
      ),
    );
  }
}
