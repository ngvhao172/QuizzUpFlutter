import 'package:final_quizlet_english/screens/Library.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/screens/TopicCreate.dart';

class TDetailPage extends StatelessWidget {
  const TDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.grey,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit Topic'),
                        onTap: () {
                          //edit topic
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateSet()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete Topic'),
                        onTap: () {
                          //delete r về lại trang library
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LibraryPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.folder_open),
                        title: const Text('Add to Colection'),
                        onTap: () {},
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/google_icon.png',
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('3 terms'),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red[100],
                                    ),
                                    //Privacy
                                    child: Text(
                                      'Private',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/user.png'), //để nào design logo theo filter
                    radius: 10,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Phạm Nhật Quỳnh",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.people),
                        Text('Played by 0 users'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
