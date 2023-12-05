import 'package:ecg_app/common/component/calendar.dart';
import 'package:ecg_app/common/component/custom_button.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:ecg_app/model/schedule_with_color.dart';
import 'package:ecg_app/symptom_note/component/schedule_bottom_sheet.dart';
import 'package:ecg_app/symptom_note/component/schedule_card.dart';
import 'package:ecg_app/symptom_note/component/today_banner.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';

// 나머지 코드에서는 Flutter.Column 또는 Drift.Column을 사용하실 수 있습니다.

final localDatabase = LocalDatabase(); // LocalDatabase 인스턴스 생성

class SymptomNote2 extends StatefulWidget {
  const SymptomNote2({super.key});

  @override
  State<SymptomNote2> createState() => _SymptomNote2State();
}

class _SymptomNote2State extends State<SymptomNote2> {
  DateTime selectedDay = DateTime.utc(
    // utc를 해외시간 고려(시차)
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // bool isToday = isSameDay(selectedDay, DateTime.now());
    bool isTodayOrBefore = selectedDay.isBefore(DateTime.now()) ||
        isSameDay(selectedDay, DateTime.now());

    return Scaffold(
      floatingActionButton:
          isTodayOrBefore ? renderFloatingActionButton() : null,
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
              localDatabase: GetIt.I<LocalDatabase>(), // 켈린더 수정하면서 임시 추가
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
            _ScheduleList(
              selectedDate: selectedDay,
            ),
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
              selectedDate: selectedDay,
              scheduleId: null,
            );
          },
        );
      },
      // backgroundColor: PRIMARY_COLOR,
      backgroundColor: PRIMARY_COLOR2,
      // child: Icon(Icons.add),
      child: Icon(Icons.edit_note),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatefulWidget {
  // 내가 임의 코드 추가
  final DateTime selectedDate;

  const _ScheduleList({required this.selectedDate, super.key});

  @override
  State<_ScheduleList> createState() => _ScheduleListState();
}

DateTime selectedDay = DateTime.utc(
  // utc를 해외시간 고려(시차)
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

class _ScheduleListState extends State<_ScheduleList> {
  @override
  Widget build(BuildContext context) {
    bool isTodayOrBefore = selectedDay.isBefore(DateTime.now()) ||
        isSameDay(selectedDay, DateTime.now());

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        // child: ListView.builder(
        // child: ListView.separated(
        child: StreamBuilder<List<Schedule>>(
            // stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            stream:
                GetIt.I<LocalDatabase>().watchSchedules(widget.selectedDate),
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
              if (!snapshot.hasData) {
                // snapshot hasData 가 false 이면
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData && snapshot.data!.isEmpty) {
                if (isTodayOrBefore && !widget.selectedDate.isAfter(DateTime.now())) {
                  return Center(
                    child: Text("등록된 증상노트가 없습니다."),
                  );
                } else if (widget.selectedDate.isAfter(DateTime.now())) {
                  return const Center(
                    child: Text("검사가 진행되지 않은 날짜 이므로 등록할 수 없습니다."),
                  );
                }
              }

              return ListView.separated(
                  itemCount: snapshot.data!.length, // 스케쥴의 길이만큼 아이템 카드를 그린다.
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 8.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    final schedule = snapshot.data![index];

                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("삭제 확인"),
                              content: Text("삭제하시겠습니까?"),
                              actions: [
                                CustomButton(
                                    text: "취소",
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    backgroundColor: CANCEL_COLOR2),
                                CustomButton(
                                  text: "확인",
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    GetIt.I<LocalDatabase>()
                                        .removeSchedule(schedule.id);
                                    setState(() {
                                      snapshot.data!.remove(schedule);
                                    });
                                  },
                                  backgroundColor: SAVE_COLOR2,
                                ),
                              ],
                            );
                          },
                        ).then((value) {
                          if (value != null && value) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      // 스와이프 했을때 그 순간 이벤트를 받으려면 onDismissed
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                                true, // 최대사이즈(?) 적용으로 input 박스눌렀을때 키보드가 올라와도 컨테이너가 위로올라감
                            builder: (_) {
                              return ScheduleBottomSheet(
                                selectedDate: widget.selectedDate,
                                scheduleId:
                                    schedule.id, // 카드눌렀을때 이전정보 불러와야되니까 1
                              );
                            },
                          );
                        },
                        child: ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          symptom: schedule.symptom,
                          content: schedule.content,
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
