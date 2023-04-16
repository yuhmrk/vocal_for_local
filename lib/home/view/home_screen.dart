import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vocal_for_local/utils/colors.dart';
import 'package:vocal_for_local/utils/size_constants.dart';
import 'banner_widget.dart';
import 'drawer_widget.dart';
import 'homepage_display_item.dart';
import 'homepage_display_products_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Text(
              "Hi, ",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: Colors.grey, fontSize: 14),
            ),
            Text(
              FirebaseAuth.instance.currentUser?.displayName!.split(" ")[0] ??
                  "",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  ?.copyWith(color: Colors.black),
            ),
          ],
        ),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      drawer: customDrawer(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const BannerCrousel(),
            HomepageDisplayProducts(productListName: "Featured Product"),
            HomepageDisplayProducts(
                productListName: "New Products", categoryName: "new"),
          ],
        ),
      ),
    );
  }
}
