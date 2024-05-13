import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ResultScreen(100),
  ));
}

class ResultScreen extends StatefulWidget {
  int score;
  ResultScreen(this.score, {Key? key}) : super(key: key);
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Chúc mừng! Bạn đã ôn tập tất cả các câu hỏi',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ))),
              Expanded(
                flex: 1,
                child: Icon(Icons.star,
                    color: Color.fromRGBO(87, 232, 180, 1), size: 60),
              ),
            ],
          ),
          // const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 12,
                            // value: score / 9,
                            value: 9,
                            color: Color.fromRGBO(87, 232, 180, 1),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Text(
                          '100%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color.fromRGBO(87, 232, 180, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              Column(
                children: [
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(214, 243, 237, 1),
                      borderRadius: BorderRadius.circular(
                          100), // Change this radius to your liking
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Know',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(87, 232, 180, 1),
                            ),
                          ),
                          Text(
                            '0', // replace with your number
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(87, 232, 180, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 236, 236, 236),
                      borderRadius: BorderRadius.circular(
                          100), // Change this radius to your liking
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Still Learning',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(244, 118, 72, 1),
                            ),
                          ),
                          Text(
                            '2', // replace with your number
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color.fromRGBO(244, 118, 72, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 236, 236, 236),
                      borderRadius: BorderRadius.circular(
                          100), // Change this radius to your liking
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Terms left',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '0', // replace with your number
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          // const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    // Handle your click event here
                  },
                  child: const Text(
                    'Back to last question',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 26, 63, 186),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: GestureDetector(
                  onTap: () {
                    // Implement your function here
                  },
                  child: Expanded(
                    child: Container(
                      width: 450,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(66, 84, 254, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            // Icon 2 thẻ chồng lên
                            Icons.receipt_long_sharp,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 250,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tiếp tục xem lại 2 thuật ngữ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
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
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: GestureDetector(
                  onTap: () {
                    // Implement your function here
                  },
                  child: Expanded(
                    child: Container(
                      width: 450,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 244, 240, 240),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            // Icon 2 thẻ chồng lên
                            Icons.refresh_outlined,
                            size: 35,
                            color: Color.fromRGBO(66, 84, 254, 1),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 200,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Thực hành ở mục học',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromRGBO(66, 84, 254, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    // Handle your click event here
                  },
                  child: const Text(
                    'Restart Flashcards',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 26, 63, 186),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
