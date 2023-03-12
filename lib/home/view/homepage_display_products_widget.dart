import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        // List typesList = data["type"];
                        // typesList.contains("featured")
                        print("image is ${data["product_image"][0]}");
                        return HomePageDisplayItem(
                          productImagePath: data["product_image"][0],
                          productName: data["product_name"],
                          productPrice: data["price"],
                          // onTap: () async {
                          //   context.loaderOverlay.show();
                          //   String currentOrderId =
                          //       Shared_Preference.getString("currentOrderId");
                          //   if (currentOrderId == "N/A") {
                          //     Map<String, dynamic> passDataToCart = {};
                          //     currentOrderId =
                          //         CustomFunction().getCurrentTimeInInt();
                          //     Shared_Preference.setString(
                          //         "currentOrderId", currentOrderId);
                          //     data["count"] = 1;
                          //     passDataToCart = {
                          //       "order_id": currentOrderId,
                          //       "product_list": [data],
                          //     };
                          //     FirebaseFirestore.instance
                          //         .collection("cart")
                          //         .doc(currentOrderId)
                          //         .set(passDataToCart);
                          //     context.loaderOverlay.hide();
                          //   } else {
                          //     DocumentSnapshot currentCartOrder =
                          //         await FirebaseFirestore.instance
                          //             .collection("cart")
                          //             .doc(currentOrderId)
                          //             .get();
                          //     Map<String, dynamic> currentOrderMap =
                          //         currentCartOrder.data()
                          //             as Map<String, dynamic>;
                          //     bool checkProductExist =
                          //         currentOrderMap["product_list"].any(
                          //             (element) => element.values
                          //                 .contains(data["id"]) as bool);
                          //     if (checkProductExist) {
                          //       var element = currentOrderMap["product_list"]
                          //           .firstWhere(
                          //               (k) => k.values.contains(data["id"])
                          //                   as bool,
                          //               orElse: () => {});
                          //       var index = currentOrderMap["product_list"]
                          //           .indexOf(element);
                          //       print("index");
                          //       print(index);
                          //       element.update(
                          //           "count", (v) => element["count"] + 1);
                          //       currentOrderMap["product_list"][index] =
                          //           element;
                          //       FirebaseFirestore.instance
                          //           .collection("cart")
                          //           .doc(currentOrderId)
                          //           .update({
                          //         "product_list":
                          //             currentOrderMap["product_list"]
                          //       });
                          //       context.loaderOverlay.hide();
                          //     } else {
                          //       data["count"] = 1;
                          //       currentOrderMap["product_list"].add(data);
                          //       FirebaseFirestore.instance
                          //           .collection("cart")
                          //           .doc(currentOrderId)
                          //           .update({
                          //         "product_list":
                          //             currentOrderMap["product_list"]
                          //       });
                          //       context.loaderOverlay.hide();
                          //       return;
                          //     }
                          //   }
                          // },
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
