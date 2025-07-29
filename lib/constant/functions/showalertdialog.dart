import 'package:chat/constant/class/colors.dart';
import 'package:flutter/material.dart';

Future showAlertDialog(
  BuildContext context,
  String title,
  String content, [
  final void Function()? onPressedOk,
  final void Function()? onPressedCancel,
]) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: MyColors.bg03,
        title: Text(textAlign: TextAlign.center, title),
        content: Text(content),
        actions: [
          ElevatedButton(onPressed: onPressedOk, child: const Text("OK")),
          const SizedBox(width: 50.0),

          ElevatedButton(
            onPressed: onPressedCancel,
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}

Future<void> functionShowAlertDialog(
  BuildContext context,
  String title,
  String content,
  String textOkButton,
  String textCancelButton, [
  final void Function()? onPressedOk,
  final void Function()? onPressedCancel,
]) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: MyColors.bg03,
        title: Text(textAlign: TextAlign.center, title),
        content: Text(content),
        actions: [
          ElevatedButton(onPressed: onPressedOk, child: Text(textOkButton)),
          const SizedBox(width: 50.0),
          ElevatedButton(
            onPressed: onPressedCancel,
            child: Text(textCancelButton),
          ),
        ],
      );
    },
  );
}
