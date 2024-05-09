import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TFlashcardPage extends StatefulWidget {
  const TFlashcardPage({super.key});

  @override
  State<TFlashcardPage> createState() => _TFlashcardPageState();
}

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});
}

class _TFlashcardPageState extends State<TFlashcardPage> {
  int _currentIndexNumber = 0;
  double _initial = 0.1;
  List<Flashcard> termCard = [
    Flashcard(question: "Q.Quỳnh1", answer: "Xinh1"),
    Flashcard(question: "Q.Quỳnh2", answer: "Xinh2"),
    Flashcard(question: "Q.Quỳnh3", answer: "Xinh3"),
    Flashcard(question: "Q.Quỳnh4", answer: "Xinh4"),
    Flashcard(question: "Q.Quỳnh5", answer: "Xinh5"),
    Flashcard(question: "Q.Quỳnh1", answer: "Xinh1"),
    Flashcard(question: "Q.Quỳnh2", answer: "Xinh2"),
    Flashcard(question: "Q.Quỳnh3", answer: "Xinh3"),
    Flashcard(question: "Q.Quỳnh4", answer: "Xinh4"),
    Flashcard(question: "Q.Quỳnh5", answer: "Xinh5"),
  ];

  String know = '0';
  String learn = '0';
  bool randomOp = false;
  bool audioPlay = false;
  bool isVietnameseSelected = true;

  @override
  Widget build(BuildContext context) {
    String value = (_initial * 10).toStringAsFixed(0);
    int sizeTopic = termCard.length;

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
                                      initialLabelIndex: 1,
                                      activeBgColor: const [Colors.lightGreen],
                                      activeFgColor: Colors.white,
                                      inactiveBgColor: Colors.white,
                                      inactiveFgColor: Colors.grey[900],
                                      borderColor: const [Colors.green],
                                      borderWidth: 1.5,
                                      totalSwitches: 2,
                                      labels: const ['English', 'Vietnamese'],
                                      onToggle: (index) {
                                        //code sử lý gì á
                                        print('switched to: $index');
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
                                          onPressed: () {},
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
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.volume_up),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  termCard[_currentIndexNumber].question,
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
                            const SizedBox(height: 45),
                            Expanded(
                              child: Center(
                                child: Text(
                                  termCard[_currentIndexNumber].answer,
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
              const Text("Tab to see Answer"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      showNextCard();
                      updateToNext();
                      updateLearn();
                    },
                    child: Container(
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
                  ),
                  InkWell(
                    onTap: () {
                      showNextCard();
                      updateToNext();
                      updateKnow();
                    },
                    child: Container(
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
                  ),
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
      _initial = _initial + 0.1;
      if (_initial > 1.0) {
        _initial = 0.1;
      }
    });
  }

  void updateToPrev() {
    setState(() {
      _initial = _initial - 0.1;
      if (_initial < 0.1) {
        _initial = 1.0;
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

  void showNextCard() {
    setState(() {
      _currentIndexNumber = (_currentIndexNumber + 1 < termCard.length)
          ? _currentIndexNumber + 1
          : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndexNumber = (_currentIndexNumber - 1 >= 0)
          ? _currentIndexNumber - 1
          : termCard.length - 1;
    });
  }
}
