import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocal_for_local/orders/view/order_details_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orderHistory')
                  .where("uid",
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs != null &&
                    snapshot.data!.docs.isNotEmpty) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.315,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> productData =
                              document.data()! as Map<String, dynamic>;
                          DateTime convertTimeStampToDate =
                              productData["created_at"].toDate();
                          var dt = DateTime.fromMillisecondsSinceEpoch(
                              convertTimeStampToDate.millisecond);
                          var d12 =
                              DateFormat('MM/dd/yyyy, hh:mm a').format(dt);

                          DateTime date = DateTime.parse(
                              productData["created_at"].toDate().toString());
                          String orderDate =
                              DateFormat('dd-MMM-yyy h:mm a').format(date);

                          return ListTile(
                            title: Text(orderDate),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderDetailScreen(
                                  paymentId: productData["payment_id"],
                                  orderDate: orderDate,
                                  orderId: productData["order_id"],
                                  productList: productData["product_list"],
                                  amount: productData["order_amount"],
                                ),
                              ));
                            },
                          );
                        }).toList(),
                      ));
                } else {
                  return Center(child: Text("No orders found"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
