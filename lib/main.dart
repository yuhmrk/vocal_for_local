import 'package:flutter/material.dart';
import 'auth/view/login.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initializing the firebase app
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vocal for local',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home:const Login()
    );
  }
}
