// Display the Vietnamese meaning and ask the user to type the English meaning (and vice versa).
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TypingPractice(),
    );
  }
}

class TypingPractice extends StatefulWidget {
  const TypingPractice({super.key});

  // final TopicInfoDTO topic;
  // final TypeSettings? settings;
  @override
  _TypingPracticeState createState() => _TypingPracticeState();
}
class TypingPractise {
  final String term;
  final String definition;

  TypingPractise({required this.term, required this.definition});
}

class _TypingPracticeState extends State<TypingPractice> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _vocabList = [
    {'english': 'hello', 'vietnamese': 'xin chào'},
    {'english': 'goodbye', 'vietnamese': 'tạm biệt'},
    {'english': 'please', 'vietnamese': 'làm ơn'},
    // Add more vocabulary here
  ]..shuffle();
  final FlutterTts flutterTts = FlutterTts();

  // late double _initial;
  bool _isEnglishDisplayed = true;
  int _currentIndex = 0;
  String _feedback = '';
  int _correctCount = 0;
  int _incorrectCount = 0;
  late FocusNode _focusNode;

//   List<Map<String, String>> _unlearnedVocab = [];
//   List<Map<String, String>> _learningVocab = [];
//   List<Map<String, String>> _learnedVocab = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _unlearnedVocab = List.from(_vocabList)..shuffle();
//   }

  List<String> languages = [];

  @override
  void initState() {
    // languages.add(widget.topic.topic.termLanguage);
    // languages.add(widget.topic.topic.definitionLanguage);


    super.initState();
    _focusNode = FocusNode();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _toggleLanguage() {
    setState(() {
      _isEnglishDisplayed = !_isEnglishDisplayed;
    });
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _checkAnswer() {
    String? correctAnswer = _isEnglishDisplayed
        ? _vocabList[_currentIndex]['vietnamese']
        : _vocabList[_currentIndex]['english'];
    bool isCorrect = _controller.text.toLowerCase() == correctAnswer;
    if (isCorrect) {
      _feedback = 'Correct!';
      _correctCount++;
    } else {
      _feedback = 'Incorrect. Try again.';
      _incorrectCount++;
    }
    _focusNode.requestFocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set the border radius
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // To make the dialog itself non-expanded
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: isCorrect
                      ? Colors.green
                      : Colors
                          .red, // Set the background color based on the answer
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        10.0), // Set the border radius for the top left corner
                    topRight: Radius.circular(
                        10.0), // Set the border radius for the top right corner
                  ),
                ),
                width: double
                    .infinity, // Make the container take up the full width
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        isCorrect
                            ? Icons.tag_faces_sharp
                            : Icons
                                .sentiment_dissatisfied_outlined, // Choose the icon based on the answer
                        color: Colors.yellow,
                        size: 35,
                      ),
                      SizedBox(
                          width:
                              10), // Add some spacing between the icon and the text
                      Text(
                        // isCorrect ? 'Correct!' : 'Incorrect',
                        '${_feedback}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment
                      .centerLeft, // Align text to the start of the line
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('\nCorrect answer:',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '$correctAnswer',
                        style: TextStyle(
                          color: Colors
                              .green, // Change the color of the correct answer
                          fontSize: 30,
                        ),
                      ),
                      Divider(
                        color: const Color.fromARGB(255, 205, 196, 196),
                        thickness: 1,
                      ),
                      Text(
                        'You said:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${_controller.text}',
                        style: TextStyle(
                          color: isCorrect ? Colors.blue : Colors.red,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 42, 117, 179), // This is the color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Add border radius
                      ),
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    ),
                    child: Text('Continue',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _controller.clear();
                      if (_currentIndex < _vocabList.length - 1) {
                        _currentIndex++;
                        if (_isEnglishDisplayed) {
                          _speak(_vocabList[_currentIndex]['english']!);
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Summary'),
                              content: Text('Correct answers: $_correctCount\n'
                                  'Incorrect answers: $_incorrectCount'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Retry'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _currentIndex =
                                          0; // Reset to the first word after the last word
                                      _correctCount = 0;
                                      _incorrectCount = 0;
                                      _controller.clear();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      _feedback = '';
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '1 / 3',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 20),
          ),
          centerTitle: true,
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
          // actions: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.all(8.0), // Add padding here
          //     child: IconButton(
          //       icon: Icon(Icons.swap_horiz),
          //       onPressed: _toggleLanguage,
          //     ),
          //   ),
          // ],
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 11 / 24,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const Text(
                                    "Settings",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Random terms",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Text(
                                                "Randomly display terms during the learning",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                          Switch(
                                            value: false,
                                            onChanged: (bool value) {
                                              setState(() {
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Play sound automatically",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Text(
                                                "Automatically play audio upon type opening.",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                          Switch(
                                            // value: audioPlay,
                                            value: false,
                                            onChanged: (bool value) {
                                              setState(() {
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Card orientation",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // ToggleSwitch(
                                      //   minWidth:
                                      //       MediaQuery.of(context).size.width,
                                      //   minHeight: 35,
                                      //   initialLabelIndex:
                                      //       (cardOrientation == languages[0])
                                      //           ? 0
                                      //           : 1,
                                      //   activeBgColor: const [
                                      //     Colors.lightGreen
                                      //   ],
                                      //   activeFgColor: Colors.white,
                                      //   inactiveBgColor: Colors.white,
                                      //   inactiveFgColor: Colors.grey[900],
                                      //   borderColor: const [Colors.green],
                                      //   borderWidth: 1.5,
                                      //   totalSwitches: 2,
                                      //   labels: languages,
                                      //   onToggle: (index) {
                                      //     //code sử lý gì á
                                      //     if (index == 0) {
                                      //       setState(() {
                                      //         cardOrientation = languages[0];
                                      //       });
                                      //     } else {
                                      //       setState(() {
                                      //         cardOrientation = languages[1];
                                      //       });
                                      //     }
                                      //     if (fSettings == null) {
                                      //       fSettings = FlashCardSettings(
                                      //           userId:
                                      //               widget.topic.topic.userId,
                                      //           randomTerms: randomOp,
                                      //           autoPlayAudio: audioPlay,
                                      //           cardOrientation:
                                      //               cardOrientation);
                                      //       FlashCardSettingsDao()
                                      //           .addFlashCardSettings(
                                      //               fSettings!);
                                      //     } else {
                                      //       fSettings!.cardOrientation =
                                      //           cardOrientation;
                                      //       FlashCardSettingsDao()
                                      //           .updateFlashCardSettings(
                                      //               fSettings!);
                                      //     }
                                      //   },
                                      // ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                // cardOrientation = languages[0];
                                                // audioPlay = false;
                                                // randomOp = false;
                                              });
                                              // fSettings!.cardOrientation =
                                              //     cardOrientation;
                                              // fSettings!.autoPlayAudio =
                                              //     audioPlay;
                                              // fSettings!.randomTerms = randomOp;
                                              // FlashCardSettingsDao()
                                              //     .updateFlashCardSettings(
                                              //         fSettings!);
                                            },
                                            child: const Text(
                                              "Refresh flashcard",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.lightGreen,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(Colors.lightGreen),
              minHeight: 5,
              value: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '${_isEnglishDisplayed ? 'English' : 'Vietnamese'}: ${_vocabList[_currentIndex][_isEnglishDisplayed ? 'english' : 'vietnamese']}',
                    style: TextStyle(fontSize: 24, color: Colors.green),
                  ),
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      labelText:
                          'Type the ${_isEnglishDisplayed ? 'Vietnamese' : 'English'} meaning',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_upward_rounded),
                        onPressed: _checkAnswer,
                      ),
                    ),
                    // onSubmitted: (value) => _checkAnswer(),
                  ),
                  SizedBox(height: 20),
                  // Text(
                  //   _feedback,
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     color: _feedback == 'Correct!' ? Colors.green : Colors.red,
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ));
  }
}
