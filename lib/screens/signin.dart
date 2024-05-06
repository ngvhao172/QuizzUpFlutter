import 'package:final_quizlet_english/screens/Home.dart';
import 'package:final_quizlet_english/screens/Library.dart';
import 'package:final_quizlet_english/screens/Profile.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:final_quizlet_english/screens/signup.dart';
import 'package:flutter/widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const String routeName = '/login';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _forgotEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  var _formKeyForgot = GlobalKey<FormState>();

  bool isLoading = false;

  bool isLoadingResend = false;

  var obscurePassword = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _forgotEmailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            "Log In",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: const Text(
                            "Welcome Back",
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
                          height: 60,
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
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        Colors.grey.shade200))),
                                        child: TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
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
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Password is required";
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ))),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  openDialogFP();
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                var result = await AuthService().login(
                                    _emailController.text,
                                    _passwordController.text);
                                setState(() {
                                  isLoading = false;
                                });
                                if (result["status"] == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                }
                                if (result["status"] == "not-verified") {
                                  getNotVerifiedDialog();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(result["message"])));
                                }
                              }
                            },
                            height: 50,
                            color: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.lightGreen[700],
                                      strokeWidth: 2.0,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Sign in",
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
                                'Don\'t have an account?',
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage()),
                                  ).then((value) => {getNotVerifiedDialog()});
                                },
                                child: Text(
                                  "Sign Up",
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
                                "  or sign in with  ",
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
                                    AuthService()
                                        .signInWithGoogle()
                                        .then((result) {
                                      if (result["status"]) {
                                        showScaffoldMessage(
                                            context, result["message"]);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                        );
                                      } else {
                                        showScaffoldMessage(
                                            context, result["message"]);
                                      }
                                    }).catchError((error) {
                                      showScaffoldMessage(
                                          context, error.toString());
                                    });
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
                                )),
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

  Future openDialogFP() => showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, widget) {
        return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1).animate(animation1),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1).animate(animation1),
              child: AlertDialog(
                title: const Text(
                  'Forgot your password?',
                  textAlign: TextAlign.center,
                ),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text(
                      'Đừng lo lắng, chúng tôi sẽ gửi đến email của bạn đường link để có thể đổi mật khẩu mới.'),
                  Form(
                      key: _formKeyForgot,
                      child: TextFormField(
                        controller: _forgotEmailController,
                        decoration: const InputDecoration(
                            hintText: 'youremail@gmail.com'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email không được để trống.";
                          }
                          if (!value.contains("@")) {
                            return "Email không hợp lệ.";
                          }
                        },
                      ))
                ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.lightGreen)),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKeyForgot.currentState!.validate()) {
                        var result = await AuthService()
                            .forgotPassword(_forgotEmailController.text);
                        showScaffoldMessage(context, result["message"]);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('OK',
                        style: TextStyle(color: Colors.lightGreen)),
                  ),
                ],
              ),
            ));
      });

  getNotVerifiedDialog() {
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
                opacity: Tween<double>(begin: 0.5, end: 1).animate(animation1),
                child: AlertDialog(
                  title: const Text(
                    "Tài khoản chưa xác minh.",
                    textAlign: TextAlign.center,
                  ),
                  content:
                      const Column(mainAxisSize: MainAxisSize.min, children: [
                    Text("Vui lòng xác minh tài khoản trước khi đăng nhập."),
                  ]),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        getResendEmailVerifiedDialog()
                            .then((_) => {Navigator.pop(context)});
                      },
                      child: const Text('Gửi lại email xác minh',
                          style: TextStyle(color: Colors.lightGreen)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK',
                          style: TextStyle(color: Colors.lightGreen)),
                    ),
                  ],
                ),
              ));
        });
  }

  getResendEmailVerifiedDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Gửi lại email xác minh",
            textAlign: TextAlign.center,
          ),
          content: const Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Đừng lo lắng, chúng tôi sẽ gửi lại email xác minh cho bạn."),
          ]),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Hủy', style: TextStyle(color: Colors.lightGreen)),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoadingResend = true;
                });
                var result = await AuthService().resendEmailVerification();
                setState(() {
                  isLoadingResend = false;
                });
                showScaffoldMessage(context, result["message"]);
                Navigator.pop(context);
              },
              child: isLoadingResend
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.lightGreen[700],
                      strokeWidth: 2.0,
                      color: Colors.white,
                    )
                  : const Text('Gửi lại email xác minh',
                      style: TextStyle(color: Colors.lightGreen)),
            ),
          ],
        ),
      );
}
