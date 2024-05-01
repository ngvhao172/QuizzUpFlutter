import 'package:final_quizlet_english/screens/Library.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/screens/TopicSetting.dart';
import 'package:flutter/widgets.dart';

class TCreatePage extends StatefulWidget {
  const TCreatePage({Key? key}) : super(key: key);

  @override
  State<TCreatePage> createState() => _TCreatePageState();
}

class _TCreatePageState extends State<TCreatePage> {
  final List<Map<String, String>> terms = [
    {'term': '', 'definition': ''},
    {'term': '', 'definition': ''},
    {'term': '', 'definition': ''},
    {'term': '', 'definition': ''},
  ];

  TextEditingController _titleEditingController = new TextEditingController();
  TextEditingController _descriptionEditingController =
      new TextEditingController();

  bool checkTerms() {
    int filledCount = 0;
    for (var term in terms) {
      if (term['term']!.isNotEmpty && term['definition']!.isNotEmpty) {
        filledCount++;
      }
    }
    if (filledCount >= 4) {
      return true;
    } else {
      return false;
    }
  }

  int selectedTermIndex = -1;
  int selectedDefinitionIndex = -1;

  String? termLanguage;
  String? defiLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Topic",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (checkTerms()) {
                // Hao code bla bla o day ne
                print(terms);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text(
                          'You must add at least four terms to save your set'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LibraryPage()),
                            );
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.orange)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Continue',
                              style: TextStyle(color: Colors.lightGreen)),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.lightGreen),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleEditingController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    hintText: 'Subject, chapter, unit',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionEditingController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    hintText: 'What is your topic about?',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(
                        Icons.document_scanner_outlined,
                        color: Colors.lightGreen,
                      ),
                      Text(
                        "Scan document",
                        style: TextStyle(color: Colors.lightGreen),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: terms.asMap().entries.map(
                    (entry) {
                      final int index = entry.key;
                      final Map<String, String> term = entry.value;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                        ),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value) {
                                term['term'] = value;
                              },
                              onTap: () {
                                setState(() {
                                  selectedTermIndex = index;
                                  selectedDefinitionIndex = -1;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Term",
                                hintText: 'Enter term',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: index == selectedTermIndex
                                        ? Colors.lightGreen
                                        : Colors.grey,
                                  ),
                                ),
                                suffixIcon: (selectedTermIndex == index)
                                    ? TextButton(
                                        onPressed: () {
                                          //Chon ngon ngu gi o day ne
                                          _setTermLanguageOptionsDialog(
                                              context);
                                        },
                                        child: Text(
                                          termLanguage ?? "Select language",
                                          style: const TextStyle(
                                            color: Colors.lightGreen,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextField(
                              onChanged: (value) {
                                term['definition'] = value;
                              },
                              onTap: () {
                                setState(() {
                                  selectedDefinitionIndex = index;
                                  selectedTermIndex = -1;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: "Definition",
                                  hintText: 'Enter definition',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: index == selectedDefinitionIndex
                                          ? Colors.lightGreen
                                          : Colors.grey,
                                    ),
                                  ),
                                  suffixIcon: (selectedDefinitionIndex == index)
                                      ? TextButton(
                                          onPressed: () {
                                            // Lam y cai tren chu hong biet
                                            _setDefiLanguageOptionsDialog(
                                                context);
                                          },
                                          child: Text(
                                            defiLanguage ?? "Select language",
                                            style: const TextStyle(
                                              color: Colors.lightGreen,
                                            ),
                                          ),
                                        )
                                      : null),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      terms.add({'term': '', 'definition': ''});
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.lightGreen,
                      ),
                      Text(
                        "Add Term and Definition",
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setDefiLanguageOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  setState(() {
                    defiLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Vietnamese'),
                onTap: () {
                  setState(() {
                    termLanguage = 'Vietnamese';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _setTermLanguageOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  setState(() {
                    termLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Vietnamese'),
                onTap: () {
                  setState(() {
                    defiLanguage = 'Vietnamese';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
