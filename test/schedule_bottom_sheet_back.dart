// 2024-01-12 20:08
// 노트작성하는부분 수정 시작 1
// 2024-01-15 17:15 노트쪽 시작 1
// 2024-01-15 17:56 시작시간 종료시간 정합성 수정시작 1

import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:ecg_app/common/component/custom_button.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet(
      {required this.selectedDate, required this.scheduleId, super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime; // null 이 될 수 있게 "?"를 넣은것임  // 시작시간
  int? endTime; // 종료시간
  String? symptom; // 증상
  String? activity; // 활동
  String? content; // 기타설명

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom; // viewInsets 시스템이 차지하는 부분

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(
            FocusNode()); // GestureDetctor를 통해 텍스트 필드 입력후 그주변 눌렀을때 값이 안사라짐
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId == null
              ? null
              : GetIt.I<LocalDatabase>()
                  .getScheduleById(widget.scheduleId!), // 스케쥴 ID 하나 받아옴 //중요
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("증상노트를 불러올 수 없습니다."),
              );
            }

            // FutureBuilder 처음 실행됐고, 로딩중일때
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Future가 실행이 되고, 값이 있는데 단 한번도 startTime이 세팅되지 않았을때
            if (snapshot.hasData && startTime == null) {
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              symptom = snapshot.data!.symptom;
              activity = snapshot.data!.activity;
              content = snapshot.data!.content;
            }

            return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.95 + bottomInset, // 노트 입력 시트 사이즈 조정
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 8.0,
                    ),
                    child: Form(
                      // 아래에 있는 모든 텍스트폼 필드를 컨트롤 할 수 있다.
                      // 폼에는 key를 넣어줘야한다
                      key: formKey, // Form의 컨트롤러 역할
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.edit_calendar_outlined,
                                color: PRIMARY_COLOR2,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Text("노트작성",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: PRIMARY_COLOR2)),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "(${widget.selectedDate.month}월 ${widget.selectedDate.day}일)",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: SUB_TEXT_COLOR,
                                ),
                              ),
                              SizedBox(
                                width: deviceWidth / 4.2,
                              ),
                              _SaveButton(
                                onPressed: onSavePressed,
                              ),
                            ],
                          ),
                          // ----------- 시작/종료시간 -----------
                          _Time(
                            onStartSaved: (int? val) {
                              startTime = val;
                            },
                            onEndSaved: (int? val) {
                              endTime = val;
                            },
                            startInitialValue: startTime?.toString() ?? '',
                            endInitialValue: endTime?.toString() ?? '',
                          ),
                          const Divider(
                            // color: Colors.grey,
                            color: Colors.black38,
                            thickness: 0.5,
                          ),
                          // ----------- 증상선택 -----------
                          _SymptomSelect(
                              symptomSaved: (String? val) {
                                symptom = val;
                              },
                              symptomInitialValue:
                                  symptom?.toString() ?? '증상을 선택해 주세요.'),
                          // ---------------------------------
                          const Divider(
                            // color: Colors.grey,
                            color: Colors.black38,
                            thickness: 0.5,
                          ),
                          // ----------- 활동선택 -----------
                          _ActivitySelect(
                              activitySaved: (String? val) {
                                activity = val;
                              },
                              activityInitialValue:
                                  activity?.toString() ?? '활동을 선택해 주세요.'),
                                  // activity?.toString() ?? ''),
                          // Expanded(
                          //   child: _ActivitySelect(
                          //       activitySaved: (String? val) {
                          //         activity = val;
                          //       },
                          //       activityInitialValue:
                          //           // activity?.toString() ?? '활동을 선택해 주세요.'),
                          //           activity?.toString() ?? ''),
                          // ),
                          // ---------------------------------
                          // SizedBox(
                          //   height:
                          //       MediaQuery.of(context).size.height / 600 / 5,
                          // ),
                          const Divider(
                            color: Colors.black38,
                            thickness: 0.5,
                          ),
                          // ----------- 기타설명 -----------
                          // _Content(
                          //   onSaved: (String? val) {
                          //     content = val;
                          //   },
                          //   initialValue: content ?? '',
                          // ),
                          //button
                          const Row(
                            children: [
                              Icon(
                                Icons.notes,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              _ContentPopup(
                                  // onPressed: onSavePressed,
                                  ),
                            ],
                          ),
                          // ---------------------------------
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 60,
                          ),
                          // _SaveButton(
                          //   onPressed: onSavePressed,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

