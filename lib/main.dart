import 'package:final_quizlet_english/change_password.dart';
import 'package:final_quizlet_english/profile.dart';
import 'package:final_quizlet_english/signin.dart';
import 'package:final_quizlet_english/signup.dart';
import 'package:final_quizlet_english/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}
