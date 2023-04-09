import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../utils/custom_function.dart';
import '../../utils/shared_preference.dart';

class HomepageProductController {
  Future<void> addProductToCart(
      BuildContext context, Map<String, dynamic> data) async {
    context.loaderOverlay.show();
    String currentOrderId = Shared_Preference.getString("currentOrderId");
    if (currentOrderId == "N/A") {
      Map<String, dynamic> passDataToCart = {};
      currentOrderId = CustomFunction().getCurrentTimeInInt();
      Shared_Preference.setString("currentOrderId", currentOrderId);
      data["count"] = 1;
      passDataToCart = {
        "order_id": currentOrderId,
        "product_list": [data],
      };
      FirebaseFirestore.instance
          .collection("cart")
          .doc(currentOrderId)
          .set(passDataToCart);
      context.loaderOverlay.hide();
    } else {
      DocumentSnapshot currentCartOrder = await FirebaseFirestore.instance
          .collection("cart")
          .doc(currentOrderId)
          .get();
      Map<String, dynamic> currentOrderMap =
          currentCartOrder.data() as Map<String, dynamic>;
      bool checkProductExist = currentOrderMap["product_list"]
          .any((element) => element.values.contains(data["id"]) as bool);
      if (checkProductExist) {
        var element = currentOrderMap["product_list"].firstWhere(
            (k) => k.values.contains(data["id"]) as bool,
            orElse: () => {});
        var index = currentOrderMap["product_list"].indexOf(element);
        print("index");
        print(index);
        element.update("count", (v) => element["count"] + 1);
        currentOrderMap["product_list"][index] = element;
        FirebaseFirestore.instance
            .collection("cart")
            .doc(currentOrderId)
            .update({"product_list": currentOrderMap["product_list"]});
        context.loaderOverlay.hide();
      } else {
        data["count"] = 1;
        currentOrderMap["product_list"].add(data);
        FirebaseFirestore.instance
            .collection("cart")
            .doc(currentOrderId)
            .update({"product_list": currentOrderMap["product_list"]});
        context.loaderOverlay.hide();
        return;
      }
    }
  }
}
