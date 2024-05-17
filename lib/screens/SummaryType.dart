import 'package:flutter/material.dart';

class SummaryType extends StatefulWidget {
  const SummaryType(
      {super.key, required this.correctAnswer, required this.inCorrectAnswer});

  final int correctAnswer;
  final int inCorrectAnswer;

  @override
  State<SummaryType> createState() => _SummaryTypeState();
}

class _SummaryTypeState extends State<SummaryType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    flex: 2,
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Congratulations! You have reviewed all the terms',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 102, 165, 104),
                          ),
                        ))),
              ],
            ),
            SizedBox(height: 30),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Finished',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Text(
                    '${widget.correctAnswer}/${widget.correctAnswer+widget.inCorrectAnswer} - Terms',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        children: [
                          LinearProgressIndicator(
                            value: 1,
                            backgroundColor: Colors.grey,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double correctRatio = (widget.correctAnswer /
                                  (widget.correctAnswer +
                                      widget
                                          .inCorrectAnswer));
                              return Container(
                                width: constraints.maxWidth * correctRatio,
                                child: LinearProgressIndicator(
                                  value: 1,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 100),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Color.fromARGB(255, 238, 225, 108),
                  size: 60,
                ),
                SizedBox(width: 20),
                Icon(
                  Icons.notifications_active,
                  color: Color.fromARGB(255, 238, 225, 108),
                  size: 60,
                ),
                SizedBox(width: 20),
                Icon(
                  Icons.notifications_active,
                  color: Color.fromARGB(255, 238, 225, 108),
                  size: 60,
                ),
              ],
            ),
            SizedBox(height: 160),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      width: 450,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 216, 205, 80),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.restart_alt,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Restart Type',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
