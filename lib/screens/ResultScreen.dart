import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key? key, required this.knew, required this.learning, required this.notAnswered, required this.total, required this.finishTime}) : super(key: key);

  final int knew;
  final int learning;
  final int notAnswered;
  final int total;
  final int finishTime;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

 String formatDuration(int seconds) {
  final int hours = seconds ~/ 3600;
  final int minutes = (seconds % 3600) ~/ 60;
  final int remainingSeconds = seconds % 60;

  final String hoursStr = hours > 0 ? '${hours.toString().padLeft(2, '0')}h': '';
  final String minutesStr = minutes > 0 || hours > 0 ? '${(minutes % 60).toString().padLeft(2, '0')}m': '';
  final String secondsStr = '${remainingSeconds.toString().padLeft(2, '0')}s';

  return '$hoursStr$minutesStr$secondsStr';
}



  @override
  Widget build(BuildContext context) {
    int learning = widget.total - widget.knew - widget.notAnswered;
    double percentage = widget.knew/(widget.knew + learning + widget.notAnswered)*100;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.close), onPressed: (){
          Navigator.pop(context, false);
        },)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Congratulations! You have reviewed all the terms',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ))),
              Expanded(
                  flex: 1,
                  child: Image.asset(
                    "assets/images/QLogo.png",
                    height: 100,
                  )
                  //child: Icon(Icons.star, color: Colors.lightGreen, size: 60),
                  ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 100,
                                  showLabels: false,
                                  showTicks: false,
                                  startAngle: 270,
                                  endAngle: 270,
                                  axisLineStyle: const AxisLineStyle(
                                    thickness: 0.2,
                                    cornerStyle: CornerStyle.bothCurve,
                                    color: Color.fromARGB(30, 0, 169, 181),
                                    thicknessUnit: GaugeSizeUnit.factor,
                                  ),
                                  pointers: <GaugePointer>[
                                    RangePointer(
                                      value: percentage,
                                      cornerStyle: CornerStyle.bothCurve,
                                      width: 0.2,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      color: Colors.lightGreen,
                                    )
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      positionFactor: 0.1,
                                      angle: 90,
                                      widget: Text(
                                        '${percentage.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.orange),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text("Finished in ${formatDuration(widget.finishTime)}", style: const TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),                  
                ],
              ),
              //const SizedBox(width: 30),
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Knew',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.lightGreen,
                            ),
                          ),
                          Text(
                            widget.knew.toString(), // replace with your number
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.lightGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[100],
                      borderRadius: BorderRadius.circular(
                          100), // Change this radius to your liking
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Still Learning',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            learning.toString(), // replace with your number
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 236, 236),
                      borderRadius: BorderRadius.circular(
                          100), // Change this radius to your liking
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Terms left',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            widget.notAnswered.toString(), // replace with your number
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ],
          ),
          // s
          const SizedBox(height: 140),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Implement your function here
                    if(percentage!=100.0){
                      Navigator.pop(context, "wrong-question");
                    }
                    else{
                      Navigator.pop(context, "to-typing");
                    }
                  },
                  child: Container(
                      width: 450,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(66, 84, 254, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.receipt_long_sharp,
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
                                  'Continue learning the terms',
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
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, "true");
                  },
                  child: Container(
                      width: 450,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.refresh_outlined,
                            size: 35,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Restart Quiz',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blueAccent,
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

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: GestureDetector(
          //         onTap: () {
          //           // Handle your click event here
          //         },
          //         child: const Text(
          //           'Restart Quiz',
          //           style: TextStyle(
          //             fontSize: 15,
          //             fontWeight: FontWeight.w700,
          //             color: Colors.blueAccent,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
