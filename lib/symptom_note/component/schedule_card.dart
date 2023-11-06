import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime; // 분도 넣으려면 date time 으로 해야함
  final int endTime;
  final String content;
  final Color color;

  const ScheduleCard(
      {required this.startTime,
      required this.endTime,
      required this.content,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR2,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight( //가장 큰 위젯과 같은 높이를 차지 할 수 있도록 함
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch, // 최대사이즈 차지하도록 그런데 높이를 지정안해주면, Flutter가 알수 없어 흰색으로 나옴
      children: [
            _Time(
              startTime: startTime,
              endTime: endTime,
            ),
            SizedBox(
              width: 16.0,
            ),
            _Content(
              content: content,
            ),
            SizedBox(
              width: 16.0,
            ),
            _Category(color: color),
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
      fontSize: 16.0,
    );

    return Column(
      children: [
        Text(
          "${startTime.toString().padLeft(2, "0")}:00",
          style: textStyle,
        ),
        Text(
          "${endTime.toString().padLeft(2, "0")}:00",
          style: textStyle.copyWith(
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;
  const _Content({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Text(content));
  }
}

class _Category extends StatelessWidget {
  final Color color;
  const _Category({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: 16.0,
      height: 16.0,
    );
  }
}
