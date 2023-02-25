// function to implement the google signin

// creating firebase instance
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vocal_for_local/dashboard/view/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal_for_local/utils/shared_preference.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> signup(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // Getting users credential
    UserCredential result = await auth.signInWithCredential(authCredential);
    User? user = result.user;

    if (result != null) {
      Shared_Preference.setBool(SharedPreferenceKeys.isLogin, true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    }
  }
}
