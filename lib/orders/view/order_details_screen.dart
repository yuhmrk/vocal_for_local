import 'package:flutter/material.dart';
import 'package:vocal_for_local/utils/size_constants.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen(
      {Key? key,
      this.productList,
      required this.paymentId,
      required this.orderDate,
      required this.orderId,
      required this.amount})
      : super(key: key);
  final productList;
  final String paymentId, orderDate, orderId;
  final amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: productList.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(productList[index]["product_name"]),
            subtitle: Text("Rs." + productList[index]["price"]),
            trailing: Text("x" + productList[index]["count"].toString()),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.all(SizeConstants.itemPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total"),
              Text("Rs.$amount"),
            ],
          ),
        )
      ]),
    );
  }
}
