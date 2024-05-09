import 'package:flutter/material.dart';

void main() {
  runApp(const TopicStatisticsPage());
}

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
          title: const Text(
            'Back to Reports',
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 20),
            // 1
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // add horizontal padding
              child: Container(
                height: 150, // adjust the height as needed
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 228, 222, 222)),
                  color: Colors.white, // set the color to white
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)), // add border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Padding(
                  // add padding to the content inside the container
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // add this line
                        children: <Widget>[
                          Text(
                            'Topic Name',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                // add this widget
                                radius: 8, // adjust the size as needed
                                backgroundColor:
                                    Colors.red, // set the color to red
                              ),
                              SizedBox(
                                  width:
                                      8), // add some space between the icon and the text
                              Text('This quiz has ended'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: Color.fromARGB(255, 228, 222, 222)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 5),
                            Text('Date and Time'),
                          ]),
                          Icon(
                            Icons.star_outline,
                            color: Colors.yellow,
                            size: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 2
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 242, 245),
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
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 238, 242, 245),
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
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 20),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.green, // set the color to green
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 5),
                Text('Correct',
                    style:
                        TextStyle(color: Color.fromARGB(255, 117, 109, 109))),
                SizedBox(width: 20),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.red, // set the color to red
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 5),
                Text('Incorrect',
                    style:
                        TextStyle(color: Color.fromARGB(255, 117, 109, 109))),
              ],
            ),
            // 4
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // add horizontal padding
              child: Container(
                height: 300, // adjust the height as needed
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 228, 222, 222)),
                  color: Colors.white, // set the color to white
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)), // add border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  // add padding to the content inside the container
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      const Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Colors.blue, // set the color to blue
                          ),
                          SizedBox(width: 10),
                          Column(
                            // add this widget
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // align text to the left
                            children: <Widget>[
                              Text('Name',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text('1 Attempts'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: Color.fromARGB(255, 228, 222, 222)),
                      SizedBox(height: 20),
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
                            SizedBox(width: 2),
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
                            SizedBox(width: 2),
                            for (int i = 0; i < numberOfUnattemptedAnswers; i++)
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
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 35,
                            height: 25,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 113, 195, 116), // set the color to green
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check,
                                        color: Colors.white, size: 12),
                                    SizedBox(width: 2),
                                    Text(numberOfCorrectAnswers.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 35,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 232, 152, 147), // set the color to green
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.close,
                                        color: Colors.white, size: 12),
                                    SizedBox(width: 2),
                                    Text(numberOfIncorrectAnswers.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 35,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 215, 205, 205), // set the color to green
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error_outline_outlined,
                                        color: Colors.white, size: 12),
                                    SizedBox(width: 2),
                                    Text(numberOfUnattemptedAnswers.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(color: Color.fromARGB(255, 228, 222, 222)),
                      Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('30%',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text('Accuracy', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: const TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '5',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '/12',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text('Points', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('2085',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text('Score', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
