import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/change_password.dart';
import 'package:final_quizlet_english/screens/create_password.dart';
import 'package:final_quizlet_english/screens/update_profile.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

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

  Future<void> _refreshData() async {
    setState(() {
      _userDataFuture = AuthService().getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data as UserModel;
                    for (var userInfo in user.userInfos!) {
                      if(userInfo.providerId == "password"){
                        isPasswordProvider = true;
                        break;
                      }              
                    }
                    return Container(
                      padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                      child: Center(
                        child: Column(
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
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.lightGreen),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {},
                                        iconSize: 15,
                                      ),
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              user.displayName.toString(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 65, 65, 65)),
                            ),
                            Text(
                              user.email.toString(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 65, 65, 65)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: const Size(200, 50),
                              ),
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateProfilePage())).then((value) async{
                                              await _refreshData();
                                            } );
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 20,
                            ),
                            getMenuItem(
                              title: "Achievements",
                              icon: Icons.star,
                              endIcon: true,
                              onPress: () {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            (isPasswordProvider==true) ? getMenuItem(
                              title: "Change password",
                              icon: Icons.settings,
                              endIcon: true,
                              onPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangePasswordPage()));
                              },
                            ) : getMenuItem(
                              title: "Create password",
                              icon: Icons.settings,
                              endIcon: true,
                              onPress: () async {
                                var result = await AuthService().reAuthGoogle();
                                if(result["status"]){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreatePasswordPage()));
                                }
                                else{
                                  showScaffoldMessage(context, result["message"]);
                                }
                              },
                            )
                            
                          ],
                        ),
                      ),
                    );
                  }
                }
                return Container(
                  margin: EdgeInsets.only(top: 20),
                  child: const Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.lightGreen,
                      ),
                    ],
                  )),
                );
              }),
        ));
  }
}

class getMenuItem extends StatelessWidget {
  const getMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.lightGreen.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios,
                    size: 15, color: Colors.grey),
                onPressed: onPress,
              ),
            )
          : null,
    );
  }
}
