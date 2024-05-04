import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

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
  @override
  Widget build(BuildContext context) {
    String value = (_initial * 10).toStringAsFixed(0);
    int sizeTopic = 10;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.grey,
        ),
        title: Text(
          '$value / $sizeTopic',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation(Colors.lightGreen),
                minHeight: 5,
                value: _initial,
              ),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    showPreviousCard();
                    updateToPrev();
                  },
                  icon: const Icon(Icons.chevron_left, size: 30),
                  label: const Text(""),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(
                        right: 20, left: 25, top: 15, bottom: 15),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showNextCard();
                    updateToNext();
                  },
                  icon: const Icon(Icons.chevron_right, size: 30),
                  label: const Text(""),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(
                        right: 20, left: 25, top: 15, bottom: 15),
                  ),
                )
              ],
            )
          ],
        ),
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
