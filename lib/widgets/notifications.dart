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
Future<dynamic> showDialogMessage(BuildContext context, String message, Function negativeFunction, Function positiveFunction, String negative, String positive) {
    return showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, animation1, animation2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(animation1),
              child: FadeTransition(
                  opacity:
                      Tween<double>(begin: 0.5, end: 1).animate(animation1),
                  child: AlertDialog(
                    content: Text(message),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          negativeFunction();
                        },
                        child: Text(negative,
                            style: TextStyle(color: Colors.orange)),
                      ),
                      TextButton(
                        onPressed: () {
                          positiveFunction();
                        },
                        child: Text(positive,
                            style: TextStyle(color: Colors.lightGreen)),
                      ),
                    ],
                  )));
        });
  }
