import 'package:ecg_app/common/component/calendar.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:ecg_app/model/schedule_with_color.dart';
import 'package:ecg_app/symptom_note/component/schedule_bottom_sheet.dart';
import 'package:ecg_app/symptom_note/component/schedule_card.dart';
import 'package:ecg_app/symptom_note/component/today_banner.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


// 나머지 코드에서는 Flutter.Column 또는 Drift.Column을 사용하실 수 있습니다.



class SymptomNote2 extends StatefulWidget {
  const SymptomNote2({super.key});

  @override
  State<SymptomNote2> createState() => _SymptomNote2State();
}

class _SymptomNote2State extends State<SymptomNote2> {
  DateTime selectedDay = DateTime.utc(      // utc를 해외시간 고려(시차)
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(
              height: 8.0,
            ),
            TodayBanner(
              selectedDay: selectedDay,
            ),
            const SizedBox(
              height: 8.0,
            ),
            _ScheduleList(selectedDate: selectedDay,),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled:
              true, // 최대사이즈(?) 적용으로 input 박스눌렀을때 키보드가 올라와도 컨테이너가 위로올라감
          builder: (_) {
            return ScheduleBottomSheet(
              selectedDate: selectedDay, scheduleId: null,
            );
          },
        );
      },
      // backgroundColor: PRIMARY_COLOR,
      backgroundColor: PRIMARY_COLOR2,
      child: Icon(Icons.add),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  // 내가 임의 코드 추가
  final DateTime selectedDate;

  const _ScheduleList({
    required this.selectedDate,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        // child: ListView.builder(
        // child: ListView.separated(
        child: StreamBuilder<List<Schedule>>(
            // stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            builder: (context, snapshot) {
              // print('-----------original data ------------');
              // print(snapshot.data);
              // List<Schedule> schedules = []; // 날짜별로 카드가 달라야하기 떄문에
              //
              // if (snapshot.hasData) {
              //   schedules = snapshot.data!
              //       .where((element) => element.date.toUtc() == selectedDate)
              //       .toList();
              //
              //   print('---------------filtered data-----------');
              //   print(selectedDate);
              //   print(schedules);
              // } // 애초에 (drift_database.dart에서 )필터링 해서 나오기때문에 주석처리
              // print(snapshot.data);
              if(!snapshot.hasData) { // snapshot hasData 가 false 이면
                return Center(child: CircularProgressIndicator());
              }

              if(snapshot.hasData && snapshot.data!.isEmpty){
                return Center(
                  child: Text("등록된 증상노트가 없습니다."),
                );
              }


              return ListView.separated(
                  // itemCount: snapshot.data!.length,  // 스케쥴의 길이만큼 아이템 카드를 그린다. // 원래 이거 였는데 아래꺼로 하니까 정상적으로 해당날짜에 카드를 그려줌
                  itemCount: snapshot.data!.length,  // 스케쥴의 길이만큼 아이템 카드를 그린다.
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 8.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    // final scheduleWithColor = snapshot.data![index];
                    final schedule = snapshot.data![index];
                    // final schedule = snapshot.data![index];  //원래 이거 였는데 위 에꺼로 하니까 정상적으로 해당날짜에 카드를 그려줌

                    return Dismissible( // 왼쪽, 오른쪽 스와이프하는 액션을 만들어 줄 수 있음.
                      key: ObjectKey(schedule.id),

                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction){
                        // 삭제 쿼리
                        GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                      },  // 스와이프 했을때 그 순간 이벤트를 받으려면 onDismissed
                      child: GestureDetector(
                        onTap: (){
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                            true, // 최대사이즈(?) 적용으로 input 박스눌렀을때 키보드가 올라와도 컨테이너가 위로올라감
                            builder: (_) {
                              return ScheduleBottomSheet(
                                selectedDate: selectedDate,
                                scheduleId: schedule.id,  // 카드눌렀을때 이전정보 불러와야되니까 1
                              );
                            },
                          );
                        },
                        child: ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          symptom: schedule.symptom,
                          content: schedule.content,

                          // color: Color(
                          //   int.parse("FF${scheduleWithColor.categoryColor.hexCode}",
                          //   radix: 16),
                          // ),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}