// -------------- 아래부터는 수행함수 -------------------

// -------------- 저장버튼 눌렀을때 로직 -------------------수정 시작1
  void onSavePressed() async {
    // formKey는 생성을 했는데, Form 위젯과 결합을 안했을때
    // if (formKey.currentState == null) {
    //   return;
    // }

    if (formKey.currentState!.validate()) {
      print("에러가 없습니다.");
      formKey.currentState!.save();
      print({formKey.currentState!.save()});

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('저장 완료'),
            content: const Text('데이터가 정상적으로 저장되었습니다.'),
            actions: [
              CustomButton(
                text: "확인",
                onPressed: () {
                  Navigator.pop(context); // 현재 AlertDialog 닫기
                  // Navigator.of(context).pop(); // 이전 화면으로 이동
                },
                backgroundColor: SAVE_COLOR2,
              ),
            ],
          );
        },
      );
      print("startTime : $startTime");
      print("endTime : $endTime");
      print("symptom : $symptom");
      print("activity : $activity");
      print("Content : $content");
      print("Content : ${(content).runtimeType}");

      if (startTime == null || symptom == null || activity == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('알림'),
              content: const Text('필수 값을 입력해 주세요.'),
              actions: [
                CustomButton(
                  text: "확인",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: SAVE_COLOR2,
                ),
              ],
            );
          },
        );
        return;
      }
      // content 값이 null이고, symptom이 '기타'일 때 알림창 표시
      if (content == "" && symptom == '기타') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('알림'),
              content: const Text('증상이 기타인 경우 기타 설명을 입력해 주세요.'),
              actions: [
                CustomButton(
                  text: "확인",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: SAVE_COLOR2,
                ),
              ],
            );
          },
        );
        return;
      }

      if (widget.scheduleId == null) {
        print("데이터 생성");
        await GetIt.I<LocalDatabase>().createSchedule(
          // 데이터 생성
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            // startTime: Value(startTime!),
            startTime: Value(startTime ?? 0),
            endTime: Value(endTime ?? startTime!),
            symptom: Value(symptom!),
            activity: Value(activity!),
            content: Value(content!),
          ),
        );
      } else {
        print("데이터 업데이트");
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime ?? startTime!),
            symptom: Value(symptom!),
            activity: Value(activity!),
            content: Value(content!),
          ),
        ); // 업데이트
      }
      print("SAVE 완료");
      Navigator.of(context).pop();
    } else {
      print("에러가 있습니다.");
    }
  }
}

// -------------------------------------------
// ------------ 시작/종료시간 입력 --------------
class _Time extends StatefulWidget {
  final FormFieldSetter<int?> onStartSaved;
  final FormFieldSetter<int?> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;
  final bool startTimeStatus;
  final bool endTimeStatus;
  // final int? startTime;
  // final int? endTime;
  // final DateTime selectedDate;

  _Time(
      {required this.onStartSaved,
      required this.onEndSaved,
      required this.startInitialValue,
      required this.endInitialValue,
      this.startTimeStatus = false,
      this.endTimeStatus = false,
      // required this.startTime,
      // required this.endTime,
      // required this.selectedDate,
      super.key});

  @override
  State<_Time> createState() => _TimeState();
}



