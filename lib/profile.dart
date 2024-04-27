import 'package:final_quizlet_english/change_password.dart';
import 'package:final_quizlet_english/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {},
          ),
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/user.png'),
                        radius: 50,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.lightGreen),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.white,), 
                          onPressed: () { 

                          },
                          iconSize: 15,
                        ),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Pham Nhat Quynh",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 65, 65, 65)),
                  ),
                  const Text(
                    "phamnhatquynh@gmail.com",
                    style: TextStyle(color: Color.fromARGB(255, 65, 65, 65)),
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
                      minimumSize: Size(200, 50),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfilePage()));
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
                  getMenuItem(
                    title: "Change password",
                    icon: Icons.settings,
                    endIcon: true,
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
                    },
                  )
                ],
              ),
            ),
          ),
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
