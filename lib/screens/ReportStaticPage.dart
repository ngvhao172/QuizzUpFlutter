import 'package:final_quizlet_english/screens/TopicDetail.dart';
import 'package:flutter/material.dart';

class TopicStatisticsPage extends StatefulWidget {
  const TopicStatisticsPage({super.key});

  @override
  State<TopicStatisticsPage> createState() => _TopicStatisticsPageState();
}

class _TopicStatisticsPageState extends State<TopicStatisticsPage> {
  int numberOfCorrectAnswers = 15;
  int numberOfIncorrectAnswers = 5;
  int numberOfUnattemptedAnswers = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Back to Reports',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween, // add this line
                          children: <Widget>[
                            const Text(
                              'Topic Name',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.green[100],
                              ),
                              //Privacy
                              child: const Text(
                                "Public",
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: Colors.grey.shade300),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 5),
                                Text(
                                    'Date and Time'), //Hao ghi ngay tao hoac bo qua cung duoc
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                //Privacy
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => TDetailPage(
                                //           topicId: topicId, userId: userId)),
                                // );
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    ' View quiz',
                                    style: TextStyle(color: Colors.lightGreen),
                                  ),
                                  Icon(
                                    Icons.keyboard_double_arrow_right,
                                    color: Colors.lightGreen,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 2
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: 50,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.track_changes_outlined,
                              size: 35,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(width: 10),
                            Column(
                              // add this widget
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('50%',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight
                                            .w500)), // replace with your text
                                Text('Accuracy'), // replace with your text
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        width: 50,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.play_circle_outline_outlined,
                              size: 35,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(width: 10),
                            Column(
                              // add this widget
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('3',
                                    style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold)), // replace with your text
                                Text('Attempts'), // replace with your text
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 3
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(width: 20),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.green, // set the color to green
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text('Correct', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(width: 20),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.red, // set the color to red
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text('Incorrect', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(width: 20),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey, // set the color to red
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text('Unattempted',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              // 4
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  Colors.blue, // set the color to blue
                            ),
                            const SizedBox(width: 10),
                            Column(
                              // add this widget
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // align text to the left
                              children: <Widget>[
                                const Text('Name',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  '1 Attempts',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (int i = 0; i < numberOfCorrectAnswers; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 2),
                              for (int i = 0; i < numberOfIncorrectAnswers; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 2),
                              for (int i = 0;
                                  i < numberOfUnattemptedAnswers;
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 35,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check,
                                          color: Colors.green, size: 12),
                                      const SizedBox(width: 2),
                                      Text(numberOfCorrectAnswers.toString(),
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 35,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.close,
                                          color: Colors.red, size: 12),
                                      const SizedBox(width: 2),
                                      Text(numberOfIncorrectAnswers.toString(),
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 35,
                              height: 25,
                              decoration: BoxDecoration(
                                color:
                                    Colors.grey[300], // set the color to green
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error_outline_outlined,
                                          color: Colors.grey, size: 12),
                                      const SizedBox(width: 2),
                                      Text(
                                          numberOfUnattemptedAnswers.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 5),
                        const Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('20%',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Accuracy',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            SizedBox(width: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('5/10',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Points', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  Colors.blue, // set the color to blue
                            ),
                            const SizedBox(width: 10),
                            Column(
                              // add this widget
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // align text to the left
                              children: <Widget>[
                                const Text('Name',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  '1 Attempts',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (int i = 0; i < numberOfCorrectAnswers; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 2),
                              for (int i = 0; i < numberOfIncorrectAnswers; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 2),
                              for (int i = 0;
                                  i < numberOfUnattemptedAnswers;
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 35,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check,
                                          color: Colors.green, size: 12),
                                      const SizedBox(width: 2),
                                      Text(numberOfCorrectAnswers.toString(),
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 35,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.close,
                                          color: Colors.red, size: 12),
                                      const SizedBox(width: 2),
                                      Text(numberOfIncorrectAnswers.toString(),
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 35,
                              height: 25,
                              decoration: BoxDecoration(
                                color:
                                    Colors.grey[300], // set the color to green
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error_outline_outlined,
                                          color: Colors.grey, size: 12),
                                      const SizedBox(width: 2),
                                      Text(
                                          numberOfUnattemptedAnswers.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 5),
                        const Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('20%',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Accuracy',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            SizedBox(width: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('5/10',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Points', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  Colors.blue, // set the color to blue
                            ),
                            const SizedBox(width: 10),
                            Column(
                              // add this widget
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // align text to the left
                              children: <Widget>[
                                const Text('Name',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  '1 Attempts',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (int i = 0; i < numberOfCorrectAnswers; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 2),
                              for (int i = 0; i < numberOfIncorrectAnswers; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 2),
                              for (int i = 0;
                                  i < numberOfUnattemptedAnswers;
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 35,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check,
                                          color: Colors.green, size: 12),
                                      const SizedBox(width: 2),
                                      Text(numberOfCorrectAnswers.toString(),
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 35,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.close,
                                          color: Colors.red, size: 12),
                                      const SizedBox(width: 2),
                                      Text(numberOfIncorrectAnswers.toString(),
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 35,
                              height: 25,
                              decoration: BoxDecoration(
                                color:
                                    Colors.grey[300], // set the color to green
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error_outline_outlined,
                                          color: Colors.grey, size: 12),
                                      const SizedBox(width: 2),
                                      Text(
                                          numberOfUnattemptedAnswers.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 5),
                        const Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('20%',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Accuracy',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            SizedBox(width: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('5/10',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Points', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
