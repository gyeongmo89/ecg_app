// 2024-01-12 배너색상 변경

import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;

  const TodayBanner(
      {required this.selectedDay, super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Container(
      // color: PRIMARY_COLOR2,
      // color: Colors.black12,
      color: Colors.black38,
      // color: Colors.black54,

      // color: PRIMARY_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일",
              style: textStyle,
            ),
            StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
                // stream: GetIt.I<LocalDatabase>().watchSchedules(),

              builder: (context, snapshot) {
                int count = 0;

                if(snapshot.hasData){
                  count = snapshot.data!.length;
                }

                return Text(
                  "$count개",
                  style: textStyle,
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
