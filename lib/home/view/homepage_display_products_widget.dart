import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vocal_for_local/home/controller/homepage_product_controller.dart';
import 'package:vocal_for_local/product_detail/view/product_detail_screen.dart';

import '../../utils/custom_function.dart';
import '../../utils/shared_preference.dart';
import '../../utils/size_constants.dart';
import 'homepage_display_item.dart';

class HomepageDisplayProducts extends StatelessWidget {
  HomepageDisplayProducts({
    Key? key,
    required this.productListName,
  }) : super(key: key);

  Stream<QuerySnapshot>? _productsStream;
  final String productListName;

  @override
  Widget build(BuildContext context) {
    _productsStream = FirebaseFirestore.instance
        .collection('products')
        .orderBy("product_name", descending: false)
        .snapshots();
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
          StreamBuilder<QuerySnapshot>(
            stream: _productsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.active) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.315,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> productData =
                            document.data()! as Map<String, dynamic>;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                      productData: productData),
                                ));
                          },
                          child: HomePageDisplayItem(
                            productImagePath: productData["product_image"][0],
                            productName: productData["product_name"],
                            productPrice: productData["price"],
                            onTap: () async {
                              await HomepageProductController()
                                  .addProductToCart(context, productData);
                            },
                          ),
                        );
                      }).toList(),
                    ));
              } else {
                return const SizedBox(
                  width: 0,
                  height: 0,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
