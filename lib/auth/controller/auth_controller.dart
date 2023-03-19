// function to implement the google signin

// creating firebase instance
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vocal_for_local/auth/model/logged_in_user_model.dart';
import 'package:vocal_for_local/dashboard/view/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal_for_local/utils/custom_dialoge.dart';
import 'package:vocal_for_local/utils/firebase_consts.dart';
import 'package:vocal_for_local/utils/firebase_main.dart';
import 'package:vocal_for_local/utils/shared_preference.dart';

Future<bool> signup(BuildContext context) async {
  bool isSuccess = false;
  try {
    isSuccess = await FirebaseMain().googleLogin();
    if (isSuccess) {
      return isSuccess;
    }
  } catch (error) {
    if (error == FirebaseCollections.noInternetString) {
      CustomDialog().dialog(
          context: context,
          onPress: () {
            Navigator.pop(context);
            signup(context);
          },
          isCancelAvailable: true,
          successButtonName: "Retry",
          title: "No internet connection",
          content: "check your internet connectivity");
    }
  }
  return isSuccess;
}