class _TimeState extends State<_Time> {
  // ------------------- TimePicker -------------------
  // TimeOfDay _startSelectedTime = TimeOfDay.now(); // 시작시간 선택을 위한 변수 추가
  // TimeOfDay _endSelectedTime = TimeOfDay.now();
  TimeOfDay? _startSelectedTime; // 시작시간 선택을 위한 변수 추가
  TimeOfDay? _endSelectedTime;
  // late TimeOfDay _startSelectedTime; // 시작시간 선택을 위한 변수 추가
  // late TimeOfDay _endSelectedTime;
  late String startInitialValue; // 필드로 추가
  late String endInitialValue; // 필드로 추가
  late bool startTimeStatus;
  late bool endTimeStatus;
  late bool startTimeCheck;
  late bool endTimeCheck;
  // late int startTime;
  // late int endTime;
  // late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    startInitialValue = widget.startInitialValue;
    endInitialValue = widget.endInitialValue;
    startTimeStatus = false;
    endTimeStatus = false;
    startTimeCheck = false; // 시작시간 정합성 체크용
    endTimeCheck = false; // 종료시간 정합성 체크용
    _startSelectedTime = null;
    _endSelectedTime = null;
    // _startSelectedTime = TimeOfDay.now();
    // _endSelectedTime = TimeOfDay.now();
    // startTime = startTime;
    // endTime = endTime;
  }

  TimeOfDay convertToTimeOfDay(String value) {
    List<String> timeComponents = value.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  String convertToAmPmFormat(String startInitialValue) {
    int inputValue = int.parse(startInitialValue);
    int hour = inputValue ~/ 60;
    int minute = inputValue % 60;

    String period = '오전';
    if (hour >= 12) {
      period = '오후';
      if (hour != 12) {
        hour -= 12;
      }
    }
    // 시간이 0일 때 12로 변경
    if (hour == 0) {
      hour = 12;
    }

    return '$period ${(hour).toString().padLeft(2, '0')}:${(minute).toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      // initialTime: isStartTime ? _startSelectedTime : _endSelectedTime,
      initialTime: isStartTime
          ? _startSelectedTime ?? TimeOfDay.now()
          : _endSelectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: PRIMARY_COLOR2,
            colorScheme: const ColorScheme.light(primary: PRIMARY_COLOR2),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startSelectedTime = picked;
          startTimeStatus = true;
          widget.onStartSaved(
              _startSelectedTime!.hour * 60 + _startSelectedTime!.minute);
          // _endSelectedTime = TimeOfDay(hour: 0, minute: 0);
        } else {
          _endSelectedTime =
              picked; // 변경: 이 부분에서 현재 시간으로 초기화하지 않고 선택한 시간으로 업데이트
          endTimeStatus = true;
          widget.onEndSaved(
              _endSelectedTime!.hour * 60 + _endSelectedTime!.minute);
          // _startSelectedTime = TimeOfDay(hour: 0, minute: 0);
        }
      });
      print("*********************************************");
      print("_startSelectedTime => $_startSelectedTime");
      print("_endSelectedTime => $_endSelectedTime");
      print("*********************************************");

      DateTime now = DateTime.now();

      if (isStartTime == true) {
        if (_startSelectedTime == null || _endSelectedTime == null) {
          print("시작, 종료 널일때");
          if (_startSelectedTime!.hour > now.hour ||
              (_startSelectedTime!.hour == now.hour &&
                  _startSelectedTime!.minute > now.minute)) {
            // 시작시간이 현재 시간을 넘었는지? 넘었으면 (미래시간으로 설정하셨습니다라는) 알람
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('알림'),
                  content: const Text('시작시간은 현재 시간보다 이후일 수 없습니다.'),
                  actions: [
                    CustomButton(
                      text: "확인",
                      onPressed: () {
                        setState(() {
                          // startTimeStatus = false;
                          startTimeStatus = false;
                          startTimeCheck = true;
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: SAVE_COLOR2,
                    ),
                  ],
                );
              },
            );
          }
          // 시작시간이 종료시간 이전이면 알람
          else if ((_startSelectedTime!.hour > _endSelectedTime!.hour) ||
              (_startSelectedTime!.hour == _endSelectedTime!.hour &&
                  _startSelectedTime!.minute > _endSelectedTime!.minute)) {
            // 시작시간이 종료시간보다 이전이면
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('알림'),
                  content: const Text('시작시간은 종료시간보다 이후일 수 없습니다.'),
                  actions: [
                    CustomButton(
                      text: "확인",
                      onPressed: () {
                        setState(() {
                          // startTimeStatus = false;
                          startTimeCheck = true;
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: SAVE_COLOR2,
                    ),
                  ],
                );
              },
            );
            // return;
          }
        } else {
          print("시작버튼 눌렀을때 로직");

          _endSelectedTime = null;

          //시작시간 버튼 눌렀을때
          if (_startSelectedTime!.hour > now.hour ||
              (_startSelectedTime!.hour == now.hour &&
                  _startSelectedTime!.minute > now.minute)) {
            // 시작시간이 현재 시간을 넘었는지? 넘었으면 (미래시간으로 설정하셨습니다라는) 알람
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('알림'),
                  content: const Text('시작시간은 현재 시간보다 이후일 수 없습니다.'),
                  actions: [
                    CustomButton(
                      text: "확인",
                      onPressed: () {
                        setState(() {
                          // startTimeStatus = false;
                          startTimeStatus = false;
                          startTimeCheck = true;
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: SAVE_COLOR2,
                    ),
                  ],
                );
              },
            );
          }
          // 시작시간이 종료시간 이전이면 알람
          else if ((_startSelectedTime!.hour < _endSelectedTime!.hour) ||
              (_startSelectedTime!.hour == _endSelectedTime!.hour &&
                  _startSelectedTime!.minute < _endSelectedTime!.minute)) {
            // 시작시간이 종료시간보다 이전이면
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('알림'),
                  content: const Text('시작시간은 종료시간보다 이전일 수 없습니다.'),
                  actions: [
                    CustomButton(
                      text: "확인",
                      onPressed: () {
                        setState(() {
                          // startTimeStatus = false;
                          startTimeCheck = true;
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: SAVE_COLOR2,
                    ),
                  ],
                );
              },
            );
            // return;
          }
        }
      }
      //-----------
      // 종료버튼 눌렀을때
      else {
        if (_startSelectedTime == null || _endSelectedTime == null) {
          print("종료버튼 눌렀을때 start, end 타임 널");
          _startSelectedTime = TimeOfDay.now();
          _endSelectedTime = TimeOfDay.now();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('알림'),
                content: const Text('시작시간을 설정해 주세요.'),
                actions: [
                  CustomButton(
                    text: "확인",
                    onPressed: () {
                      setState(() {
                        endTimeStatus = false;
                        startTimeCheck = true; // 11.30 수정
                        _startSelectedTime = null;
                        _endSelectedTime = null;
                        // _endSelectedTime = TimeOfDay.now();
                      });
                      Navigator.pop(context);
                    },
                    backgroundColor: SAVE_COLOR2,
                  ),
                ],
              );
            },
          );
        } else {
          print("종료버튼 눌렀을때 로직");

          // if 종료시간이 현재시간을 넘으면 미래시간으로 설정했다는 알람
          if (_endSelectedTime!.hour > now.hour ||
              (_endSelectedTime!.hour == now.hour &&
                  _endSelectedTime!.minute > now.minute)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('알림'),
                  content: const Text('종료시간은 현재 시간보다 이후일 수 없습니다.'),
                  actions: [
                    CustomButton(
                      text: "확인",
                      onPressed: () {
                        setState(() {
                          endTimeStatus = false;
                          // startTimeCheck = false; // 11.30 수정
                          startTimeCheck = true; // 11.30 수정
                          print("3_startSelectedTime-> $_startSelectedTime");
                          print("3_endSelectedTime-> $_endSelectedTime");
                          // _endSelectedTime = TimeOfDay.now();
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: SAVE_COLOR2,
                    ),
                  ],
                );
              },
            );
          }
          // else 종료시간이 시작시간 이전이면 알람
          else if ((_endSelectedTime!.hour < _startSelectedTime!.hour) ||
              (_endSelectedTime!.hour == _startSelectedTime!.hour &&
                  _endSelectedTime!.minute < _startSelectedTime!.minute)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('알림'),
                  content: const Text('종료시간은 시작시간보다 이전일 수 없습니다.'),
                  actions: [
                    CustomButton(
                      text: "확인",
                      onPressed: () {
                        setState(() {
                          endTimeStatus = false;
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: SAVE_COLOR2,
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    } else {
      setState(() {
        if (!isStartTime) {
          // _endSelectedTime = TimeOfDay(hour: 0, minute: 0);
          endTimeStatus = false;
          widget.onEndSaved(null); // 종료시간을 null로 설정
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // FormFieldSetter<int?> onStartSaved = widget.onStartSaved; // 내가 임의 추가

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.access_time),

            TextButton(
                // 시작시간 버튼
                onPressed: () {
                  _selectTime(
                    context,
                    true,
                  );
                },
                style: TextButton.styleFrom(
                    // backgroundColor: PRIMARY_COLOR2,
                    // primary:  PRIMARY_COLOR,
                    ),
                child: RichText(
                  text: const TextSpan(
                    text: '시작시간 (',
                    // style: DefaultTextStyle.of(context).style,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: BODY_TEXT_COLOR,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ')'),
                    ],
                  ),
                )),
            // SizedBox(
            //   // width: 16.0,
            //   width: deviceWidth / 5 / 4, // 시작시간 종료시간 버튼 간격
            // ),
          ],
        ),
        const Divider(
          // color: Colors.grey,
          color: Colors.black38,
          thickness: 0.5,
        ),
        const Row(
          children: [
            //input finish time image
            Icon(Icons.alarm_add_rounded),
            BlinkingButton(textLabel: "증상지속시간"),

            // TextButton(
            //     onPressed: () {
            //       _selectTime(context, false); // 종료시간 설정
            //       print("종료버튼 클릭");
            //     },
            //     style: TextButton.styleFrom(// backgroundColor: PRIMARY_COLOR2,
            //         // primary:  PRIMARY_COLOR,
            //         ),
            //     // child: const Text("종료시간"),
            //     child: RichText(
            //       text: TextSpan(
            //           text: '증상지속시간',
            //           // style: DefaultTextStyle.of(context).style,
            //           style: TextStyle(
            //             fontSize: 16.0,
            //             fontWeight: FontWeight.w600,
            //             color: BODY_TEXT_COLOR,
            //           )),
            //     )),
          ],
        ),

        // input Divider
        // const SizedBox(
        //   height: 4.0,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 중요함
        //   children: [
        //     Container(
        //       // test 시작
        //       child: () {
        //         if (startInitialValue.toString().isEmpty) {
        //           {
        //             if (startTimeStatus == false) {
        //               // startTimeStatus = true; // 방금추가
        //               return const Text(
        //                 "시간을 등록해 주세요.",
        //                 style: TextStyle(
        //                   fontSize: 14.0,
        //                   color: SUB_TEXT_COLOR,
        //                 ),
        //               );
        //             } else {
        //               if (_startSelectedTime!.period == DayPeriod.am) {
        //                 return Text(
        //                   '오전 ${_startSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime!.minute.toString().padLeft(2, '0')}',
        //                 );
        //               } else {
        //                 return Text(
        //                   '오후 ${_startSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime!.minute.toString().padLeft(2, '0')}',
        //                 );
        //               }
        //             }
        //           }
        //         } else if (startTimeStatus == true) {
        //           {
        //             if (_startSelectedTime!.period == DayPeriod.am) {
        //               return Text(
        //                 '오전 ${_startSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime!.minute.toString().padLeft(2, '0')}',
        //               );
        //             } else {
        //               return Text(
        //                 '오후 ${_startSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime!.minute.toString().padLeft(2, '0')}',
        //               );
        //             }
        //           }
        //         } else {
        //           String result = convertToAmPmFormat(startInitialValue);
        //           return Text("$result ");
        //         }
        //       }(),
        //     ),
        //     const SizedBox(
        //       width: 16.0,
        //     ),
        //     Container(
        //       // test 시작
        //       child: () {
        //         startTimeCheck = false;
        //         if (endInitialValue.toString().isEmpty) {
        //           {
        //             if (endTimeStatus == false) {
        //               return const Text(
        //                 "시간을 등록해 주세요.",
        //                 style: TextStyle(
        //                   fontSize: 14.0,
        //                   color: SUB_TEXT_COLOR,
        //                 ),
        //               );
        //             } else {
        //               if (_endSelectedTime!.period == DayPeriod.am) {
        //                 return Text(
        //                   '오전 ${_endSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_endSelectedTime!.minute.toString().padLeft(2, '0')}',
        //                 );
        //               } else {
        //                 return Text(
        //                   '오후 ${_endSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_endSelectedTime!.minute.toString().padLeft(2, '0')}',
        //                 );
        //               }
        //             }
        //           }
        //         } else if (endTimeStatus == true) {
        //           {
        //             if (_endSelectedTime!.period == DayPeriod.am) {
        //               return Text(
        //                 '오전 ${_endSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_endSelectedTime!.minute.toString().padLeft(2, '0')}',
        //               );
        //             } else {
        //               return Text(
        //                 '오후 ${_endSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_endSelectedTime!.minute.toString().padLeft(2, '0')}',
        //               );
        //             }
        //           }
        //         } else {
        //           String result = convertToAmPmFormat(endInitialValue);
        //           return Text(" $result ");
        //         }
        //       }(),
        //     )
        //   ],
        // )
      ],
    );
  }
}

// ------------ 증상 선택 --------------
class _SymptomSelect extends StatefulWidget {
  final FormFieldSetter<String> symptomSaved;
  final String symptomInitialValue;

  const _SymptomSelect(
      {required this.symptomSaved,
      required this.symptomInitialValue,
      super.key});

  @override
  State<_SymptomSelect> createState() => _SymptomSelectState();
}

class _SymptomSelectState extends State<_SymptomSelect> {
  String? selectedSymptom;
  // late String symptomInitialValue;
  late bool symptomStatus = false;
  late String symptomInitialValue;

  @override
  void initState() {
    super.initState();
    symptomStatus = false; // 초기에는 증상 선택 상태가 아님
    symptomInitialValue = widget.symptomInitialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            // input symptom image
            const Icon(Icons.sick_outlined),
            TextButton(
              onPressed: () async {
                final selectedSymptom = await showDialog<String?>(
                  context: context,
                  builder: (BuildContext context) {
                    return SymptomSelectionDialog(
                      onSymptomSelected: (symptom) {
                        // 여기여기 수정
                        // symptomInitialValue:symptomInitialValue,
                        // 선택된 증상을 처리
                        print('Selected Symptom: $symptom');
                        widget.symptomSaved(symptom); //  부모 위젯에 선택된 증상 전달
                        setState(() {
                          this.selectedSymptom = symptom;
                          symptomStatus = true; // 증상 선택 상태로 변경
                        });
                        // Navigator.pop(context, symptom); // 선택된 증상을 다이얼로그 닫기 전에 반환
                      },
                    );
                  },
                );
                if (selectedSymptom != null) {
                  // 다이얼로그에서 선택된 증상을 처리
                  // 여기에서는 선택된 증상을 사용할 수 있음
                  setState(() {
                    this.selectedSymptom = selectedSymptom; // 중요함2
                    symptomStatus = true; // 증상 선택 상태로 변경
                  });
                } else {
                  print("엘스구문");
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AlertDialog(
                  //       title: Text('알림'),
                  //       content: Text('필수 값을 입력해 주세요.'),
                  //       actions: [
                  //         CustomButton(
                  //           text: "확인",
                  //           onPressed: () {
                  //             Navigator.pop(context);
                  //
                  //           },
                  //           backgroundColor: SAVE_COLOR2,
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                }
              },
              style: TextButton.styleFrom(),
              child: RichText(
                text: const TextSpan(
                  text: '증상선택 (',
                  // style: DefaultTextStyle.of(context).style,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: BODY_TEXT_COLOR,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ')'),
                  ],
                ),
              ),
            ),
          ],
        ),
        // if (selectedSymptom != null && symptomStatus == true)
        if (symptomStatus == true)
          Text(
            "$selectedSymptom", // 선택된 증상을 표시
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
        if (selectedSymptom == null && symptomStatus == false)
          // if (symptomInitialValue.isNotEmpty && symptomStatus == false)
          Text(
            "$symptomInitialValue",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              color: SUB_TEXT_COLOR,
            ),
          ),
      ],
    );
  }
}

