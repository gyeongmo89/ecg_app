// 2024-01-12 켈린더 디자인 변경
// 1.요일 색상 변경
// 2.선택 날짜 색상 변경
// 3.주말 날짜 색상 변경

import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String id;

  Event(this.id);
}

class Calendar extends StatefulWidget {
  final DateTime? selectedDay; // selectedDay 값 외부에서 관리 할 수 있도록 선언
  final DateTime focusedDay;
  final OnDaySelected? onDaySelected;
  final localDatabase;

  const Calendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    required this.localDatabase,
    Key? key,
// super.key
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late List<Schedule> selectedDaySchedules = [];

  void _fetchEvents() {
    Stream<List<Schedule>> schedulesStream =
        widget.localDatabase.getAllSchedules();

    schedulesStream.listen((schedules) {
      setState(() {
        // 전체 일정 데이터가 업데이트될 때마다 selectedDaySchedules를 업데이트합니다.
        selectedDaySchedules = schedules;
      });
    });
  }

  // void _fetchEvents() {
  //   if (widget.selectedDay == null) {
  //     return;
  //   }
  //
  //   Stream<List<Schedule>> schedulesStream =
  //       widget.localDatabase.watchSchedules(widget.selectedDay);
  //   print(
  //       "로컬데이터베이스 셀렉티드 베이스 ${widget.localDatabase.watchSchedules(widget.selectedDay)}");
  //   schedulesStream.listen((schedules) {
  //     setState(() {
  //       selectedDaySchedules = schedules;
  //       print("selectedDaySchedules----> $selectedDaySchedules");
  //       print("selectedDaySchedules 렝스----> ${selectedDaySchedules.length}");
  //     });
  //   });
  // }

  List<Widget> _getMarkersForDay(DateTime day) {
    List<Schedule> schedulesForDay = selectedDaySchedules
        .where((schedule) =>
            schedule.date.year == day.year &&
            schedule.date.month == day.month &&
            schedule.date.day == day.day)
        .toList();
    schedulesForDay = schedulesForDay.take(5).toList();
    List<Widget> markers = [];
    if (schedulesForDay.isNotEmpty) {
      for (int i = 0; i < schedulesForDay.length; i++) {
        markers.add(
          Positioned(
            left: 3 + (10.0 * i),
            bottom: 2,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              margin: EdgeInsets.symmetric(horizontal: 1.0),
            ),
          ),
        );
      }
    }

    return markers;
  }

  // List<Widget> _getMarkersForDay(DateTime day) {
  //   List<Schedule> schedulesForDay = selectedDaySchedules.where((schedule) =>
  //   schedule.date.year == day.year &&
  //       schedule.date.month == day.month &&
  //       schedule.date.day == day.day).toList();
  //   // List<Schedule> schedulesForDay = selectedDaySchedules.where((selectedDaySchedules) =>
  //   //     selectedDaySchedules.date.year == day.year &&
  //   //     selectedDaySchedules.date.month == day.month &&
  //   //     selectedDaySchedules.date.day == day.day).toList();
  //
  //   // 최대 마커 개수를 5개로 제한
  //   schedulesForDay = schedulesForDay.take(5).toList();
  //
  //   List<Widget> markers = [];
  //   if (schedulesForDay.isNotEmpty) {
  //     print("schedulesForDay ====>  $schedulesForDay");
  //     print("schedulesForDaylength ====>  ${schedulesForDay.length}");
  //     double totalWidth = 10.0 * (schedulesForDay.length - 1);
  //     // double initialPosition = -totalWidth / 2 + 23.0;
  //     for (int i = 0; i < schedulesForDay.length; i++) {
  //       markers.add(
  //         Positioned(
  //           // left: 10.0 * i, // 각 마커가 가로로 10.0씩 이동
  //           // left: initialPosition + (10.0 * i),
  //           // left: ,
  //           left: 3 + (10.0 * i),
  //           // right: 1 + (10.0 * i),
  //           bottom: 2,
  //           child: Container(
  //             width: 8,
  //             height: 8,
  //             decoration: const BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Colors.red,
  //             ),
  //             margin: EdgeInsets.symmetric(horizontal: 1.0),
  //           ),
  //         ),
  //       );
  //     }
  //
  //   }
  //
  //   return markers;
  // }

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // 데이터를 가져오는 메서드를 initState에 추가합니다.
// events = {
//   DateTime.utc(2023, 11, 22): [
//     Event('title'),
//     Event('title2'),
//     Event('title3'),
//     Event('title4'),
//     Event('title6'),
//     Event('title7'),
//     Event('title8'),
//   ],
//   DateTime.utc(2023, 11, 23): [
//     Event('title8'),
//   ],
// };
  }

// // 이벤트가 등록된 모든 날짜 반환
//   List<DateTime> _getDaysWithEvents() {
//     return events.keys.toList();
//   }

  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      // color: Colors.grey[200],
      color: Colors.white,
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );
// DateTime focusedDay = DateTime.now();

    return TableCalendar(
      // locale: "ko_KR",
      locale: "en_US",
      focusedDay: widget.focusedDay,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
          // color: Colors.white
        ),
      ),
      calendarStyle: CalendarStyle(
        markersMaxCount: 5,
// markerSize: 8.0,
// markerDecoration: BoxDecoration(
//   color: Colors.red,
//   shape: BoxShape.circle
// ),
        isTodayHighlighted: false,
        //오늘날짜 표시, false로 해야 에러안남
        defaultDecoration: defaultBoxDeco,
        weekendDecoration: defaultBoxDeco,
        selectedDecoration: BoxDecoration(
          // color: Colors.white,
          color: Colors.black, //여기

          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: PRIMARY_COLOR2,
            width: 1.0,
          ),
        ),
        // defaultTextStyle: defaultTextStyle,
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle.copyWith(
          color: Colors.red, // Set the weekend text color to white
        ),
        selectedTextStyle: defaultTextStyle.copyWith(
          // color: PRIMARY_COLOR2,
          color: Colors.white,
        ),
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
      ),

      onDaySelected: widget.onDaySelected,
      selectedDayPredicate: (DateTime date) {
        if (widget.selectedDay == null) {
          return false;
        }

        return date.year == widget.selectedDay!.year &&
            date.month == widget.selectedDay!.month &&
            date.day == widget.selectedDay!.day;
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          switch (day.weekday) {
            // case 1:
            //   return Center(child: Text('월',style: TextStyle(color: Colors.white),),);
            // case 2:
            //   return Center(child: Text('화',style: TextStyle(color: Colors.white),),);
            // case 3:
            //   return Center(child: Text('수',style: TextStyle(color: Colors.white),),);
            // case 4:
            //   return Center(child: Text('목',style: TextStyle(color: Colors.white),),);
            // case 5:
            //   return Center(child: Text('금',style: TextStyle(color: Colors.white),),);
            case 1:
              return Center(
                child: Text(
                  '월',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              );
            case 2:
              return Center(
                child: Text(
                  '화',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              );
            case 3:
              return Center(
                child: Text(
                  '수',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              );
            case 4:
              return Center(
                child: Text(
                  '목',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              );
            case 5:
              return Center(
                child: Text(
                  '금',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              );
            case 6:
              return Center(
                child: Text(
                  '토',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            case 7:
              return Center(
                child: Text(
                  '일',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
          }
        },
        markerBuilder: (
          context,
          day,
          events,
        ) {
          List<Widget> markers = [];
          if (widget.selectedDay != null && _getMarkersForDay(day).isNotEmpty) {
            markers.addAll(_getMarkersForDay(day));
          }
          return Stack(
            children: markers,
          );
        },
      ),
    );
  }
}
