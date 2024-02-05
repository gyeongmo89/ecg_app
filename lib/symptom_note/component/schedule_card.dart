// 2024-01-12 카드색상 변경

import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime; // 분도 넣으려면 date time 으로 해야함
  final int endTime;
  final String symptom;
  final String content;

  // final Color color;

  const ScheduleCard(
      {required this.startTime,
      required this.endTime,
      required this.symptom,
      required this.content,
      // required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.0,
            // color: PRIMARY_COLOR,
            color: PRIMARY_COLOR2,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            //가장 큰 위젯과 같은 높이를 차지 할 수 있도록 함
            child: Row(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // 최대사이즈 차지하도록 그런데 높이를 지정안해주면, Flutter가 알수 없어 흰색으로 나옴
              children: [
                _Time(
                  startTime: startTime,
                  endTime: endTime,
                ),
                SizedBox(
                  width: 16.0,
                ),
                _Symptom(
                  symptom: symptom,content: content,
                ),
                // _Content(
                //   content: content,
                // ),
                SizedBox(
                  width: 16.0,
                ),
                // _Category(color: color),
              ],
            ),
          ),
        ));
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;


  const _Time({required this.startTime, required this.endTime, super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR2,
      // color: PRIMARY_COLOR,
      fontSize: 16.0,
    );

    int startTimeHour = (startTime / 60).floor().toInt();
    int startTimMinute = startTime % 60;

    int endTimeHour = (endTime / 60).floor().toInt();
    int endTimMinute = endTime % 60;

    return Column(
      children: [
        Text(
          "${startTimeHour.toString().padLeft(2, "0")}:${startTimMinute.toString().padLeft(2, "0")}",
          style: textStyle,
        ),
        Text(
          "${endTimeHour.toString().padLeft(2, "0")}:${endTimMinute.toString().padLeft(2, "0")}",
          style: textStyle.copyWith(
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}

//     int startTimeHour = (startTime ~/ 60).floor().toInt();
//     int startTimeMinute = (startTime % 60).floor().toInt();
//     int startTimeSecond = ((startTime % 60) * 60).floor().toInt(); // 소수 부분을 초로 변환
//
//     int endTimeHour = (endTime ~/ 60).floor().toInt();
//     int endTimeMinute = (endTime % 60).floor().toInt();
//     int endTimeSecond = ((endTime % 60) * 60).floor().toInt(); // 소수 부분을 초로 변환
//
//     return Column(
//       children: [
//         Text(
//           "${startTimeHour.toString().padLeft(2, "0")}:${startTimeMinute.toString().padLeft(2, "0")}:${startTimeSecond.toString().padLeft(2, "0")}",
//           style: textStyle,
//         ),
//         Text(
//           "${endTimeHour.toString().padLeft(2, "0")}:${endTimeMinute.toString().padLeft(2, "0")}:${endTimeSecond.toString().padLeft(2, "0")}",
//           style: textStyle.copyWith(
//             fontSize: 12.0,
//           ),
//         ),
//       ],
//     );
//   }
// }

class _Content extends StatelessWidget {
  final String content;
  const _Content({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}

class _Symptom extends StatelessWidget {
  final String symptom;
  final String content;
  const _Symptom({required this.symptom, required this.content,super.key});

  @override
  Widget build(BuildContext context) {
    String etcSymptom = symptom;
    if(etcSymptom == "기타설명에 작성해 주세요."){
      etcSymptom = content;
    }



    return Expanded(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(etcSymptom, style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
      ],
    ));
  }
}

