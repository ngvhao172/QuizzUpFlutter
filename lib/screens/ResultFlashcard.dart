import 'package:final_quizlet_english/screens/TopicFlashcard.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultFlashcard extends StatefulWidget {
  const ResultFlashcard({super.key, required this.knew, required this.learning});

  final int knew;
  final int learning;

  @override
  State<ResultFlashcard> createState() => _ResultFlashcardState();
}

class _ResultFlashcardState extends State<ResultFlashcard> {

  @override
  Widget build(BuildContext context) {
    double percentage = widget.knew/(widget.knew+widget.learning)*100;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.close), onPressed: (){
                Navigator.pop(context, "false");
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
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              'Congratulations! Try testing your self for extra practice',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
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
                // const SizedBox(height: 5),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Your progressing',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
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
                                              fontSize: 20,
                                              color: Colors.orange),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      widget.knew.toString(),
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
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Still learning',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    Text(
                                      widget.learning.toString(), 
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
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text(
                        'Next Step',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Implement your function here
                        Navigator.pop(context, "to-quiz");
                      },
                      child: Container(
                        width: 450,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Icon(
                              Icons.receipt_long_sharp,
                              size: 35,
                              color: Colors.blueAccent,
                            ),
                            //const SizedBox(width: 30),
                            SizedBox(
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Learn these terms',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    'Answer questions about this terminology to build your knowledge',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //const SizedBox(width: 70),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.blueAccent,
                            )
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
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Icon(
                              Icons.refresh_outlined,
                              size: 35,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Restart the flash card',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    'Learn the terminology from the beginning',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.blueAccent,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }
}
