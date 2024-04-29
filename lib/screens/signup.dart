import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/profile.dart';
import 'package:final_quizlet_english/services/auth.dart';
import 'package:final_quizlet_english/services/UserDao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:final_quizlet_english/screens/signin.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  // register(
  //     String displayName, String email, String password) async {
  //   Map<String, dynamic> userInfoMap = {
  //     "displayName": displayName,
  //     "email": email,
  //     "password": password,
  //   };
  //   try {
  //     UserDao().addUser(UserModel.fromJson(userInfoMap)).then((result) async {
  //       print(result);
  //       if (result["status"]) {
  //         await FirebaseAuth.instance
  //             .createUserWithEmailAndPassword(email: email, password: password);
  //         return {"status": true, "message": result["message"]};
  //       } else {
  //         return result;
  //       }
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     return {"status": false, "message": e.message};
  //   } catch (e) {
  //     return {"status": false, "message": e};
  //   }
  // }
  register(String displayName, String email, String password) async {
    Map<String, dynamic> userInfoMap = {
      "displayName": displayName,
      "email": email,
      "password": password,
    };
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();

      Map<String, dynamic> result =
          await UserDao().addUser(UserModel.fromJson(userInfoMap));

      if (result["status"]) {
        // User? user = FirebaseAuth.instance.currentUser;
        // user?.updateDisplayName(displayName);
        return result;
      } else {
        await userCredential.user?.delete();
        return result;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return {
        "status": false,
        "message": e.toString().split("]")[1].toString()
      };
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  var obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.lightGreen.shade700,
                  Colors.lightGreen.shade300,
                  Colors.lightGreen.shade100
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: const Text(
                            "Create an account",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.lightGreen.shade800,
                                        blurRadius: 20,
                                        offset: const Offset(0, 5))
                                  ]),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      Colors.grey.shade200))),
                                      child: TextFormField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                            hintText: "Full name",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Full name is required";
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      Colors.grey.shade200))),
                                      child: TextFormField(
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                            hintText: "Email",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              !value.contains("@")) {
                                            return "Email is invalid";
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: obscurePassword,
                                        decoration: InputDecoration(
                                            hintText: "Password",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                            suffixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: IconButton(
                                                    icon: (obscurePassword)
                                                        ? Icon(Icons
                                                            .remove_red_eye)
                                                        : Icon(Icons
                                                            .visibility_off),
                                                    onPressed: () {
                                                      setState(() {
                                                        obscurePassword =
                                                            !obscurePassword;
                                                      });
                                                    }))),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Password is required";
                                          }
                                        },
                                      ),
                                    ),
                                    // Container(
                                    //   padding: const EdgeInsets.all(10),
                                    //   decoration: BoxDecoration(
                                    //       border: Border(
                                    //           bottom: BorderSide(
                                    //               color: Colors.grey.shade200))),
                                    //   child: TextField(
                                    //     controller: _dateController,
                                    //     decoration: const InputDecoration(
                                    //         hintText: "Date of birth",
                                    //         hintStyle: TextStyle(color: Colors.grey),
                                    //         border: InputBorder.none),
                                    //     onTap: () {
                                    //       _selectDate();
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var result = await register(
                                    _nameController.text,
                                    _emailController.text,
                                    _passwordController.text);
                                if (result["status"]) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(result["message"])));
                                }
                              }
                            },
                            height: 50,
                            // margin: EdgeInsets.symmetric(horizontal: 50),
                            color: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            // decoration: BoxDecoration(
                            // ),
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInPage()),
                                  );
                                },
                                child: Text(
                                  "Sign In",
                                  style:
                                      TextStyle(color: Colors.lightGreen[700]),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: const Row(children: <Widget>[
                              Expanded(child: Divider()),
                              Text(
                                "  or sign up with  ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Expanded(child: Divider()),
                            ])),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FadeInUp(
                              duration: const Duration(milliseconds: 1800),
                              child: MaterialButton(
                                onPressed: () {},
                                height: 50,
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.facebook,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " Facebook",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: MaterialButton(
                                onPressed: () {
                                  AuthMethods().signInWithGoogle();
                                },
                                height: 50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                color: Colors.white,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          'assets/images/google_icon.png'),
                                      height: 30,
                                    ),
                                    Text(
                                      " Google",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _selectDate() async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //     initialDate: DateTime.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _dateController.text = picked.toString().split(" ")[0];
  //     });
  //   }
  // }
}
