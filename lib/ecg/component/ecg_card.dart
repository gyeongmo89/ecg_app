// 테스트2

// import 'dart:js_util';

import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class EcgCard extends StatelessWidget {
  final Widget bleImage;
  final Widget hrImage;
  final Widget ecgImage;
  final String bleStatus;
  final Widget calenderImage;

  // final int heartRate;
  // final int average;
  // final int minimum;
  // final int maximum;

  const EcgCard(
      {required this.bleImage,
      required this.hrImage,
      required this.ecgImage,
      required this.bleStatus,
      required this.calenderImage,
      // required this. name,
      // required this. heartRate,
      // required this. average,
      // required this.  minimum,
      // required this.  maximum,

      super.key});

// icon: Icon(Icons.edit_calendar_outlined),
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                // 이미지를 깎을 수 있다
                borderRadius: BorderRadius.circular(12.0),
                child: bleImage,
              ),
              const SizedBox(width: 10.0),
              const Text(
                "Connected",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: deviceWidth * 0.25,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: calenderImage,
              ),
              const SizedBox(width: 10.0),
              const Text(
                "14 Day",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                // 이미지를 깎을 수 있다
                borderRadius: BorderRadius.circular(12.0),
                child: hrImage,
              ),
              const SizedBox(width: 10.0),
              const Text(
                "75",
                style: TextStyle(fontSize: 20),
              ),
              const Text(
                " bpm",
                style: TextStyle(fontSize: 20, color: SUB_TEXT_COLOR),
              )
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                // 이미지를 깎을 수 있다
                borderRadius: BorderRadius.circular(12.0),
                child: ecgImage,
              ),
              const SizedBox(
                width: 10.0,
              ),
              const Text("ECG Monitoring",
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ],
          ),
          SizedBox(
            height: deviceHeight / 70 * 2,
          ),
          Container(
            width: deviceWidth,
            height: deviceHeight / 6 * 2,
            color: Colors.grey,
          ),
          SizedBox(
            height: deviceHeight / 30 * 2,
          ),
//----------------------------------------------------------------------
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Average",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                width: 30,
              ),
              Text("Minimum",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                width: 30,
              ),
              Text("Maximum",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),

          const Divider(
            thickness: 2,
            height: 4,
            color: PRIMARY_COLOR,
          ),
          // Divider(thickness: 2, height: 3, color: PRIMARY_COLOR,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "75",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "bpm",
                        style: TextStyle(
                          fontSize: 18,
                          color: SUB_TEXT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 20.0,
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "63",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "bpm",
                        style: TextStyle(
                          fontSize: 18,
                          color: SUB_TEXT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 20.0,
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "98",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "bpm",
                        style: TextStyle(
                          fontSize: 18,
                          color: SUB_TEXT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
