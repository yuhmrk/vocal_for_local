import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';
import 'package:vocal_for_local/home/controller/homepage_product_controller.dart';
import 'package:vocal_for_local/product_detail/view/product_detail_screen.dart';

import '../../utils/custom_function.dart';
import '../../utils/shared_preference.dart';
import '../../utils/size_constants.dart';
import 'homepage_display_item.dart';

class HomepageDisplayProducts extends StatefulWidget {
  HomepageDisplayProducts({
    Key? key,
    required this.productListName,
    this.categoryName = "",
  }) : super(key: key);

  final String productListName, categoryName;

  @override
  State<HomepageDisplayProducts> createState() =>
      _HomepageDisplayProductsState();
}

class _HomepageDisplayProductsState extends State<HomepageDisplayProducts> {
  Stream<QuerySnapshot>? _productsStream;
  List<String> likedProducts = [];

  @override
  void initState() {
    super.initState();
    fetchLikedProduct();
  }

  Future fetchLikedProduct() async {
    likedProducts = await HomepageProductController().fetchProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.categoryName == ""
        ? _productsStream = FirebaseFirestore.instance
            .collection('products')
            .orderBy("product_name", descending: false)
            .snapshots()
        : _productsStream = FirebaseFirestore.instance
            .collection('products')
            .where("category", arrayContains: widget.categoryName)
            .orderBy("product_name", descending: false)
            .snapshots();
    return Padding(
      padding: EdgeInsets.all(SizeConstants.appPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.productListName,
              style: Theme.of(context).textTheme.subtitle1),
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

                        bool isLiked =
                            likedProducts.contains(productData["id"]);

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                      productData: productData),
                                ));
                          },
                          child: Stack(
                            children: [
                              HomePageDisplayItem(
                                productImagePath: productData["product_image"]
                                    [0],
                                productName: productData["product_name"],
                                productPrice: productData["price"],
                                onTap: () async {
                                  await HomepageProductController()
                                      .addProductToCart(context, productData);
                                },
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                    onPressed: () async {
                                      HomepageProductController()
                                          .addOrRemoveFromLike(isLiked,
                                              likedProducts, productData["id"]);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      isLiked == true
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: isLiked == true
                                          ? Colors.red
                                          : Colors.white,
                                    )),
                              )
                            ],
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
