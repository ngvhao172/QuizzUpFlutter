import 'package:final_quizlet_english/services/Auth.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final AuthService auth;
  Provider({
    Key? key,
    required this.auth,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWiddget) {
    return true;
  }

  static Provider? of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>());
}