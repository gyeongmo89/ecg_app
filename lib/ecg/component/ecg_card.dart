// Hr 차트 추가 시작
import 'dart:async';
import 'dart:math';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/ecg/view/ecg_chart.dart';
import 'package:ecg_app/ecg/view/hr_chart.dart';
import 'package:flutter/material.dart';

class EcgCard extends StatefulWidget {
  final Widget bleImage;
  final Widget hrImage;
  final Widget ecgImage;
  final String bleStatus;
  final Widget calenderImage;
  final Widget cardioImage;

  const EcgCard(
      {required this.bleImage,
      required this.hrImage,
      required this.ecgImage,
      required this.bleStatus,
      required this.calenderImage,
      required this.cardioImage,
      super.key});

  @override
  State<EcgCard> createState() => _EcgCardState();
}

class _EcgCardState extends State<EcgCard> {
  int heartRate = 75;

  void startUpdatingHeartRate() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Generate a random number between 70 and 110.
          final random = Random();
          heartRate = 80 + random.nextInt(20);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startUpdatingHeartRate();
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
                  const SizedBox(
                    width: 4.0,
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
          const SizedBox(height: 16.0),
// -------------------- BODY ECG --------------------
          Container(

            height: deviceHeight/3.2,
            width: deviceWidth,
            // height: 230.0,
            // width: 380.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: const Color(0xFFE6EBF0),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                )),
            child: Column(
              children: [
                Container(
                  // height: deviceHeight,
                  width: deviceWidth/1.25,
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
                      EcgChart(),
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
            height: deviceHeight/3.2,
            width: deviceWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: const Color(0xFFE6EBF0),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                )),
            child: Column(
              children: [
                Container(
                  // height: 220.0,
                  width: deviceWidth/1.25,
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
