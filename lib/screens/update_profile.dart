import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/UserDao.dart';
import 'package:final_quizlet_english/widgets/notifications.dart';
import 'package:flutter/material.dart';

import 'signin.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _fullnameEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _phoneNumberEditingController = TextEditingController();

  bool isEmailTextEnabled = false;

  // bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentUserData();
  // }

  // Future<void> getCurrentUserData() async {
  //   try {
  //     UserApp? user = await AuthMethods().getCurrentUser();
  //     print(user!.photoURL);
  //     setState(() {
  //       currentUser = user;
  //       // isLoading = false;
  //     });
  //   } catch (e) {
  //     print("Error: $e");
  //     setState(() {
  //       // isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: FutureBuilder(
              future: AuthService().getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data as UserModel;
                    TextEditingController _fullnameEditingController =
                        TextEditingController(text: user.displayName);
                    TextEditingController _emailEditingController =
                        TextEditingController(text: user.email);
                    TextEditingController _phoneNumberEditingController =
                        TextEditingController(text: user.phoneNumber);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.png'),
                              radius: 50,
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.lightGreen),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                    iconSize: 15,
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _fullnameEditingController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  labelText: 'Full name',
                                  hintText: "Enter your name",
                                  prefixIcon: Icon(Icons.person_rounded),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  TextFormField(
                                    enabled: isEmailTextEnabled,
                                    controller: _emailEditingController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      labelText: 'Email',
                                      hintText: "Enter your email",
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          !value.contains('@')) {
                                        return 'This is not a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  Positioned(
                                    right: 8.0,
                                    child: IconButton(
                                      icon: isEmailTextEnabled
                                          ? Icon(Icons.lock_open_outlined)
                                          : Icon(Icons.lock_outline),
                                      onPressed: () async {
                                        if (!isEmailTextEnabled) {
                                          var result = await AuthService()
                                              .reAuthGoogle();
                                          if (result["status"]) {
                                            setState(() {
                                              isEmailTextEnabled = true;
                                            });
                                          }
                                          showScaffoldMessage(context, result["message"]);
                                        } else {
                                          setState(() {
                                            isEmailTextEnabled = false;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _phoneNumberEditingController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  labelText: 'Phone number',
                                  hintText: "Enter your phone number",
                                  prefixIcon: Icon(Icons.numbers),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length != 10) {
                                    return 'Phone number must contain 10 digits';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                    minimumSize: Size(200, 50),
                                  ),
                                  child: const Text(
                                    'Update',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      //
                                      UserModel userUpdate = UserModel(
                                          id: user.id,
                                          displayName:
                                              _fullnameEditingController.text,
                                          email: _emailEditingController.text,
                                          phoneNumber:
                                              _phoneNumberEditingController
                                                  .text,
                                          photoURL: user.photoURL);

                                      userUpdate.displayName =
                                          _fullnameEditingController.text;
                                      userUpdate.email =
                                          _emailEditingController.text;
                                      userUpdate.phoneNumber =
                                          _phoneNumberEditingController.text;
                                      if (userUpdate.email == user.email) {
                                        UserDao()
                                            .updateUser(userUpdate)
                                            .then((result) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(result["message"])));
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(error["message"])));
                                        });
                                      } else {
                                        // var result = await AuthService()
                                        //     .updateUser(userUpdate);
                                        //  ScaffoldMessenger.of(context)
                                        //       .showSnackBar(SnackBar(
                                        //           content:
                                        //               Text(result["message"])));
                                        // if(result["status"]){
                                        //   await AuthService().signOut();
                                        //   Navigator.push(context, MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           SignInPage()));
                                        // }
                                      }
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightGreen,
                  ),
                );
              },
            ),
          ),
        ));
  }
}
