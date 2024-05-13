import 'package:flutter/material.dart';


class ResultFlashcard extends StatefulWidget {
  const ResultFlashcard({super.key});

  @override
  State<ResultFlashcard> createState() => _ResultFlashcardState();
}

class _ResultFlashcardState extends State<ResultFlashcard> {
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
                  Expanded(
                      flex: 2,
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Chúc mừng! Bạn đã ôn tập tất cả các thẻ',
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
              const Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Tiến độ của bạn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 114, 113, 113),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 5),
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
                            Icon(
                              Icons.check,
                              color: Color.fromRGBO(87, 232, 180, 1),
                              size: 50,
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
                                'Hoàn thành',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromRGBO(87, 232, 180, 1),
                                ),
                              ),
                              Text(
                                '1', // replace with your number
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
                                'Còn lại',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '1', // replace with your number
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
              const Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Bước tiếp theo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 114, 113, 113),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        // Implement your function here
                      },
                      child: Expanded(
                        child: Container(
                          width: 450,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 246, 239, 239),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.refresh_outlined,
                                size: 35,
                                color: Color.fromRGBO(66, 84, 254, 1),
                              ),
                              SizedBox(width: 30),
                              Container(
                                width: 250, // Set your desired width
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Học các thuật ngữ này',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromRGBO(66, 84, 254, 1),
                                      ),
                                    ),
                                    Text(
                                      'Trả lời các câu hỏi về thuật ngữ này để xây dựng kiến thức',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromRGBO(85, 83, 83, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 70),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Color.fromRGBO(66, 84, 254, 1),
                              )
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
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        // Implement your function here
                      },
                      child: Expanded(
                        child: Container(
                          width: 450,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 244, 240, 240),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                // Icon 2 thẻ chồng lên
                                Icons.receipt_long_sharp,
                                size: 35,
                                color: Color.fromRGBO(66, 84, 254, 1),
                              ),
                              SizedBox(width: 30),
                              Container(
                                width: 250, // Set your desired width
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đặt lại thẻ ghi nhớ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromRGBO(66, 84, 254, 1),
                                      ),
                                    ),
                                    Text(
                                      'Học lại thuật ngữ từ đầu',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Color.fromRGBO(85, 83, 83, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 70),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Color.fromRGBO(66, 84, 254, 1),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // InkWell(
              //   onTap: () {
              //     // Implement your function here
              //   },
              //   child: const Text(
              //     'Restart Flashcards',
              //     style: TextStyle(
              //       fontSize: 34,
              //       fontWeight: FontWeight.w500,
              //       color: Color.fromARGB(255, 9, 98, 171),
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }
}
