import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vocal_for_local/cart/controller/cart_controller.dart';
import 'package:vocal_for_local/orders/view/order_list_screen.dart';
import 'package:vocal_for_local/utils/shared_preference.dart';
import 'package:vocal_for_local/utils/size_constants.dart';

import '../../utils/custom_dialoge.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  num cartTotal = 0;
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(num amount) async {
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': amount * 100,
      'name': FirebaseAuth.instance.currentUser?.displayName ?? "",
      'description': 'Payment',
      'prefill': {
        'contact': FirebaseAuth.instance.currentUser?.phoneNumber,
        'email': FirebaseAuth.instance.currentUser?.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  moveDocumentToOtherCollection(String docId, String paymentId) async {
    var db = FirebaseFirestore.instance;
    var oldColl = db.collection('cart').doc(docId);
    var newColl = db.collection('orderHistory').doc(oldColl.id);

    DocumentSnapshot? snapshot = await oldColl.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        // document id does exist
        print('Successfully found document');
        Map<String, dynamic> setNewData = docSnapshot.data()!;
        setNewData["created_at"] = DateTime.now();
        setNewData["uid"] = FirebaseAuth.instance.currentUser?.uid;
        setNewData["order_amount"] = cartTotal;
        setNewData["payment_id"] = paymentId;
        newColl
            .set(setNewData)
            .then((value) => print("document moved to orderHistory collection"))
            .catchError((error) => print("Failed to move document: $error"))
            .then((value) {
          Shared_Preference.remove("currentOrderId");
          return ({
            oldColl
                .delete()
                .then((value) => print("document removed from old collection"))
                .catchError((error) {
              newColl.delete();
              print("Failed to delete document: $error");
            })
          });
        });
      } else {
        //document id doesnt exist
        print('Failed to find document id');
      }
      return null;
    });
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    this.context.loaderOverlay.show();
    Logger().d(
      "SUCCESS: ${response.paymentId}",
    );
    if (response.paymentId != null && response.paymentId != "") {
      await moveDocumentToOtherCollection(
          Shared_Preference.getString("currentOrderId"),
          response.paymentId ?? "");

      CustomDialog().dialog(
          context: context,
          onPress: () {
            print("orderButton calling");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderListScreen(),
                ));
          },
          isCancelAvailable: true,
          title: "Payment Success",
          successButtonName: "View Order",
          content:
              "Congrats...\nYour order is successfully placed...\nDo you want to view your order?");

      this.context.loaderOverlay.hide();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomDialog().dialog(
        context: context,
        onPress: () {
          Navigator.pop(context);
        },
        title: "Purchase Error",
        content: "${response.message}",
        successButtonName: "ok",
        isCancelAvailable: false);
    Logger().d("ERROR: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('cart')
                .where("order_id",
                    isEqualTo: Shared_Preference.getString("currentOrderId"))
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs != null &&
                  snapshot.data!.docs.isNotEmpty) {
                Map<String, dynamic> productList =
                    snapshot.data!.docs.first.data()! as Map<String, dynamic>;
                cartTotal = 0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        children: productList["product_list"].map<Widget>(
                          (document) {
                            cartTotal += int.parse(document["price"]) *
                                document["count"];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: CachedNetworkImage(
                                  imageUrl: document["product_image"][0],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(document["product_name"]),
                                  const Spacer(),
                                  Text("Rs.${document["price"]}"),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //increment product button
                                  IconButton(
                                    onPressed: () async {
                                      await CartController()
                                          .incrementProductCount(
                                              context, document);
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                  // display product count
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text("${document["count"]}"),
                                  ),
                                  // decrement or remove product button
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      if (productList["product_list"].length <=
                                              1 &&
                                          document["count"] <= 1) {
                                        await CartController().clearCart();
                                      } else {
                                        await CartController()
                                            .decrementOrRemoveProduct(
                                                context, document);
                                      }
                                    },
                                    icon: document["count"] == 1
                                        ? const Icon(Icons.delete)
                                        : Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            child: const Icon(Icons.minimize)),
                                  )
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConstants.itemPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Price : Rs.$cartTotal"),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await CartController().clearCart();
                            },
                            label: const Text("Clear cart"),
                            icon: const Icon(Icons.remove_shopping_cart),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConstants.itemPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              openCheckout(cartTotal);
                            },
                            label: Text("Pay Rs.$cartTotal"),
                            icon: const Icon(Icons.attach_money),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Image.asset("assets/images/product_not_found.jpg");
              }
            },
          ),
        ],
      ),
    );
  }
}