// ----------------------------------------------
// ------------ 활동 선택 --------------
class _ActivitySelect extends StatefulWidget {
  final FormFieldSetter<String> activitySaved;
  final String activityInitialValue;

  const _ActivitySelect(
      {required this.activitySaved,
      required this.activityInitialValue,
      super.key});

  @override
  State<_ActivitySelect> createState() => _ActivitySelectState();
}

class _ActivitySelectState extends State<_ActivitySelect> {
  String? selectedActivity;
  late bool activityStatus = false;
  late String activityInitialValue;

  void initState() {
    super.initState();
    activityStatus = false;
    activityInitialValue = widget.activityInitialValue;
    print("★ activityInitialValue = > $activityInitialValue");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            // input activity image
            const Icon(Icons.directions_run_outlined),
            TextButton(
                onPressed: () async {
                  final selectedActivity = await showDialog<String?>(
                    context: context,
                    builder: (BuildContext context) {
                      return ActivitySelectionDialog(
                        onActivitySelected: (activity) {
                          // 선택된 증상을 처리
                          print('Selected Activity: $activity');
                          widget.activitySaved(activity); //  부모 위젯에 선택된 증상 전달
                          setState(() {
                            this.selectedActivity = activity;
                            activityStatus = true; // 증상 선택 상태로 변경
                          });
                        },
                      );
                    },
                  );
                  if (selectedActivity != null) {
                    // 다이얼로그에서 선택된 증상을 처리
                    // 여기에서는 선택된 증상을 사용할 수 있음
                    setState(() {
                      this.selectedActivity = selectedActivity;
                      activityStatus = true; // 증상 선택 상태로 변경
                    });
                  }
                },
                style: TextButton.styleFrom(),
                child: RichText(
                  text: const TextSpan(
                    text: '활동선택 (',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: BODY_TEXT_COLOR,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ')'),
                    ],
                  ),
                )),
          ],
        ),
        if (activityStatus == true)
          Text(
            "$selectedActivity", // 선택된 증상을 표시
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
        if (selectedActivity == null && activityStatus == false)
          // if (symptomInitialValue.isNotEmpty && symptomStatus == false)
          Text(
            "$activityInitialValue", // 변수로 변경필요
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              color: SUB_TEXT_COLOR,
            ),
          ),
      ],
    );
  }
}

