import 'dart:async';
import 'dart:math';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/ecg/component/hr_chart.dart';
import 'package:ecg_app/ecg/view/ecg_test.dart';
import 'package:flutter/material.dart';
// ECG 필요없는 부분 삭제 2023-12-05 16:01

class EcgCard extends StatefulWidget {
  final Widget cardioImage;

  const EcgCard({required this.cardioImage, super.key});

  @override
  State<EcgCard> createState() => _EcgCardState();
}

class _EcgCardState extends State<EcgCard> {
  int heartRate = 75;
  int avg = 75;
  int min = 75;
  int max = 75;

  // heartRate, avg, min, max 랜덤 값으로 설정하는 함수
  void startUpdatingHeartRate() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Generate a random number between 70 and 110.
          final random = Random();
          heartRate = 80 + random.nextInt(20);
          avg = 70 + random.nextInt(20);
          min = 65 + random.nextInt(20);
          max = 75 + random.nextInt(20);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startUpdatingHeartRate(); // heartRate, avg, min, max 랜덤 값으로 설정하는 함수
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
// -------------------- 타이틀 --------------------
              // Cardio 이미지
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: widget.cardioImage,
                  ),
                  SizedBox(
                    width: deviceWidth / 9 / 4,
                  ),
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Holmes Cardio",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: BODY_TEXT_COLOR,
                            )),
                        Text("Connected",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            )),
                      ]),
                ],
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Container(
                      height: 55,
                      // height: deviceHeight / 9,
                      width: 40,
                      alignment: Alignment.center,
                    ),
                    Text(
                      heartRate.toString(), // HR 랜덤값
                      style: const TextStyle(
                        fontSize: 40,
                        color: BODY_TEXT_COLOR,
                      ),
                    ),
                    const Text(
                      " bpm",
                      style: TextStyle(fontSize: 18, color: SUB_TEXT_COLOR),
                    ),
                  ],
                ),
              ),
            ],
          ),
// --------------------------------------------------
//           SizedBox(height: deviceHeight/7),
          SizedBox(height: deviceHeight / 67),
          const Row(
            children: [
              Text("Recording Time  14:07"),
            ],
          ),
          SizedBox(height: deviceHeight / 67),
// -------------------- Average, Minimum, Maximum --------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    "AVG",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: PRIMARY_COLOR2),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Column(
                        children: [
                          Text(
                            avg.toString(), //
                            style: const TextStyle(
                              fontSize: 44.0,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "bpm",
                        style: TextStyle(
                            fontSize: 14.0, color: SUB_TEXT_COLOR),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                  height: 45.0,
                  child: VerticalDivider(
                    color: PRIMARY_COLOR2,
                    thickness: 1.0,
                  )),
              Column(
                children: [
                  const Text(
                    "MIN",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: PRIMARY_COLOR2),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        min.toString(), //
                        style: const TextStyle(
                          fontSize: 44.0,
                        ),
                      ),
                      const Text(
                        "bpm",
                        style: TextStyle(
                            fontSize: 14.0, color: SUB_TEXT_COLOR),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                  height: 45.0,
                  child: VerticalDivider(
                    color: PRIMARY_COLOR2,
                    thickness: 1.0,
                  )),
              Column(
                children: [
                  const Text(
                    "MAX",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        // color: PRIMARY_COLOR),
                        color: PRIMARY_COLOR2),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        max.toString(), //
                        style: const TextStyle(
                          fontSize: 44.0,
                        ),
                      ),
                      const Text(
                        "bpm",
                        style: TextStyle(
                            fontSize: 14.0, color: SUB_TEXT_COLOR),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: deviceHeight / 47),
// --------------------------------------------------

// -------------------- BODY ECG --------------------
          Container(
            // height: deviceHeight/3.2,
            height: deviceHeight / 4.3,
            width: deviceWidth,
            // height: 230.0,
            // width: 380.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: const Color(0xFFE6EBF0),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                )),
            child: Column(
              children: [
                SizedBox(
                  // height: deviceHeight,
                  width: deviceWidth / 1.25,
                  // height: 220.0,
                  // width: 320.0,
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("ECG",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: BODY_TEXT_COLOR,
                              )),
                        ],
                      ),
                      EcgChart2(),
                    ],
                  ),
                ),
              ],
            ),
          ),
// --------------------------------------------------
          SizedBox(
            height: deviceHeight / 80 * 2,
          ),
// -------------------- BODY HR --------------------
          Container(
            // height: deviceHeight/3.2,
            height: deviceHeight / 4.3,
            width: deviceWidth,

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: const Color(0xFFE6EBF0),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                )),
            child: Column(
              children: [
                SizedBox(
                  // height: 220.0,
                  width: deviceWidth / 1.25,
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Text("HR",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: BODY_TEXT_COLOR,
                              )),
                        ],
                      ),
                      HrChart(),
                    ],
                  ),
                ),
              ],
            ),
          ),
// --------------------------------------------------
        ],
      ),
    );
  }
}
