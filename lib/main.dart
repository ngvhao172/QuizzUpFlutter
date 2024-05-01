import 'package:final_quizlet_english/firebase_options.dart';
import 'package:final_quizlet_english/screens/PasswordChange.dart';
import 'package:final_quizlet_english/screens/Profile.dart';
import 'package:final_quizlet_english/screens/SignIn.dart';
import 'package:final_quizlet_english/screens/signup.dart';
import 'package:final_quizlet_english/screens/ProfileUpdate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/Splash.dart';
import 'package:final_quizlet_english/screens/TopicCreate.dart';
import 'package:final_quizlet_english/screens/TopicSetting.dart';
import 'package:final_quizlet_english/screens/Library.dart';
import 'package:final_quizlet_english/screens/TopicDetail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: TDetailPage(),
    );
  }
}
