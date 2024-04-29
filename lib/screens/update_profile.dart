import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/services/auth.dart';
import 'package:final_quizlet_english/services/userDao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              future: AuthMethods().getCurrentUser(),
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
                                    icon: Icon(
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
                              TextFormField(
                                controller: _emailEditingController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100)),
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
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      //
                                      UserModel userUpdate = UserModel(
                                        id: user.id,
                                        displayName: _fullnameEditingController.text,
                                        email: _emailEditingController.text,
                                        phoneNumber: _phoneNumberEditingController.text,
                                        photoURL: user.photoURL
                                      );

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
                                        AuthMethods()
                                            .updateEmail(userUpdate.email)
                                            .then((result) {
                                          if (result["status"]) {
                                            UserDao()
                                                .updateUser(userUpdate)
                                                .then((result) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          result["message"])));
                                            }).catchError((error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          error["message"])));
                                            });
                                          }
                                          else{
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(result["message"])));
                                          }
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(error["message"])));
                                        });
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
                  child: const CircularProgressIndicator(),
                );
              },
            ),
          ),
        ));
  }
}
