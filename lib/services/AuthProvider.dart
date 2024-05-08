import 'package:final_quizlet_english/services/Auth.dart';
import 'package:flutter/material.dart';

class AuthenticateProvider extends InheritedWidget {
  final AuthService auth;
  AuthenticateProvider({
    Key? key,
    required this.auth,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(AuthenticateProvider oldWidget) {
    return true;
  }

  static AuthenticateProvider? of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<AuthenticateProvider>());
}