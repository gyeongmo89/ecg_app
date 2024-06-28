import 'package:ecg_app/ecg/component/ecg_card.dart';
import 'package:ecg_app/symptom_note/component/schedule_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../common/const/colors.dart';

class EcgMonitoringScreen extends StatefulWidget {

  EcgMonitoringScreen({Key? key, required this.device}) : super(key: key);

  // 장치 정보 전달 받기
  final BluetoothDevice? device;

  @override
  State<EcgMonitoringScreen> createState() => _EcgMonitoringScreenState();
}

class _EcgMonitoringScreenState extends State<EcgMonitoringScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 이 부분이 상태 유지를 위한 설정
  final int noteIndex = 1;

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = DateTime.utc(
      // utc를 해외시간 고려(시차)
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Set the background color to transparent
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              //그린계열
              Color(0xFF0DB2B2),
              Color(0xFF00A2C8),
              Color(0xFF0D8CD0),
              Color(0xFF6C70C1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: DeviceScreen(
          device: widget.device!,
          cardioImage: Transform.rotate(
            angle: 3.14 * 1.5, // 270도 회전
            child: Image.asset(
              "asset/img/misc/heartCare1.png",
              width: MediaQuery.of(context).size.width / 5,
              fit: BoxFit.cover,
            ),
          ),
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
                selectedDate: selectedDay, // 선택한 날짜를 전달
                scheduleId: null,
              );
            },
          );
        },
        backgroundColor: PRIMARY_COLOR2,
        child: Icon(
          Icons.edit_note,
          color: Colors.white,
        ),
      ),
    );
  }
}