import 'package:final_quizlet_english/firebase_options.dart';
import 'package:final_quizlet_english/screens/PasswordChange.dart';
import 'package:final_quizlet_english/screens/Profile.dart';
import 'package:final_quizlet_english/screens/SignIn.dart';
import 'package:final_quizlet_english/screens/signup.dart';
import 'package:final_quizlet_english/screens/ProfileUpdate.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/AuthProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/Splash.dart';
import 'package:final_quizlet_english/screens/TopicCreate.dart';
import 'package:final_quizlet_english/screens/TopicSetting.dart';
import 'package:final_quizlet_english/screens/Library.dart';
import 'package:final_quizlet_english/screens/TopicDetail.dart';
import 'package:final_quizlet_english/screens/TopicFlashcard.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: TDetailPage(),
      ),
    );
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
          return signedIn ? TCreatePage() : const SignInPage();
        }
        return Container(
          color: Colors.black,
        );
      },
    );
  }
}
