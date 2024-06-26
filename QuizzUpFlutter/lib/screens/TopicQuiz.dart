import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/screens/TopicDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'ResultScreen.dart';

class TQuizPage extends StatefulWidget {
  const TQuizPage({super.key, required this.topic});

  final TopicInfoDTO topic;
  // final QuizSettings? settings;

  @override
  State<TQuizPage> createState() => _TQuizPageState();
}

class QuestionModel {
  String? question;
  Map<String, bool>? answers;
  QuestionModel(this.question, this.answers);
}

class _TQuizPageState extends State<TQuizPage> {
  List<QuestionModel> questions = [
  // QuestionModel(
  //   "Quynh",
  //   {
  //     "Xinh": false,
  //     "Qua xinh": false,
  //     "Xinh qua": true,
  //     "Xinh xinhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhaaaaaaaaaaaaaaaaaaa": false,
  //   },
  // ),
  // QuestionModel("When does a cat purr ?", {
  //   "When it cares for its kittens": false,
  //   "When it needs confort": false,
  //   "When it feels content": false,
  //   "All of the above": true,
  // }),
  // QuestionModel("What is the averge nulber of kittens in a litter ?", {
  //   "1 to 2": false,
  //   "3 to 5": true,
  //   "8 to 10": false,
  //   "12 to 14": false,
  // }),
  // QuestionModel("How many moons does Mars have ?", {
  //   "1": false,
  //   "2": false,
  //   "4": true,
  //   "8": false,
  // }),
  // QuestionModel("What is Mars's nickname ?", {
  //   "The red planet": true,
  //   "The dusty planet": false,
  //   "The hot planet": false,
  //   "The smelly planet": false,
  // }),
  // QuestionModel("About How long would it take to travel to Mars ?", {
  //   "Three days": false,
  //   "A month": false,
  //   "Eight months": true,
  //   "Two years": false,
  // }),
  // QuestionModel(
  //     "Mars is Named after the Roman god Mars. What is he the god of ?", {
  //   "Fire": false,
  //   "Love": false,
  //   "Agriculture": false,
  //   "War": true,
  // }),
  // QuestionModel("Mars Is the ___ planet from the sun ?", {
  //   "Second": false,
  //   "Third": false,
  //   "Fourth": true,
  //   "Sixth": false,
  // }),
  // QuestionModel(
  //     "Where did Orville and Wilbur Wright build their first flying airplane ?",
  //     {
  //       "Paris, France": false,
  //       "Boston, Massachusetts": false,
  //       "Kitty Hawk, North Carolina": true,
  //       "Tokyou, Japan": false,
  //     }),
  // QuestionModel(
  //     "The First astronuts to travel to space came from which country ?", {
  //   "United States": false,
  //   "Soviet Union (now Russia)": true,
  //   "China": false,
  //   "Rocketonia": false,
  // }),
];
  late double _initial;
  int question_pos = 0;
  int score = 0;
  bool btnPressed = false;
  PageController? _controller;
  String btnText = "Next Question";
  bool answered = false;
  @override
  void initState() {
    var answers = [];
    for (var element in widget.topic.vocabs!) {
      answers.add(element.definition);
    }
    for (var vocab in widget.topic.vocabs!) {
      var otherAnswer = List.from(answers);
      otherAnswer.removeWhere((element) => element == vocab.definition);
      otherAnswer.shuffle();
      var answer = {
        "${otherAnswer[0]}": false,
        "${otherAnswer[1]}": false,
        "${otherAnswer[2]}": false,
        vocab.definition: true,
      };
      answer = shuffleMap(answer) as Map<String, bool>;
      print(answer);
      questions.add(QuestionModel("${vocab.term} ?", answer));
    }
    _initial = 1 / questions.length;
    super.initState();
    _controller = PageController(initialPage: 0);
  }

    Map<String, bool> shuffleMap(Map<dynamic, dynamic> map) {
    var entries = map.entries.toList();
    entries.shuffle();
    return Map<String, bool>.fromEntries(entries.map((entry) => MapEntry(entry.key.toString(), entry.value as bool)));
  }


  @override
  Widget build(BuildContext context) {
    int noQuestions = widget.topic.vocabs!.length;
    String value = (_initial * noQuestions).toStringAsFixed(0);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.grey,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Do you want to end this test'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Continue',
                            style: TextStyle(color: Colors.orange)),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => TDetailPage()),
                          // );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('End Test',
                            style: TextStyle(color: Colors.lightGreen)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          title: Text(
            '$value / $noQuestions',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(Colors.lightGreen),
              minHeight: 5,
              value: _initial,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PageView.builder(
                  itemCount: questions.length,
                  controller: _controller!,
                  onPageChanged: (page) {
                    if (page == questions.length - 1) {
                      setState(() {
                        btnText = "See Results";
                      });
                    }
                    setState(() {
                      answered = false;
                    });
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${questions[index].question}",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 22.0,
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        // for (int i = 0;
                        //     i < questions[index].answers!.length;
                        //     i++)
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, i) {
                              return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  bottom: 20.0, left: 12.0, right: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: btnPressed
                                      ? questions[index]
                                              .answers!
                                              .values
                                              .toList()[i]
                                          ? Colors.lightGreen
                                          : Colors.orange
                                      : Colors.grey,
                                  width: 1.5,
                                ),
                              ),
                              child: TextButton(
                                // style: ButtonStyle(
                                //   shape: MaterialStatePropertyAll(

                                //   ),
                                // ),
                                onPressed: !answered
                                    ? () {
                                        if (questions[index]
                                            .answers!
                                            .values
                                            .toList()[i]) {
                                          score++;
                                          print("yes");
                                        } else {
                                          print("no");
                                        }
                                        setState(() {
                                          btnPressed = true;
                                          answered = true;
                                          // updateToNext();
                                        });
                                      }
                                    : null,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                          questions[index]
                                              .answers!
                                              .keys
                                              .toList()[i],
                                          style: TextStyle(
                                            color: btnPressed
                                                ? questions[index]
                                                        .answers!
                                                        .values
                                                        .toList()[i]
                                                    ? Colors.lightGreen
                                                    : Colors.orange
                                                : Colors.grey,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                    ),
                                    btnPressed
                                        ? questions[index]
                                                .answers!
                                                .values
                                                .toList()[i]
                                            ? Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.lightGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                ),
                                                child: const Icon(Icons.check,
                                                    color: Colors.white),
                                              )
                                            : Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                ),
                                                child: const Icon(Icons.close,
                                                    color: Colors.white),
                                              )
                                        : Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              border: Border.all(
                                                  color: Colors.grey, width: 2),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            );
                          }),
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
                          child: Text(
                            btnText,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (_controller!.page?.toInt() ==
                                questions.length - 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResultScreen(score)));
                            } else {
                              _controller!.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInExpo);

                              setState(() {
                                btnPressed = false;
                                updateToNext();
                              });
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

   void updateToNext() {
    setState(() {
      _initial = _initial + 1 / widget.topic.vocabs!.length;
      if (_initial > 1.0) {
        _initial = 1 / widget.topic.vocabs!.length;
      }
    });
  }
}
