import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:vocal_for_local/terms_and_conditions/contoller/terms_and_condition_controller.dart';
import 'package:vocal_for_local/utils/size_constants.dart';

import '../../utils/display_html_data.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  String _tcResponse = "";
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
    _tcResponse = await TermsAndConditionController.termsAndCondition();
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
          "Terms & Conditions",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : DisplayHtmlData(htmlResponse: _tcResponse),
    );
  }
}