// ----------------------------------------------
// ------------ 내용 입력 팝업--------------
class _ContentPopup extends StatelessWidget {
  const _ContentPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // showDialog를 사용하여 팝업을 표시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('기타설명'),
              content: const TextField(
                maxLines: null, // 이 부분을 추가하여 여러 줄 입력 가능
                keyboardType: TextInputType.multiline, // 여러 줄 입력을 위한 키보드 타입
                decoration: InputDecoration(
                  hintText: '내용을 입력하세요.',
                ),
              ),
              actions: [
                CustomButton(
                  text: "취소",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: CANCEL_COLOR2,
                ),
                CustomButton(
                  text: "저장",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: SAVE_COLOR2,
                ),
              ],
            );
          },
        );
      },
      child: const Text(
        '기타설명(증상 기타 선택시 필수)',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: BODY_TEXT_COLOR,
        ),
      ),
    );
  }
}

// ------------ 내용 입력 --------------
// class _Content extends StatelessWidget {
//   final FormFieldSetter<String> onSaved;
//   final String initialValue;
//
//   const _Content(
//       {required this.onSaved, required this.initialValue, super.key});
//
// // Icon(Icons.mark_unread_chat_alt_outlined)
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: CustomTextField(
//         // label: "기타설명( 기타 선택시 필수 )",
//         label: "기타설명(증상 기타 선택시 필수)",
//         isTime: false,
//         onSaved: onSaved,
//         initialValue: initialValue,
//       ),
//     );
//   }
// }

// ----------------------------------------------
// ------------ 저장버튼 --------------
class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: SAVE_COLOR2,
            // fixedSize: Size(75.0, 1.0,),
            // fixedSize: Size(40.0, 20.0,),
            // primary:  PRIMARY_COLOR,
          ),
          //input white save icon
          child: const Icon(
            // Icons.data_saver_on_outlined,
            Icons.save,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ---------- Symptom 다이얼로그 ------------------------------
class SymptomSelectionDialog extends StatefulWidget {
  final ValueChanged<String?> onSymptomSelected;

  SymptomSelectionDialog({required this.onSymptomSelected});

  @override
  _SymptomSelectionDialogState createState() => _SymptomSelectionDialogState();
}

class _SymptomSelectionDialogState extends State<SymptomSelectionDialog> {
  String? selectedSymptom;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      titlePadding: const EdgeInsets.all(0.1),
      // title의 패딩 조절
      title: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        child: Container(
          color: PRIMARY_COLOR2,
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              '  증상 선택',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            buildSymptomRadio('가슴 불편함', '가슴 불편함'),
            buildSymptomRadio('팔, 목, 턱 등이 불편함', '팔, 목, 턱 등이 불편함'),
            buildSymptomRadio('심계항진(빠른 심장박동)', '심계항진(빠른 심장박동)'),
            buildSymptomRadio('호흡곤란', '호흡곤란'),
            buildSymptomRadio('현기증', '현기증'),
            buildSymptomRadio('피로', '피로'),
            buildSymptomRadio('기타', '기타'), // None
          ],
        ),
      ),
      actions: [
        CustomButton(
          text: '취소',
          onPressed: () {
            Navigator.pop(context, null);
          },
          backgroundColor: CANCEL_COLOR2,
        ),
        CustomButton(
          text: '저장',
          onPressed: () {
            // 여기수정해야
            if (selectedSymptom != null) {
              widget.onSymptomSelected(selectedSymptom);
              Navigator.pop(context, selectedSymptom);
            } else {
              // widget.onSymptomSelected(selectedSymptom);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('알림'),
                    content: const Text('증상 선택은 필수 입니다.'),
                    actions: [
                      CustomButton(
                        text: "확인",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: SAVE_COLOR2,
                      ),
                    ],
                  );
                },
              );
            }
          },
          backgroundColor: SAVE_COLOR2,
        ),
      ],
    );
  }

  Widget buildSymptomRadio(String title, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSymptom = value;
        });
      },
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: selectedSymptom,
            activeColor: PRIMARY_COLOR2,
            onChanged: (String? newValue) {
              setState(() {
                selectedSymptom = newValue;
              });
            },
          ),
          Text(title),
        ],
      ),
    );
  }
}

