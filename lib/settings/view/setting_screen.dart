import 'package:flutter/material.dart';
import 'package:vocal_for_local/orders/view/order_list_screen.dart';

import '../../dashboard/controller/dashboard_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(child: Text("your logo"))),
          ListTile(
            title: const Text("Orders"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const OrderListScreen(),
            )),
          ),
          const ListTile(
            title: Text("Liked Products"),
          )
        ],
      ),
    );
  }
}
