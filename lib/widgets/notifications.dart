import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showScaffoldMessage(
    BuildContext context, String message) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}

getDialog(BuildContext context, String title, String message) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(message),
      ]),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK', style: TextStyle(color: Colors.lightGreen)),
        ),
      ],
    ),
  );
}
