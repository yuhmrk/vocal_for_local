import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vocal_for_local/utils/colors.dart';
import 'package:vocal_for_local/utils/size_constants.dart';
import 'banner_widget.dart';
import 'drawer_widget.dart';
import 'homepage_display_item.dart';

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
            const HomepageDisplayProdutcs(productListName: "Featured Product"),
            const HomepageDisplayProdutcs(productListName: "Liked Products"),
          ],
        ),
      ),
    );
  }
}

class HomepageDisplayProdutcs extends StatelessWidget {
  const HomepageDisplayProdutcs({
    Key? key,
    required this.productListName,
  }) : super(key: key);

  final String productListName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConstants.appPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productListName, style: Theme.of(context).textTheme.subtitle1),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.315,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => const HomePageDisplayItem(
                productImagePath: "assets/images/image_one.jpg",
                productName: "product name",
                productPrice: "Rs. 200",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
