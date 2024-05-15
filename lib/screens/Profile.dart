import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/PasswordChange.dart';
import 'package:final_quizlet_english/screens/PasswordCreate.dart';
import 'package:final_quizlet_english/screens/ProfileUpdate.dart';
import 'package:final_quizlet_english/screens/SignIn.dart';
import 'package:final_quizlet_english/services/AuthProvider.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/widgets/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserModel?> _userDataFuture;

  bool isPasswordProvider = false;

  @override
  void initState() {
    super.initState();
    _userDataFuture = AuthService().getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _userDataFuture = AuthService().getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = AuthenticateProvider.of(context)!;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Profile"),
      //   backgroundColor: Colors.orange[200],
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      // ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                UserModel user = snapshot.data as UserModel;
                print(user);
                for (var userInfo in user.userInfos!) {
                  if (userInfo.providerId == "password") {
                    isPasswordProvider = true;
                    break;
                  }
                }
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 300.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              colors: [
                                Colors.orange.shade800,
                                Colors.orange.shade600,
                                Colors.orange.shade300
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 55),
                                ListTile(
                                  title: Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'haizzzzz@gmail.com',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text(
                                    'Phone number',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '0123456789',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("************"),
                                      TextButton(
                                        child: Text(
                                          'Change Password',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange.shade700,
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      top: 70.0,
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/user.png"),
                        radius: 60,
                      ),
                    ),
                    Positioned(
                      top: 70.0,
                      right: MediaQuery.of(context).size.width / 2 - 80,
                      child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.white),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.lightGreen,
                          )),
                    ),
                    const Positioned(
                      top: 200.0,
                      child: Text(
                        "Phạm Nhật Quỳnh",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                        top: 5.0,
                        right: 0.0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            authProvider.auth.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()));
                          },
                        )),
                    Positioned(
                      top: 255.0,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "TOPICS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700),
                                ),
                                Text(
                                  "520",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.orange.shade700),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "FOLDERS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700),
                                ),
                                Text(
                                  "520",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.orange.shade700),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "ATTEMPT",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700),
                                ),
                                Text(
                                  "520",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.orange.shade700),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}
