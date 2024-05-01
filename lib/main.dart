import 'package:final_quizlet_english/firebase_options.dart';
import 'package:final_quizlet_english/screens/change_password.dart';
import 'package:final_quizlet_english/screens/profile.dart';
import 'package:final_quizlet_english/screens/signin.dart';
import 'package:final_quizlet_english/screens/signup.dart';
import 'package:final_quizlet_english/screens/update_profile.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/AuthProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return Provider(
      auth: AuthService(), 
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ));
  }
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context)!.auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          print("Status: " + signedIn.toString());
          // auth.signOut();
          return signedIn ? CreateSet() : const SignInPage();
        }
        return Container(
          color: Colors.black,
        );
      },
    );
  }
}
