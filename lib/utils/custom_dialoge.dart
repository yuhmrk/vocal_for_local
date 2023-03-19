import 'package:flutter/material.dart';

class CustomDialog {
  Future<void> dialog(
      {required BuildContext context,
      required Function onPress,
      required String title,
      required String content,
      required String successButtonName,
      required bool isCancelAvailable}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                return onPress();
              },
              child: Text(successButtonName),
            ),
            Visibility(
              visible: isCancelAvailable == true,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
