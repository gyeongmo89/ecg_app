// calendar.dart: 증상노트 캘린더

import 'dart:async';
import 'package:ecg_app/bluetooth/utils/bluetooth_manager.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late List<Schedule> selectedDaySchedules = [];
  StreamSubscription<List<Schedule>>? _schedulesSubscription; // 스트림 구독 추가
  String formattedDate = ''; // formattedDate 필드 추가


  String calculateFinishDate(String formattedDate) {
    DateTime startDate = DateFormat('yyyy-MM-dd HH:mm').parse(formattedDate);
    DateTime finishDate = startDate.add(Duration(days: 7));
    return DateFormat('yyyy-MM-dd HH:mm').format(finishDate);
  }

  Future<void> loadStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    formattedDate = prefs.getString(BluetoothManager.START_DATE_KEY) ?? '';
    if (formattedDate.isNotEmpty && DateTime.tryParse(formattedDate) == null) {
      formattedDate = '';
    }
  }


  void _fetchEvents() {
    Stream<List<Schedule>> schedulesStream =
        widget.localDatabase.getAllSchedules();

    _schedulesSubscription = schedulesStream.listen((schedules) {
      if (mounted) { // 위젯이 여전히 마운트되어 있는지 확인
        setState(() {
          // 전체 일정 데이터가 업데이트될 때마다 selectedDaySchedules를 업데이트합니다.
          selectedDaySchedules = schedules;
        });
      }
    });
    // schedulesStream.listen((schedules) {
    //   setState(() {
    //     // 전체 일정 데이터가 업데이트될 때마다 selectedDaySchedules를 업데이트합니다.
    //     selectedDaySchedules = schedules;
    //   });
    // });
  }
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

  @override
  void dispose() {
    _schedulesSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadStartDate();
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      shape: BoxShape.rectangle,
      color: Colors.white,
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

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
        ),
      ),
      calendarStyle: CalendarStyle(
        markersMaxCount: 5,
        isTodayHighlighted: false,
        //오늘날짜 표시, false로 해야 에러안남
        defaultDecoration: defaultBoxDeco,
        weekendDecoration: defaultBoxDeco,

        disabledDecoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),

        selectedDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.black,

          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: PRIMARY_COLOR2,
            width: 1.0,
          ),
        ),
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle.copyWith(
          color: Colors.red,
        ),
        selectedTextStyle: defaultTextStyle.copyWith(
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
      // enabledDayPredicate: (day) {
      //   // formattedDate가 빈 문자열인지 확인
      //   print("formattedDate: $formattedDate");
      //   if (formattedDate.isEmpty) {
      //     return false;
      //   }
      //   // formattedDate를 DateTime 객체로 변환
      //   DateTime startDate = DateFormat('yyyy-MM-dd HH:mm').parse(formattedDate);
      //   // startDate 이전의 날짜는 선택 불가능하게 함
      //   return day.isAfter(startDate);
      // },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          switch (day.weekday) {
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
      enabledDayPredicate: (day) {
        // formattedDate가 빈 문자열인지 확인
        // print("formattedDate: $formattedDate");
        if (formattedDate.isEmpty) {
          return false;
        }
        // formattedDate를 DateTime 객체로 변환
        DateTime startDate = DateFormat('yyyy-MM-dd HH:mm').parse(formattedDate);
        // startDate의 시간과 분 정보를 제거
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        // finishDate 계산
        DateTime finishDate = DateFormat('yyyy-MM-dd HH:mm').parse(calculateFinishDate(formattedDate));
        // finishDate의 시간과 분 정보를 제거
        finishDate = DateTime(finishDate.year, finishDate.month, finishDate.day);
        // startDate 이후이고 finishDate 이전의 날짜만 선택 가능하게 함
        return day.isAfter(startDate) && day.isBefore(finishDate);
      },



    );
  }
}