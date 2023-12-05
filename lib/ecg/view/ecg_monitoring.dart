import 'package:dio/dio.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:ecg_app/ecg/component/ecg_card.dart';
import 'package:ecg_app/symptom_note/component/schedule_bottom_sheet.dart';
import 'package:ecg_app/symptom_note/view/symptom_note2_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

import '../../common/const/colors.dart';

class EcgMonitoringScreen extends StatelessWidget {
  final int noteIndex = 1; // 전달할 noteIndex 변수 선언
  const EcgMonitoringScreen({super.key});


//09:03
  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = DateTime.utc(
      // utc를 해외시간 고려(시차)
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );


    return Scaffold(
      body: EcgCard(
        cardioImage: Image.asset(
          // "asset/img/icon/Cardio1.png",
          "asset/img/misc/HolmesCardio_2.png",
          width: MediaQuery.of(context).size.width / 6,
          fit: BoxFit.cover,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // SymptomNote2에서 ScheduleBottomSheet를 열도록 함
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return ScheduleBottomSheet(
                // selectedDate: DateTime.now(), // 필요한 날짜를 전달하세요.
                selectedDate: selectedDay, // 필요한 날짜를 전달하세요.
                scheduleId: null,
              );
            },
          );
        },
        backgroundColor: PRIMARY_COLOR2,
        child: Icon(Icons.edit_note),
      ),
    );
    // heartRate : 75,
    // average : 77,
    // minimum : 66,
    // maximum : 85,
    // ); //이미 bottom, appbar가 있어서 scafold 할필요 없음
  }
}
