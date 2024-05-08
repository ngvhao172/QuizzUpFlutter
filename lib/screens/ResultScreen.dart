import 'package:flutter/material.dart';

// run
void main() {
  runApp(const ResultScreen());
}

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.grey,
            ),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'You are doing great!',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(Icons.star, color: Colors.green, size: 60),
                  Icon(Icons.star, color: Colors.green, size: 60),
                  Icon(Icons.star, color: Colors.green, size: 60),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    const Text(
                      'Your Score: ',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 250,
                          width: 250,
                          child: CircularProgressIndicator(
                            strokeWidth: 10,
                            // value: score / 9,
                            value: 9,
                            color: Colors.green,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              // score.toString(),
                              '9',
                              style: TextStyle(fontSize: 80),
                            ),
                            SizedBox(height: 10),
                            Text(
                              // '${(score / questions.length * 100).round()}%',
                              '100%',
                              style: TextStyle(fontSize: 25),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: () {
                        // Implement your function to go back to last question
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 126, 186, 235),
                      ), // Add your preferred icon
                      label: const Text(
                        'Back to last question',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 126, 186, 235),
                        ),
                      ),
                    )
                  ]),
                  // Column(
                  //   children: [
                  //     Text(
                  //       'Hoàn thành',
                  //       style: TextStyle(
                  //         fontSize: 34,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     Text(
                  //       'Còn lại',
                  //       style: TextStyle(
                  //         fontSize: 34,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              InkWell(
                onTap: () {
                  // Implement your function here
                },
                child: const Text(
                  'Restart Flashcards',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 9, 98, 171),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
