import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vocal_for_local/cart/controller/cart_controller.dart';
import 'package:vocal_for_local/utils/shared_preference.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await CartController().clearCart();
            },
            child: const Text("Clear cart"),
          ),
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
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 300,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: productList["product_list"].map<Widget>(
                      (document) {
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
                                      .incrementProductCount(context, document);
                                },
                                icon: const Icon(Icons.add),
                              ),
                              // display product count
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text("${document["count"]}"),
                              ),
                              // decrement or remove product button
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  await CartController()
                                      .decrementOrRemoveProduct(
                                          context, document);
                                },
                                icon: document["count"] == 1
                                    ? const Icon(Icons.delete)
                                    : Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        child: const Icon(Icons.minimize)),
                              )
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
