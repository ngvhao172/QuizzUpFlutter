import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:flutter/material.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  var obscureOldPassword = true;
  var obscureNewPassword = true;
  var obscureConfirmPassword = true;
  bool isLoading = false;
  TextEditingController _oldPasswordEditingController = TextEditingController();
  TextEditingController _newPasswordEditingController = TextEditingController();
  TextEditingController _confirmNewPasswordEditingController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Password"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
              child:  Container(
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                child: FutureBuilder(
            future: AuthService().getCurrentUser(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  UserModel user = snapshot.data as UserModel;
                  return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: (user.photoURL != null &&
                                              user.photoURL != "null")
                                          ? NetworkImage(user.photoURL!)
                                          : const AssetImage(
                                                  "assets/images/user.png")
                                              as ImageProvider<Object>?,
                          radius: 50,
                        ),
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
                            obscureText: obscureNewPassword,
                            controller: _newPasswordEditingController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                labelText: 'New password',
                                hintText: "Enter your new password",
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    icon: obscureNewPassword
                                        ? Icon(Icons.remove_red_eye)
                                        : Icon(Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        obscureNewPassword = !obscureNewPassword;
                                      });
                                    },
                                  ),
                                )),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'New password is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: obscureConfirmPassword,
                            controller: _confirmNewPasswordEditingController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                labelText: 'Confirm new password',
                                hintText: "Enter your new password",
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: IconButton(
                                        icon: (obscureConfirmPassword)
                                            ? Icon(Icons.remove_red_eye)
                                            : Icon(Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            obscureConfirmPassword =
                                                !obscureConfirmPassword;
                                          });
                                        }))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm new password is required';
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
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: Size(200, 50),
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.lightGreen[700],
                                      strokeWidth: 2.0,
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Change',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  //
                                  if (_newPasswordEditingController.text ==
                                      _confirmNewPasswordEditingController.text) {
                                    setState(() {
                                      isLoading == true;
                                    });
                                    var result = await AuthService()
                                        .createNewPassword(
                                            _newPasswordEditingController.text);
                                    setState(() {
                                      isLoading == false;
                                    });
                                  } else {
                                    showScaffoldMessage(
                                        context, "Mật khẩu không trùng khớp.");
                                  }
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
            }
            )
          ),
        ));
  }
}
