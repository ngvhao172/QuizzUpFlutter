import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TypingPractice extends StatefulWidget {
  @override
  _TypingPracticeState createState() => _TypingPracticeState();
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

  @override
  void initState() {
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
    if (_controller.text.toLowerCase() == correctAnswer) {
      _feedback = 'Correct!';
      _correctCount++;
    } else {
      _feedback = 'Incorrect. Try again.';
      _incorrectCount++;
    }
    _focusNode.requestFocus();

    /* 
    String? correctAnswer = _isEnglishDisplayed
        ? _vocabList[_currentIndex]['vietnamese']
        : _vocabList[_currentIndex]['english'];
    if (_controller.text.toLowerCase() == correctAnswer) {
      _feedback = 'Correct!';
      _correctCount++;
      _learnedVocab.add(_vocabList[_currentIndex]);
      _learningVocab.remove(_vocabList[_currentIndex]);
    } else {
      _feedback = 'Incorrect. Try again.';
      _incorrectCount++;
      if (!_learnedVocab.contains(_vocabList[_currentIndex])) {
        _learningVocab.add(_vocabList[_currentIndex]);
      }
      _unlearnedVocab.remove(_vocabList[_currentIndex]);
    }
    */
    setState(() {});

    Future.delayed(Duration(seconds: 2), () {
      _controller.clear();
      if (_currentIndex < _vocabList.length - 1) {
        _currentIndex++;
        if (_isEnglishDisplayed) {
          _speak(_vocabList[_currentIndex]['english']!);
        }
      } else {
        // Show a summary when the user has answered all the words
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
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      _feedback = '';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Typing Practice'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: _toggleLanguage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              ),
              onSubmitted: (value) => _checkAnswer(),
            ),
            SizedBox(height: 20),
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 24,
                color: _feedback == 'Correct!'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
