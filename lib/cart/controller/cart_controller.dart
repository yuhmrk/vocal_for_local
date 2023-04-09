import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../utils/shared_preference.dart';

class CartController {
  Future<void> incrementProductCount(
      BuildContext context, Map<String, dynamic> document) async {
    context.loaderOverlay.show();
    DocumentSnapshot currentCartOrder = await FirebaseFirestore.instance
        .collection("cart")
        .doc(Shared_Preference.getString("currentOrderId"))
        .get();
    Map<String, dynamic> currentOrderMap =
        currentCartOrder.data() as Map<String, dynamic>;
    bool checkProductExist = currentOrderMap["product_list"]
        .any((element) => element.values.contains(document["id"]) as bool);
    if (checkProductExist) {
      var element = currentOrderMap["product_list"].firstWhere(
          (k) => k.values.contains(document["id"]) as bool,
          orElse: () => {});
      var index = currentOrderMap["product_list"].indexOf(element);
      element.update("count", (v) => element["count"] + 1);
      currentOrderMap["product_list"][index] = element;
      FirebaseFirestore.instance
          .collection("cart")
          .doc(Shared_Preference.getString("currentOrderId"))
          .update({"product_list": currentOrderMap["product_list"]});
      context.loaderOverlay.hide();
    }
  }

  Future<void> decrementOrRemoveProduct(
      BuildContext context, Map<String, dynamic> document) async {
    if (document["count"] > 1) {
      context.loaderOverlay.show();
      DocumentSnapshot currentCartOrder = await FirebaseFirestore.instance
          .collection("cart")
          .doc(Shared_Preference.getString("currentOrderId"))
          .get();
      Map<String, dynamic> currentOrderMap =
          currentCartOrder.data() as Map<String, dynamic>;
      bool checkProductExist = currentOrderMap["product_list"]
          .any((element) => element.values.contains(document["id"]) as bool);
      if (checkProductExist) {
        var element = currentOrderMap["product_list"].firstWhere(
            (k) => k.values.contains(document["id"]) as bool,
            orElse: () => {});
        int index = currentOrderMap["product_list"].indexOf(element);
        element.update("count", (v) => element["count"] - 1);
        currentOrderMap["product_list"][index] = element;
        FirebaseFirestore.instance
            .collection("cart")
            .doc(Shared_Preference.getString("currentOrderId"))
            .update({"product_list": currentOrderMap["product_list"]});
        // Future.delayed(Duration(seconds: 1));
        context.loaderOverlay.hide();
      }
    } else {
      context.loaderOverlay.show();
      DocumentSnapshot currentCartOrder = await FirebaseFirestore.instance
          .collection("cart")
          .doc(Shared_Preference.getString("currentOrderId"))
          .get();
      Map<String, dynamic> currentOrderMap =
          currentCartOrder.data() as Map<String, dynamic>;
      bool checkProductExist = currentOrderMap["product_list"]
          .any((element) => element.values.contains(document["id"]) as bool);
      if (checkProductExist) {
        List allProductsInCart = [];
        Map<String, dynamic> element = currentOrderMap["product_list"]
            .firstWhere((k) => k.values.contains(document["id"]) as bool,
                orElse: () => {});
        int index = currentOrderMap["product_list"].indexOf(element);
        allProductsInCart = currentOrderMap["product_list"];
        allProductsInCart.removeAt(index);
        currentOrderMap["product_list"] = allProductsInCart;
        FirebaseFirestore.instance
            .collection("cart")
            .doc(Shared_Preference.getString("currentOrderId"))
            .update({"product_list": currentOrderMap["product_list"]});
        context.loaderOverlay.hide();
      }
    }
  }

  Future<void> clearCart() async {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(Shared_Preference.getString("currentOrderId"))
        .delete();
    Shared_Preference.remove("currentOrderId");
  }
}
