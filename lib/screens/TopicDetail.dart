import 'package:final_quizlet_english/screens/Library.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/screens/TopicCreate.dart';
import 'package:final_quizlet_english/screens/TopicFlashcard.dart';

class TDetailPage extends StatefulWidget {
  const TDetailPage({super.key});

  @override
  State<TDetailPage> createState() => _TDetailPageState();
}

class _TDetailPageState extends State<TDetailPage> {
  bool showContent = false;
  int? selectedCardIndex;
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
                                builder: (context) => TCreatePage()),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      'assets/images/QLogo.png',
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
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
                                    child: const Text(
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
                    backgroundImage: AssetImage('assets/images/user.png'),
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
                        SizedBox(
                          width: 10,
                        ),
                        Text('Played by 0 users'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //Flashcard
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TFlashcardPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[50],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.my_library_books,
                        color: Colors.lightGreen,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Flashcard',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //Điền từ
              ElevatedButton(
                onPressed: () {
                  //
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[50],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.quiz,
                        color: Colors.lightGreen,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Quiz',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //Làm trắc nghiệm
              ElevatedButton(
                onPressed: () {
                  //
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[50],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit,
                        color: Colors.lightGreen,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Type',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Terms",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              buildCard(1, 'Quỳnh', 'Xinh gái'),
              buildCard(2, 'Hào', 'Xấu'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(int cardIndex, String title, String definition) {
    bool isOpen = selectedCardIndex == cardIndex;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        cardIndex.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Add your action here
                },
                icon: const Icon(Icons.volume_up),
              ),
              IconButton(
                onPressed: () {
                  // Add your action here
                },
                icon: const Icon(Icons.star_border_outlined),
              ),
            ],
          ),
          if (isOpen)
            Column(
              children: [
                const Divider(
                  color: Colors.grey,
                  indent: 10,
                  endIndent: 10,
                ),
                // Definition
                Text(
                  definition,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          const Divider(
            color: Colors.grey,
            indent: 10,
            endIndent: 10,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedCardIndex = isOpen ? null : cardIndex;
              });
            },
            child: Row(
              children: [
                Text(
                  isOpen ? 'Hide definition' : 'Show definition',
                  style: const TextStyle(color: Colors.lightGreen),
                ),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.lightGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
