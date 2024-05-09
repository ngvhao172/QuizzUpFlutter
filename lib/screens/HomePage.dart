import 'package:final_quizlet_english/screens/Report.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/screens/Profile.dart';
import 'package:final_quizlet_english/screens/Library.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(right: 12.0, top: 12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/user.png"),
                radius: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Quynh',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 12.0),
            child: Image.asset(
              "assets/images/QLogo.png",
              fit: BoxFit.cover, // Ensure the image covers the container
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Search topic, creator,...",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      selectOption(
                          color: Colors.orange[50]!,
                          title: "aaa",
                          subtitle: "aaaa"),
                      selectOption(
                          color: Colors.orange[50]!,
                          title: "aaa",
                          subtitle: "aaaa"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectOption({
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.only(left: 20),
      height: 120,
      width: 240,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, color: Colors.grey[700]),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 19, color: Colors.grey[700]),
            ),
          ]),
    );
  }
}
