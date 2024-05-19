import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/blocs/topic/TopicBloc.dart';
import 'package:final_quizlet_english/blocs/topic/TopicDetailBloc.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/models/VocabStatus.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:final_quizlet_english/services/VocabDao.dart';
import 'package:final_quizlet_english/services/VocabStatusDao.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/screens/TopicSetting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TUpdatePage extends StatefulWidget {
  const TUpdatePage({Key? key, required this.topicInfoDTO}) : super(key: key);

  final TopicInfoDTO topicInfoDTO;

  @override
  State<TUpdatePage> createState() => _TUpdatePageState();
}

class _TUpdatePageState extends State<TUpdatePage> {
  final List<Map<String, String>> terms = [];
  final List<Map<String, String>> OriTerms = [];

  late TextEditingController _titleEditingController;
  late TextEditingController _descriptionEditingController;

  late Future<Map<String, dynamic>> topicData;

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

  late String termLanguage;
  late String defiLanguage;

  late bool visible;

  late Future<UserModel?> _userFuture;
  late UserModel user;
  @override
  void initState() {
    super.initState();
    _userFuture = AuthService().getCurrentUser();
    _titleEditingController =
        TextEditingController(text: widget.topicInfoDTO.topic.name);
    _descriptionEditingController =
        TextEditingController(text: widget.topicInfoDTO.topic.description);
    terms.clear();
    for (var vocabDTO in widget.topicInfoDTO.vocabs!) {
      var vocab = vocabDTO.vocab;
      OriTerms.add({
        'term': vocab.term,
        'definition': vocab.definition,
        'id': vocab.id!
      });
      terms.add({'term': vocab.term, 'definition': vocab.definition});
    }
    termLanguage = widget.topicInfoDTO.topic.termLanguage;
    defiLanguage = widget.topicInfoDTO.topic.definitionLanguage;
    visible = widget.topicInfoDTO.topic.private!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Topic",
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
              MaterialPageRoute(
                  builder: (context) => SettingPage(
                      selectedTermLanguage: termLanguage,
                      selectedDefiLanguage: defiLanguage,
                      selectedVisible: visible)),
            ).then((value) => {
                  termLanguage = value["selectedTermLanguage"],
                  defiLanguage = value["selectedDefiLanguage"],
                  visible = value["selectedPrivate"],
                });
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (checkTerms()) {
                var title = _titleEditingController.text;
                if (title.isEmpty) {
                  showDialogMessage(context, 'Title is required');
                } else if (defiLanguage.isEmpty) {
                  showDialogMessage(
                      context, 'Please select definition language');
                } else if (termLanguage.isEmpty) {
                  showDialogMessage(context, 'Please select term language');
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Center(child: CircularProgressIndicator());
                      });

