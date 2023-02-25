import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:vocal_for_local/utils/size_constants.dart';

class DisplayHtmlData extends StatelessWidget {
  const DisplayHtmlData({
    Key? key,
    required String htmlResponse,
  })  : _tcResponse = htmlResponse,
        super(key: key);

  final String _tcResponse;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(SizeConstants.appPadding),
      child: SingleChildScrollView(child: HtmlWidget(_tcResponse)),
    );
  }
}
