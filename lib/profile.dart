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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/user.png'),
              radius: 50,
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
                primary: Colors.lightGreen,
                onPrimary: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: Size(200, 50),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
