import 'package:flutter/material.dart';
import 'package:vocal_for_local/dashboard/controller/controller.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text("Welcome to Dashboard")),
        IconButton(onPressed: (){
          signout(context);
        }, icon: Icon(Icons.logout))
      ],
    ));
  }
}
