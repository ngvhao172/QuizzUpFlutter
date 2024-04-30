import 'package:final_quizlet_english/firebase_options.dart';
import 'package:final_quizlet_english/screens/change_password.dart';
import 'package:final_quizlet_english/screens/profile.dart';
import 'package:final_quizlet_english/screens/signin.dart';
import 'package:final_quizlet_english/screens/signup.dart';
import 'package:final_quizlet_english/screens/update_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/splash.dart';
import 'package:final_quizlet_english/screens/createSet.dart';
import 'package:final_quizlet_english/screens/settingSet.dart';
import 'package:final_quizlet_english/screens/library.dart';

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
      home: LibraryPage(),
    );
  }
}