                  /// Update topic
                  TopicModel updateTopic = TopicModel(
                      id: widget.topicInfoDTO.topic.id,
                      name: _titleEditingController.text,
                      userId: user.id!,
                      description: _descriptionEditingController.text,
                      private: visible,
                      termLanguage: termLanguage,
                      definitionLanguage: defiLanguage,
                      updatedAt: DateTime.now(),
                      lastAccessed: DateTime.now());
                  UpdateTopic updateTopicEvent = UpdateTopic(updateTopic, user.id!);
                  try {
                    bool allVocabulariesAddedSuccessfully = true;

                    /// update từng vựng
                    for (var i = 0; i < terms.length; i++) {
                      print(i);
                      String term = terms[i]["term"].toString();
                      String definition = terms[i]["definition"].toString();
                      if (i < OriTerms.length) {
                        //Từ trống => xóa từ
                        if (term.isEmpty && definition.isEmpty) {
                          var res = await VocabularyDao()
                              .deleteVocabulary(OriTerms[i]["id"].toString());
                          if (!res["status"]) {
                            allVocabulariesAddedSuccessfully = false;
                          }
                        }
                      }
                      if (term.length >= OriTerms.length) {
                        if (i < OriTerms.length) {
                          if (term != OriTerms[i]["term"].toString() &&
                                  term.isNotEmpty ||
                              definition !=
                                      OriTerms[i]["definition"].toString() &&
                                  definition.isNotEmpty) {
                            //Cập nhật các từ có sự thay đổi
                            VocabularyModel newVocab = VocabularyModel(
                                topicId: widget.topicInfoDTO.topic.id!,
                                term: term,
                                definition: definition,
                                id: OriTerms[i]["id"].toString(),
                                updatedAt: DateTime.now());
                            var res = await VocabularyDao()
                                .updateVocabulary(newVocab);
                            if (!res["status"]) {
                              allVocabulariesAddedSuccessfully = false;
                              print(res["message"]);
                              print(
                                  'Failed to add vocabulary $term to the topic');
                            }
                          }
                        }
                        //Thêm từ mới
                        else {
                          String term = terms[i]["term"].toString();
                          String definition = terms[i]["definition"].toString();
                          VocabularyModel newVocab = VocabularyModel(
                              topicId: widget.topicInfoDTO.topic.id!,
                              term: term,
                              definition: definition);
                          var res =
                              await VocabularyDao().addVocabulary(newVocab);
                          print(res["status"]);
                          if(res["status"]){
                              String vocabId = res["data"]; //vocabId
                              //Add vocab status
                              VocabularyStatus status = VocabularyStatus(vocabularyId: vocabId, topicId: widget.topicInfoDTO.topic.id!, userId: user.id!);
                              var result = await VocabularyStatusDao().addVocabularyStatus(status);
                              print(result);
                          }
                        }
                      }
                    }
                    if (allVocabulariesAddedSuccessfully) {
                      //update Topic
                      context.read<TopicBloc>().add(updateTopicEvent);

                      context
                          .read<TopicDetailBloc>()
                          .add(LoadTopic(updateTopic.id!, user.id!));
                      print('All vocabularies added successfully to the topic');
                      showScaffoldMessage(context,
                          "Update topic successfully");
                      //pop showdialog
                      Navigator.pop(context);
                      //pop screen
                      Navigator.pop(context);
                    } else {
                      print('Some vocabularies failed to update to the topic');
                      showScaffoldMessage(context,
                          "Some vocabularies failed to update to the topic");
                    }
                  } catch (e) {
                    print('Failed to add the topic $e');
                    showScaffoldMessage(context, "Failed to add the topic $e");
                  }
                }
              } else {
                showDialogMessage(context,
                    'You must add at least four terms to save your set');
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
          child: FutureBuilder(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    user = snapshot.data as UserModel;
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _titleEditingController,
                              decoration: const InputDecoration(
                                labelText: "Title",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                hintText: 'Subject, chapter, unit',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintStyle: TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightGreen),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _descriptionEditingController,
                              decoration: const InputDecoration(
                                labelText: "Description",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                hintText: 'What is your topic about?',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintStyle: TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightGreen),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // TextButton(
                            //   onPressed: () {},
                            //   child: const Row(
                            //     children: [
                            //       Icon(
                            //         Icons.document_scanner_outlined,
                            //         color: Colors.lightGreen,
                            //       ),
                            //       Text(
                            //         "Scan document",
                            //         style: TextStyle(color: Colors.lightGreen),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 10),
                            Column(
                              children: terms.asMap().entries.map(
                                (entry) {
                                  final int index = entry.key;
                                  final Map<String, String> term = entry.value;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                    ),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          initialValue: term['term'],
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
                                                color:
                                                    index == selectedTermIndex
                                                        ? Colors.lightGreen
                                                        : Colors.grey,
                                              ),
                                            ),
                                            suffixIcon: (selectedTermIndex ==
                                                    index)
                                                ? TextButton(
                                                    onPressed: () {
                                                      //Chon ngon ngu gi o day ne
                                                      _setTermLanguageOptionsDialog(
                                                          context);
                                                    },
                                                    child: Text(
                                                      termLanguage.isEmpty
                                                          ? "Select language"
                                                          : termLanguage,
                                                      style: const TextStyle(
                                                        color:
                                                            Colors.lightGreen,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        TextFormField(
                                          initialValue: term['definition'],
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
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: index ==
                                                          selectedDefinitionIndex
                                                      ? Colors.lightGreen
                                                      : Colors.grey,
                                                ),
                                              ),
                                              suffixIcon:
                                                  (selectedDefinitionIndex ==
                                                          index)
                                                      ? TextButton(
                                                          onPressed: () {
                                                            // Lam y cai tren chu hong biet
                                                            _setDefiLanguageOptionsDialog(
                                                                context);
                                                          },
                                                          child: Text(
                                                            defiLanguage.isEmpty
                                                                ? "Select language"
                                                                : defiLanguage,
                                                            style:
                                                                const TextStyle(
                                                              color: Colors
                                                                  .lightGreen,
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
                    );
                  }
                }
                return Container(
                  margin: const EdgeInsets.only(top: 20),
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
              })),
    );
  }

  Future<dynamic> showDialogMessage(BuildContext context, String message) {
    return showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, animation1, animation2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(animation1),
              child: FadeTransition(
                  opacity:
                      Tween<double>(begin: 0.5, end: 1).animate(animation1),
                  child: AlertDialog(
                    content: Text(message),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
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
                  )));
        });
  }

  _setDefiLanguageOptionsDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, animation1, animation2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(animation1),
              child: FadeTransition(
                  opacity:
                      Tween<double>(begin: 0.5, end: 1).animate(animation1),
                  child: AlertDialog(
                    title: const Text('Select Language',
                        textAlign: TextAlign.center),
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
                              defiLanguage = 'Vietnamese';
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  )));
        });
  }

  _setTermLanguageOptionsDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, animation1, animation2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(animation1),
              child: FadeTransition(
                  opacity:
                      Tween<double>(begin: 0.5, end: 1).animate(animation1),
                  child: AlertDialog(
                    title: const Text('Select Language',
                        textAlign: TextAlign.center),
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
                  )));
        });
  }
}
