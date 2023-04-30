import 'package:flutter/material.dart';
import 'package:vocal_for_local/liked_products/view/liked_products_screen.dart';
import 'package:vocal_for_local/orders/view/order_list_screen.dart';

import '../../dashboard/controller/dashboard_controller.dart';
import '../../utils/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                  child: Image.asset("assets/app_icon_splash/app_icon.jpg"))),
          ListTile(
            title: const Text("Orders"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const OrderListScreen(),
            )),
          ),
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const LikedProductsScreen(),
            )),
            trailing: const Icon(Icons.chevron_right),
            title: const Text("Liked Products"),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primaryColor,
              ),
              onPressed: () {
                DashboardController().signout(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
