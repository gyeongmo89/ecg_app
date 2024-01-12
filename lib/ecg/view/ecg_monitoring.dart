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
      backgroundColor:
          Colors.transparent, // Set the background color to transparent
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color(0xFFFFE8F7),
              // Color(0xFFFFF5FF),
              // Color(0xFFF1F1E6),
              // Color(0xFFFAFAEC),
              // Colors.white,
              //핑크계열
              // Color(0xFF666F9A,),
              // Color(0xFF8974A3,),
              // Color(0xFFAB79A6,),
              // Color(0xFFCA7FA1,),
              //------
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
        child: EcgCard(
          cardioImage: Transform.rotate(
            angle: 3.14 * 1.5, // 270도 회전 (라디안 단위)
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
                selectedDate: selectedDay, // 필요한 날짜를 전달하세요.
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
//
//     return Scaffold(
//       backgroundColor: Color(0xFFF1F1E6),
//       body: EcgCard(
//         cardioImage: Transform.rotate(
//           angle: 3.14 * 1.5, // 270도 회전 (라디안 단위)
//           child: Image.asset(
//             "asset/img/misc/heartCare1.png",
//             width: MediaQuery.of(context).size.width / 5,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // ScheduleBottomSheet를 열도록 함
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             builder: (_) {
//               return ScheduleBottomSheet(
//                 selectedDate: selectedDay, // 필요한 날짜를 전달하세요.
//                 scheduleId: null,
//               );
//             },
//           );
//         },
//         backgroundColor: PRIMARY_COLOR2,
//         child: Icon(Icons.edit_note, color: Colors.white,),
//       ),
//     );
//   }
// }
