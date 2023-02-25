import 'package:flutter/material.dart';
import 'package:vocal_for_local/privacy_policy/controller/privacy_policy_controller.dart';

import '../../utils/display_html_data.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String _ppResponse = "";
  bool _loading = false;
  @override
  void initState() {
    callApi();
    super.initState();
  }

  Future callApi() async {
    setState(() {
      _loading = true;
    });
    _ppResponse = await PrivacyPolicyController.privacyPolicy();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 35,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : DisplayHtmlData(htmlResponse: _ppResponse),
    );
  }
}