// --------------------------------------------------------
// ---------- Activity 다이얼로그 ------------------------------
class ActivitySelectionDialog extends StatefulWidget {
  final ValueChanged<String?> onActivitySelected;

  ActivitySelectionDialog({required this.onActivitySelected});

  @override
  _ActivitySelectionDialogState createState() =>
      _ActivitySelectionDialogState();
}

class _ActivitySelectionDialogState extends State<ActivitySelectionDialog> {
  String? selectedActivity;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      titlePadding: const EdgeInsets.all(0.1),
      // title의 패딩 조절
      title: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        child: Container(
          color: PRIMARY_COLOR2,
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              '  활동 선택',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            buildActivityRadio('업무(육체활동)', '업무(육체활동)'),
            buildActivityRadio('업무(비 육체활동)', '업무(비 육체활동)'),
            buildActivityRadio('TV 시청, 독서 등의 활동', 'TV 시청, 독서 등의 활동'),
            buildActivityRadio('걷기', '걷기'),
            buildActivityRadio('달리기', '달리기'),
            buildActivityRadio('집안일', '집안일'),
            buildActivityRadio('기타', '기타'),
          ],
        ),
      ),
      actions: [
        CustomButton(
          text: '취소',
          onPressed: () {
            Navigator.pop(context, null);
          },
          backgroundColor: CANCEL_COLOR2,
        ),
        CustomButton(
          text: '저장',
          onPressed: () {
            // 여기수정해야
            if (selectedActivity != null) {
              widget.onActivitySelected(selectedActivity);
              Navigator.pop(context, selectedActivity);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('알림'),
                    content: const Text('활동 선택은 필수 입니다.'),
                    actions: [
                      CustomButton(
                        text: "확인",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: SAVE_COLOR2,
                      ),
                    ],
                  );
                },
              );
            }
          },
          backgroundColor: SAVE_COLOR2,
        ),
      ],
    );
  }

  Widget buildActivityRadio(String title, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedActivity = value;
        });
      },
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: selectedActivity,
            activeColor: PRIMARY_COLOR2,
            onChanged: (String? newValue) {
              setState(() {
                selectedActivity = newValue;
              });
            },
          ),
          Text(title),
        ],
      ),
    );
  }
}
// --------------------------------------------------------
class BlinkingButton extends StatefulWidget {
  final String textLabel;
  const BlinkingButton({
    required this.textLabel,
    Key? key}) : super(key: key);

  @override
  _BlinkingButtonState createState() => _BlinkingButtonState();
}

class _BlinkingButtonState extends State<BlinkingButton> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    // 1초마다 isVisible 값을 토글합니다.
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        isVisible = !isVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isVisible ? Colors.redAccent.withOpacity(0.1) : Colors.transparent,
        // color: isVisible ? PRIMARY_COLOR2.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          // 새벽 여기까지 진행함, 증상지속시간 함수

          // _selectTime(context, false); // 종료시간 설정
          print("Button Clicked");
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            // '증상지속시간',
            widget.textLabel,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: BODY_TEXT_COLOR,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
