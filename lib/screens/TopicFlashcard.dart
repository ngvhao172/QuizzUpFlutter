import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/blocs/topic/TopicDetailBloc.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/FlashCardSettings.dart';
import 'package:final_quizlet_english/models/VocabStatus.dart';
import 'package:final_quizlet_english/screens/ResultFlashcard.dart';
import 'package:final_quizlet_english/screens/TopicQuiz.dart';
import 'package:final_quizlet_english/services/FlashCardSettingsDao.dart';
import 'package:final_quizlet_english/services/VocabStatusDao.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TFlashcardPage extends StatefulWidget {
  const TFlashcardPage({super.key, required this.topic, this.settings});

  final TopicInfoDTO topic;
  final FlashCardSettings? settings;

  @override
  State<TFlashcardPage> createState() => _TFlashcardPageState();
}

class Flashcard {
  final VocabularyStatus vocabStatus;
  final String question;
  final String answer;

  Flashcard(
      {required this.vocabStatus,
      required this.question,
      required this.answer});
}

class _TFlashcardPageState extends State<TFlashcardPage> {
  int _currentIndexNumber = 0;
  late double _initial;

  List<Flashcard> termCard = [
    // Flashcard(question: "Q.Quỳnh1", answer: "Xinh1"),
    // Flashcard(question: "Q.Quỳnh2", answer: "Xinh2"),
    // Flashcard(question: "Q.Quỳnh3", answer: "Xinh3"),
    // Flashcard(question: "Q.Quỳnh4", answer: "Xinh4"),
    // Flashcard(question: "Q.Quỳnh5", answer: "Xinh5"),
    // Flashcard(question: "Q.Quỳnh1", answer: "Xinh1"),
    // Flashcard(question: "Q.Quỳnh2", answer: "Xinh2"),
    // Flashcard(question: "Q.Quỳnh3", answer: "Xinh3"),
    // Flashcard(question: "Q.Quỳnh4", answer: "Xinh4"),
    // Flashcard(question: "Q.Quỳnh5", answer: "Xinh5"),
  ];

  GlobalKey<FlipCardState> flipKey = GlobalKey<FlipCardState>();

  String know = '0';
  String learn = '0';
  bool randomOp = false;
  bool audioPlay = false;
  bool autoFlip = false;
  late String cardOrientation;

  FlutterTts flutterTts = FlutterTts();
  FlashCardSettings? fSettings;

  List<String> languages = [];

  @override
  void initState() {
    // TODO: implement initState
    languages.add(widget.topic.topic.termLanguage);
    languages.add(widget.topic.topic.definitionLanguage);

    cardOrientation = widget.topic.topic.definitionLanguage;
    for (var vocab in widget.topic.vocabs!) {
      termCard.add(Flashcard(
          vocabStatus: vocab.vocabStatus,
          question: vocab.vocab.term,
          answer: vocab.vocab.definition));
    }
    if (widget.settings != null) {
      fSettings = widget.settings;
      print(fSettings);
      randomOp = fSettings!.randomTerms;
      audioPlay = fSettings!.autoPlayAudio;
      cardOrientation = fSettings!.cardOrientation;
      if (randomOp) {
        termCard.shuffle();
      }
    }

    _initial = 1 / termCard.length;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    flipKey.currentState?.dispose();
    super.dispose();
  }

  void textToSpeechEn(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(2.0);
    await flutterTts.speak(text);
  }

