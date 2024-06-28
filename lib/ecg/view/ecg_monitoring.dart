import 'package:ecg_app/ecg/component/ecg_card.dart';
import 'package:ecg_app/symptom_note/component/schedule_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../../common/const/colors.dart';

class EcgMonitoringScreen extends StatelessWidget {
  final int noteIndex = 1; // 전달할 noteIndex 변수 선언
  const EcgMonitoringScreen({super.key});

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
          "asset/img/misc/healthCare.png",
          width: MediaQuery.of(context).size.width / 6,
          fit: BoxFit.cover,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ScheduleBottomSheet를 열도록 함
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return ScheduleBottomSheet(
                selectedDate: selectedDay, // 필요한 날짜를 전달하세요.
                scheduleId: null,
              );
            },
          );
        },
        backgroundColor: PRIMARY_COLOR2,
        child: const Icon(Icons.edit_note),
      ),
    );
  }
}
