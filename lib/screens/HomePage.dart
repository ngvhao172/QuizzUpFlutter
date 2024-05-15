import 'package:final_quizlet_english/screens/Report.dart';
import 'package:final_quizlet_english/screens/searchPage.dart';
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReportPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 12, top: 20, right: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  'View Reports ',
                                  style: TextStyle(
                                    //fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.grey.shade700,
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Image.asset(
                              'assets/images/studyboy.png',
                              height: 85,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LibraryPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 20, right: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  'My Library ',
                                  style: TextStyle(
                                    //fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Colors.grey.shade700,
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Image.asset(
                              'assets/images/studygirl.png',
                              height: 95,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Topics",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Text(
                            "See more",
                            style: TextStyle(
                              color: Colors.lightGreen,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.lightGreen,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      topicOption(
                          color: Colors.orange[50]!,
                          title: "Name Topic",
                          subtitle: "Pham Nhat Quynh",
                          image: 'assets/images/user.png',
                          term: '3'),
                      topicOption(
                          color: Colors.orange[50]!,
                          title: "Name Topic",
                          subtitle: "Pham Nhat Quynh",
                          image: 'assets/images/user.png',
                          term: '3'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Folders",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Text(
                            "See more",
                            style: TextStyle(
                              color: Colors.lightGreen,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.lightGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      folderOption(
                          color: Colors.orange[50]!,
                          title: "aaa",
                          subtitle: "aaaa",
                          image: 'assets/images/user.png',
                          topic: '3'),
                      folderOption(
                          color: Colors.orange[50]!,
                          title: "aaa",
                          subtitle: "aaaa",
                          image: 'assets/images/user.png',
                          topic: '3'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topicOption({
    required Color color,
    required String title,
    required String subtitle,
    required String image,
    required String term,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.only(left: 20),
      height: 120,
      width: 240,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.orange.shade200, width: 0.7),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.lightGreen[100],
              ),
              child: Text(
                '$term terms',
                style: const TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(image),
                  radius: 12,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            )
          ]),
    );
  }

  Widget folderOption({
    required Color color,
    required String title,
    required String subtitle,
    required String image,
    required String topic,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.only(left: 20),
      height: 120,
      width: 240,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.orange.shade200, width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Icon(Icons.folder_open_outlined),
              const SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 20,
            child: Row(
              children: [
                Text("$topic topics"),
                const SizedBox(
                  width: 5,
                ),
                const VerticalDivider(
                  thickness: 1,
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage(image),
                  radius: 12,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