  void textToSpeechVi(String text) async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    int sizeTopic = widget.topic.vocabs!.length;
    String value = (_initial * sizeTopic).toStringAsFixed(0);
    print(autoFlip);
    if (audioPlay) {
      if (widget.topic.topic.termLanguage == "English") {
        textToSpeechEn(termCard[_currentIndexNumber].question);
      } else {
        textToSpeechVi(termCard[_currentIndexNumber].question);
      }
    }
    // if(autoFlip){
    //   showNextCard();
    //   updateToNext();
    //   updateLearn();
    // }
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '$value / $sizeTopic',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontSize: 20),
        ),
        centerTitle: true,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          value: randomOp,
                                          onChanged: (bool value) {
                                            setState(() {
                                              randomOp = value;
                                            });
                                            if (fSettings == null) {
                                              fSettings = FlashCardSettings(
                                                  userId:
                                                      widget.topic.topic.userId,
                                                  randomTerms: value,
                                                  autoPlayAudio: audioPlay,
                                                  cardOrientation:
                                                      cardOrientation);
                                              FlashCardSettingsDao()
                                                  .addFlashCardSettings(
                                                      fSettings!);
                                            } else {
                                              fSettings!.randomTerms = value;
                                              FlashCardSettingsDao()
                                                  .updateFlashCardSettings(
                                                      fSettings!);
                                            }
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
                                              "Play audio",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            Text(
                                              "Automatically play audio upon card opening.",
                                              style: TextStyle(
                                                  color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                        Switch(
                                          value: audioPlay,
                                          onChanged: (bool value) {
                                            setState(() {
                                              audioPlay = value;
                                            });
                                            if (fSettings == null) {
                                              fSettings = FlashCardSettings(
                                                  userId:
                                                      widget.topic.topic.userId,
                                                  randomTerms: value,
                                                  autoPlayAudio: audioPlay,
                                                  cardOrientation:
                                                      cardOrientation);
                                              FlashCardSettingsDao()
                                                  .addFlashCardSettings(
                                                      fSettings!);
                                            } else {
                                              fSettings!.autoPlayAudio = value;
                                              FlashCardSettingsDao()
                                                  .updateFlashCardSettings(
                                                      fSettings!);
                                            }
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
                                    ToggleSwitch(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      minHeight: 35,
                                      initialLabelIndex:
                                          (cardOrientation == languages[0])
                                              ? 0
                                              : 1,
                                      activeBgColor: const [Colors.lightGreen],
                                      activeFgColor: Colors.white,
                                      inactiveBgColor: Colors.white,
                                      inactiveFgColor: Colors.grey[900],
                                      borderColor: const [Colors.green],
                                      borderWidth: 1.5,
                                      totalSwitches: 2,
                                      labels: languages,
                                      onToggle: (index) {
                                        //code sử lý gì á
                                        if (index == 0) {
                                          setState(() {
                                            cardOrientation = languages[0];
                                          });
                                        } else {
                                          setState(() {
                                            cardOrientation = languages[1];
                                          });
                                        }
                                        if (fSettings == null) {
                                          fSettings = FlashCardSettings(
                                              userId: widget.topic.topic.userId,
                                              randomTerms: randomOp,
                                              autoPlayAudio: audioPlay,
                                              cardOrientation: cardOrientation);
                                          FlashCardSettingsDao()
                                              .addFlashCardSettings(fSettings!);
                                        } else {
                                          fSettings!.cardOrientation =
                                              cardOrientation;
                                          FlashCardSettingsDao()
                                              .updateFlashCardSettings(
                                                  fSettings!);
                                        }
                                      },
                                    ),
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
                                              cardOrientation = languages[0];
                                              audioPlay = false;
                                              randomOp = false;
                                            });
                                            fSettings!.cardOrientation =
                                                cardOrientation;
                                            fSettings!.autoPlayAudio =
                                                audioPlay;
                                            fSettings!.randomTerms = randomOp;
                                            FlashCardSettingsDao()
                                                .updateFlashCardSettings(
                                                    fSettings!);
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
        children: [
          LinearProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation(Colors.lightGreen),
            minHeight: 5,
            value: _initial,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red[100],
                    ),
                    //Privacy
                    child: Text(
                      learn,
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue[100],
                    ),
                    //Privacy
                    child: Text(
                      know,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 500,
                height: 500,
                child: FlipCard(
                  key: flipKey,
                  onFlip: () {
                    //Cập nhật trạng thái => learning (1)
                    if (termCard[_currentIndexNumber].vocabStatus.status != 1) {
                      context.read<TopicDetailBloc>().add(
                          UpdateVocabStatusStatus(
                              termCard[_currentIndexNumber].vocabStatus, 1));
                    }
                  },
                  direction: FlipDirection.HORIZONTAL,
                  front: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 7,
                      shadowColor: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            (cardOrientation == languages[0])
                                ? Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (widget.topic.topic.termLanguage ==
                                              "English") {
                                            textToSpeechEn(
                                                termCard[_currentIndexNumber]
                                                    .question);
                                          } else {
                                            textToSpeechVi(
                                                termCard[_currentIndexNumber]
                                                    .question);
                                          }
                                        },
                                        icon: const Icon(Icons.volume_up),
                                      ),
                                    ],
                                  )
                                : const SizedBox(height: 45),
                            Expanded(
                              child: Center(
                                child: Text(
                                  (cardOrientation == languages[0])
                                      ? termCard[_currentIndexNumber].question
                                      : termCard[_currentIndexNumber].answer,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                  back: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 7,
                      shadowColor: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            (cardOrientation != languages[0])
                                ? Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (widget.topic.topic.termLanguage ==
                                              "English") {
                                            textToSpeechEn(
                                                termCard[_currentIndexNumber]
                                                    .question);
                                          } else {
                                            textToSpeechVi(
                                                termCard[_currentIndexNumber]
                                                    .question);
                                          }
                                        },
                                        icon: const Icon(Icons.volume_up),
                                      ),
                                    ],
                                  )
                                : const SizedBox(height: 45),
                            Expanded(
                              child: Center(
                                child: Text(
                                  (cardOrientation == languages[0])
                                      ? termCard[_currentIndexNumber].answer
                                      : termCard[_currentIndexNumber].question,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Text("Tap to see Answer"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.thumb_down,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              showNextCard();
                              updateToNext();
                              updateLearn();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showPreviousCard();
                          updateToPrev();
                        },
                        child: const Icon(
                          Icons.arrow_circle_left_rounded,
                          size: 50,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          if (autoFlip) {
                            setState(() {
                              autoFlip = false;
                            });
                          } else {
                            setState(() {
                              autoFlip = true;
                            });
                            if (autoFlip) {
                              flipKey.currentState!.toggleCard();
                            }
                            await Future.delayed(Duration(seconds: 3), () {
                              flipKey.currentState!.toggleCard();
                              showNextCard();
                              updateToNext();
                              updateLearn();
                            });
                          }
                        },
                        child: Icon(
                          autoFlip ? Icons.pause_circle : Icons.play_circle,
                          size: 50,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.thumb_up,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              showNextCard();
                              updateToNext();
                              updateKnow();
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void updateToNext() {
    setState(() {
      _initial = _initial + 1 / widget.topic.vocabs!.length;
      if (_initial > 1.0) {
        _initial = 1 / widget.topic.vocabs!.length;
      }
    });
  }

  void updateToPrev() {
    setState(() {
      _initial = _initial - 1 / widget.topic.vocabs!.length;
      if (_initial < 0.1) {
        _initial = 1 / widget.topic.vocabs!.length;
      }
    });
  }

  //qua trang result thi + them 1 cai
  void updateKnow() {
    setState(() {
      int knowCount = int.parse(know);
      knowCount++;
      know = knowCount.toString();
    });
  }

  void updateLearn() {
    setState(() {
      int learnCount = int.parse(learn);
      learnCount++;
      learn = learnCount.toString();
    });
  }

  void showNextCard() async {
    print(_currentIndexNumber);
    print(termCard.length);
    if (_currentIndexNumber < termCard.length - 1) {
      setState(() {
        _currentIndexNumber += 1;
      });
      if (autoFlip) {
        await Future.delayed(const Duration(seconds: 2), () async {
          if(flipKey.currentState!=null){
            flipKey.currentState!.toggleCard();
          }
          await Future.delayed(const Duration(seconds: 1), () {
            showNextCard();
            updateToNext();
            updateLearn();
            if(flipKey.currentState!=null){
              flipKey.currentState!.toggleCard();
            }
          });
        });
      }
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => 
          ResultFlashcard(knew: int.parse(know), learning: int.parse(learn),
            ))).then((value) async {
        if (value == "true") {
          setState(() {
            know = "0";
            learn = "0";
            _currentIndexNumber = 0;
          });
          if (autoFlip) {
            await Future.delayed(const Duration(seconds: 1));
            await Future.delayed(const Duration(seconds: 2), () async {
              flipKey.currentState!.toggleCard();
              await Future.delayed(const Duration(seconds: 1), () {
                showNextCard();
                updateToNext();
                updateLearn();
                flipKey.currentState!.toggleCard();
              });
            });
          }
        } else if(value == "to-quiz"){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TQuizPage(topicDTO: widget.topic)));
        }
        else {
          Navigator.pop(context);
        }
      });
    }
  }

  void showPreviousCard() {
    setState(() {
      _currentIndexNumber = (_currentIndexNumber - 1 >= 0)
          ? _currentIndexNumber - 1
          : termCard.length - 1;
    });
    if (autoFlip) {
      flipKey.currentState!.toggleCard();
      Future.delayed(const Duration(seconds: 3), () {
        showNextCard();
        updateToNext();
        updateLearn();
      });
    }
  }
}
