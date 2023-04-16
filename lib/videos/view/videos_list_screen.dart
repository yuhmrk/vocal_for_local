import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vocal_for_local/utils/custom_dialoge.dart';
import 'package:vocal_for_local/videos/view/video_description_screen.dart';

class VideosListScreen extends StatefulWidget {
  const VideosListScreen({Key? key}) : super(key: key);

  @override
  State<VideosListScreen> createState() => _VideosListScreenState();
}

class _VideosListScreenState extends State<VideosListScreen> {
  Stream<QuerySnapshot>? _videosStream;
  DocumentSnapshot? currentUser;
  Map<String, dynamic>? currentUserMap;
  List? authVideoListId = [];
  Map<String, dynamic> selectedVideoData = {};
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(context);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  fetchCurrentUser(BuildContext context) async {
    context.loaderOverlay.show();
    currentUser = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    currentUserMap = currentUser!.data() as Map<String, dynamic>;

    if (currentUserMap!["auth_videos_id"] != null) {
      authVideoListId = currentUserMap!["auth_videos_id"];
    }

    DateTime currentDate = DateTime.now();
    List tempVideoList = [];
    for (int i = 0; i < authVideoListId!.length; i++) {
      Timestamp videoDate = authVideoListId![i]["duration"];
      DateTime compareDate =
          DateTime.fromMillisecondsSinceEpoch(videoDate.millisecondsSinceEpoch);
      bool isValid = currentDate.isBefore(compareDate);
      if (isValid) {
        tempVideoList.add(authVideoListId![i]);
      }
    }
    if (authVideoListId!.length > tempVideoList.length) {
      authVideoListId = tempVideoList;
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"auth_videos_id": authVideoListId});
    }

    context.loaderOverlay.hide();
    setState(() {});
  }

  void openCheckout(String amount) async {
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': int.parse(amount.toString()) * 100,
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    this.context.loaderOverlay.show();
    Logger().d(
      "SUCCESS: ${response.paymentId}",
    );

    DateTime videoExpiryDate = DateTime.now()
        .subtract(Duration(days: selectedVideoData["videoAvailableDays"]));
    authVideoListId!
        .add({"id": selectedVideoData["id"], "duration": videoExpiryDate});
    setState(() {});
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"auth_videos_id": authVideoListId});
    this.context.loaderOverlay.hide();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => VideoDescriptionScreen(
        title: selectedVideoData["title"],
        videoUrl: selectedVideoData["video_url"],
        description: selectedVideoData["description"],
      ),
    ));
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
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
    _videosStream = FirebaseFirestore.instance.collection('videos').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Videos",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: context.loaderOverlay.visible
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _videosStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      bool isVideoAvailable = authVideoListId!.any((element) =>
                          element.values.contains(data["id"]) as bool);
                      return ListTile(
                        onTap: () {
                          if (authVideoListId!.contains(data["id"])) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoDescriptionScreen(
                                title: data["title"],
                                videoUrl: data["video_url"],
                                description: data["description"],
                              ),
                            ));
                          } else {
                            CustomDialog().dialog(
                                context: context,
                                onPress: () {
                                  Navigator.of(context).pop();
                                  selectedVideoData = data;
                                  openCheckout(data["price"]);
                                },
                                isCancelAvailable: true,
                                title: "Video Purchase",
                                successButtonName: "Pay Rs.${data["price"]}",
                                content:
                                    "${data["title"]} is a paid video, if you want to watch the video, you need to purchase it. Do you want to purchase?");
                          }
                        },
                        title: Text(data["title"]),
                        trailing: isVideoAvailable
                            ? const Icon(Icons.lock_open)
                            : const Icon(Icons.lock),
                      );
                    }).toList(),
                  );
                } else {
                  return const SizedBox(
                    width: 0,
                    height: 0,
                  );
                }
              },
            ),
    );
  }
}
