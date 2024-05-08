import 'package:flutter/material.dart';
import 'ReportStaticPage.dart';


void main() {
  runApp(const ReportPage());
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Reports'),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.swap_horiz),
            // ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Xử lý khi click vào topic ở đây
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopicStatisticsPage()),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 109, 180, 237),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.toc_outlined, size: 20),
                    ),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    flex: 8,
                    child: GestureDetector(
                      onTap: () {
                        // Xử lý khi click vào topic ở đây
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TopicStatisticsPage()),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Topic Name'),
                          SizedBox(height: 5),
                          Text('Completed days ago'),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Icon(Icons.people_alt_outlined, size: 20),
                              SizedBox(width: 5),
                              Text('5 participants'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 205, 149, 149),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('50%', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            // Continue with the rest of your body widgets
          ],
        ),
      ),
    );
  }
}
