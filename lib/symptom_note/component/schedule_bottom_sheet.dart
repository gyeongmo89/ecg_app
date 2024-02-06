// 2024-01-12 20:08
// 노트작성하는부분 수정 시작 1
// 2024-01-15 17:15 노트쪽 시작 1
// 2024-01-15 17:56 시작시간 종료시간 정합성 수정시작 1
// 2024-01-16 17:56 증상지속시간 연계해놔서 시간은 뜨지만, 나중에 증상시간 팝업으료 교체해야함
// 2024-01-16 17:57 기타설명 입력된것이 저장되도록 수정 시작 1
// 2024-01-19 16:15 증상지속시간 팝업 수정시작 1
// 2024-01-20 14:20 기타설명 수정시작 1
// 2024-01-20 16:08 기타설명 입력폼까지 수정 완료
// 2024-01-20 16:09 증상지속시간이 시작시간에다가 더해지도록 수정 시작1 수정어려워서 미룸, Content 시작
// 2024-01-20 17:06 Content 시작1
// 2024-01-20 19:04 Content 완료
// 2024-01-21 13:55 증상지속시간 수정1
// 2024-01-21 14:37 증상지속시간 더블타입으로 변경 시작1
// 2024-01-21 19:00 증상지속시간 정합성이 되지 않아, 저장로직 정합성수정시작
// 2024-01-21 19:58 저장로직 수정완료
// 2024-01-21 20:00 증상지속시간 정합성 수정 다시시작1

import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:ecg_app/common/component/custom_button.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:ecg_app/symptom_note/component/custom_text_field.dart';
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
  // late _Time _timeWidget;

  @override
  void initState() {
    super.initState();
    // _timeWidget = _Time(
    //   onStartSaved: (val) {
    //     // handle start time
    //   },
    //   onEndSaved: (val) {
    //     // handle end time
    //   },
    //   startInitialValue: 'initial_start_time', // replace with actual initial value
    //   endInitialValue: 'initial_end_time', // replace with actual initial value
    // );
  }



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
                // height: MediaQuery.of(context).size.height / 1.95 +
                // height: MediaQuery.of(context).size.height / 1.5 +
                    height: MediaQuery.of(context).size.height / 1.9 +
                    bottomInset, // 노트 입력 시트 사이즈 조정
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
                        //메인 컬럼
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

                          // _SymptomSelectDuration(
                          //   symptomSaved: (String? val) {
                          //     symptom = val;
                          //
                          //   },
                          //   symptomInitialValue: symptom?.toString() ?? '',
                          // ),
                          // ----------- 증상지속시간 선택 -----------

                          _SymptomSelectDuration(
                            // startSelectedTime: _TimeState()._startSelectedTime,
                            // startSelectedTime: startTime,

                            // symptomDurationSaved: (int? val) {
                            //   endTime = startTime! + (val ?? 0);
                            // },

                            symptomDurationSaved: (int? val) {
                              if (startTime != null) {
                                endTime = startTime! + (val ?? 0);
                              } else {
                                // 시작 시간이 없는 경우에 대한 처리를 여기에 추가할 수 있습니다.
                                startTime = null;
                                print('시작 시간이 설정되지 않았습니다.');
                              }
                            },
                            startSelectedTime: _TimeState()._startSelectedTime,

                            symptomDurationInitialValue:
                                (endTime != null && startTime != null)
                                    ? '${endTime! - startTime!} 분'
                                    : '증상지속시간을 선택해주세요.',
                          ),
                          // ---------------------------------
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
                          _ContentPopup(
                            onSaved: (String? val) {
                              content = val;
                            },
                            // initialValue: content ?? '여기가 콘텐트다',
                            initialValue: content ?? '',
                          ),

                          // ----------- 기타설명 -----------
                          // _Content(
                          //   onSaved: (String? val) {
                          //     content = val;
                          //   },
                          //   initialValue: content ?? '',
                          // ),
                          //button
                          // const Row(
                          //   children: [
                          //     Icon(
                          //       Icons.notes,
                          //       color: Colors.black,
                          //       size: 22.0,
                          //     ),
                          //     // _ContentPopup(
                          //     //   initialValue: content ?? '',
                          //     //     onSaved: (String? val) {
                          //     //       content = val;
                          //     //     },
                          //     //     // onPressed: onSavePressed,
                          //     //     ),
                          //     SizedBox(
                          //       // height: MediaQuery.of(context).size.height / 60,
                          //       width: 10.0,
                          //     ),
                          //     const Text(
                          //       '기타설명(증상 기타 선택시 필수)',
                          //       style: TextStyle(
                          //         fontSize: 16.0,
                          //         fontWeight: FontWeight.w600,
                          //         color: BODY_TEXT_COLOR,
                          //       ),
                          //     )
                          //   ],
                          // ),

                          // ---------------------------------
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height / 60,
                          // ),
                          // Text("data"),
                          // // input _ContentPopup content value
                          // _ContentPopup(
                          //   onSaved: (String? val) {
                          //     content = val;
                          //   },
                          //   initialValue: content ?? '',
                          // ),

                          // _Content(
                          //   onSaved: (String? val) {
                          //     content = val;
                          //   },
                          //   initialValue: content ?? 'sdf',
                          // ),
                          // Text("data"),
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
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      print("에러가 없습니다.");
      print("startTime : $startTime");
      print("endTime : $endTime");
      print("symptom : $symptom");
      print("activity : $activity");
      print("Content : $content");
      setState(() {
        startTime = startTime;
        endTime = endTime;
        symptom = symptom;
        activity = activity;
        content = content;
      });


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
      if (content == null && symptom == '기타') {
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
                    Navigator.pop(context);
                  },
                  backgroundColor: SAVE_COLOR2,
                ),
              ],
            );
          }
      );

      if (widget.scheduleId == null) {
        print("데이터 생성");
        await GetIt.I<LocalDatabase>().createSchedule(
          // 데이터 생성
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime ?? 0),
            endTime: Value(endTime ?? startTime!),
            symptom: Value(symptom!),
            activity: Value(activity!),
            content: Value(content ?? ""),
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
            content: Value(content ?? ""),
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

  _Time(
      {required this.onStartSaved,
      required this.onEndSaved,
      required this.startInitialValue,
      required this.endInitialValue,
      this.startTimeStatus = false,
      this.endTimeStatus = false,
      super.key});

  @override
  State<_Time> createState() => _TimeState();
}

class _TimeState extends State<_Time> {
  // ------------------- TimePicker -------------------
  TimeOfDay? _startSelectedTime; // 시작시간 선택을 위한 변수 추가
  TimeOfDay? _endSelectedTime;
  late String startInitialValue; // 필드로 추가
  late String endInitialValue; // 필드로 추가
  late bool startTimeStatus;
  late bool endTimeStatus;
  late bool startTimeCheck;
  late bool endTimeCheck;

  // _startSelectedTime을 다른 클래스에서도 사용할 수 있도록 getter 추가
  TimeOfDay? get startSelectedTime => _startSelectedTime;

  @override
  void initState() {
    super.initState();
    startInitialValue = widget.startInitialValue;
    endInitialValue = widget.endInitialValue;
    startTimeStatus = false;
    endTimeStatus = false;
    startTimeCheck = false; // 시작시간 정합성 체크용
    endTimeCheck = false; // 종료시간 정합성 체크용

    // _startSelectedTime = null; // 1월 21일 증상지속시간 때문에 임시 주석
    _endSelectedTime = null;
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
        } else {
          _endSelectedTime =
              picked; // 변경: 이 부분에서 현재 시간으로 초기화하지 않고 선택한 시간으로 업데이트
          endTimeStatus = true;
          widget.onEndSaved(
              _endSelectedTime!.hour * 60 + _endSelectedTime!.minute);
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
          print("선택한시작시간--------- : $_startSelectedTime");
          setState(() {

            _startSelectedTime = _startSelectedTime;
          });
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
            const Icon(Icons.access_time, color: Colors.black),
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
            Container(
              // test 시작
              child: () {
                if (startInitialValue.toString().isEmpty) {
                  {
                    if (startTimeStatus == false) {

                      return const Text(
                        "시작시간을 선택해 주세요.",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: SUB_TEXT_COLOR,
                        ),
                      );
                    } else {
                      startTimeStatus = true;
                      if (_startSelectedTime!.period == DayPeriod.am) {
                        return Text(
                          '오전 ${_startSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime!.minute.toString().padLeft(2, '0')}',
                        );
                      } else {
                        return Text(
                          '오후 ${_startSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime!.minute.toString().padLeft(2, '0')}',
                        );
                      }
                    }
                  }
                } else if (startTimeStatus == true) {
                  {
                    if (_startSelectedTime!.period == DayPeriod.am) {
                      return Text(
                        '오전 ${_startSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime!.minute.toString().padLeft(2, '0')}',
                      );
                    } else {
                      return Text(
                        '오후 ${_startSelectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime!.minute.toString().padLeft(2, '0')}',
                      );
                    }
                  }
                } else {
                  String result = convertToAmPmFormat(startInitialValue);
                  return Text("$result ", style: TextStyle(
                    fontSize: 14.0,
                    color: SUB_TEXT_COLOR,
                  ),);
                }
              }(),
            ),
          ],
        ),
      ],
    );
  }
}
//
// ------------ 증상 지속시간선택 --------------
class _SymptomSelectDuration extends StatefulWidget {
  final FormFieldSetter<int?> symptomDurationSaved;
  final String? symptomDurationInitialValue;
  final TimeOfDay? startSelectedTime;
  // final bool startTimeStatus;


  const _SymptomSelectDuration({
    required this.symptomDurationSaved,
    required this.symptomDurationInitialValue,
    required this.startSelectedTime,
    // required this.startTimeStatus,
    Key? key,
  }) : super(key: key);

  @override
  State<_SymptomSelectDuration> createState() => _SymptomDurationSelectState();
  // State<_SymptomSelectDuration> createState() => _SymptomDurationSelectState(startTimeStatus: startTimeStatus);
}

class _SymptomDurationSelectState extends State<_SymptomSelectDuration> {
  int? selectedSymptomDuration;
  late bool symptomDurationStatus = false;
  late String? symptomDurationInitialValue;
  late TimeOfDay? startSelectedTime;


  @override
  void didUpdateWidget(covariant _SymptomSelectDuration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startSelectedTime != oldWidget.startSelectedTime) {
      setState(() {
        startSelectedTime = widget.startSelectedTime;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    symptomDurationStatus = false;
    symptomDurationInitialValue = widget.symptomDurationInitialValue;
    startSelectedTime = widget.startSelectedTime;
    print("이닛 startSelectedTime---> $startSelectedTime");

    // print("widget.startSelectedTime 진짜---> ${widget.startSelectedTime}");
    // _startSelectedTime = widget.startSelectedTime != null
    // _startSelectedTime = widget.startSelectedTime;



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
            const Icon(Icons.alarm_add_rounded, color: Colors.black),
            TextButton(
              onPressed: () async {
                didUpdateWidget(widget);
                  print("startSelectedTime--->$startSelectedTime");
                // print("_startSelectedTime-->제발 -> $_startSelectedTime");
                // if (_startSelectedTime == null) {
                // print("->startTimeStatus---> $startTimeStatus");
                // if (_startSelectedTime == null) {
                //   // 시작시간이 선택되지 않은 경우
                //   // print("->_startSelectedTime---> $_startSelectedTime");
                //   showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: Text('알림'),
                //         content: Text('시작시간을 먼저 선택해 주세요.'),
                //         actions: [
                //           CustomButton(
                //             text: "확인",
                //             onPressed: () {
                //               Navigator.pop(context);
                //             },
                //             backgroundColor: SAVE_COLOR2,
                //           ),
                //         ],
                //       );
                //     },
                //   );
                // } else {
                  // 시작시간이 선택된 경우
                  final selectedSymptomDuration = await showDialog<int?>(
                    context: context,
                    builder: (BuildContext context) {
                      return SymptomDurationDialog(
                        onSymptomDurationSelected: (symptomDuration) {
                          widget.symptomDurationSaved(symptomDuration);
                          setState(() {
                            this.selectedSymptomDuration = symptomDuration;
                            symptomDurationStatus = true;
                          });
                        },
                      );
                    },
                  );
                  if (selectedSymptomDuration != null) {
                    setState(() {
                      this.selectedSymptomDuration = selectedSymptomDuration;
                      symptomDurationStatus = true;
                    });
                  } else {
                    print("엘스구문");
                  }
                },
              // },
              style: TextButton.styleFrom(),
              child: RichText(
                text: const TextSpan(
                  text: '증상지속시간',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: BODY_TEXT_COLOR,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (symptomDurationStatus == true)
          Text(
            "$selectedSymptomDuration" + "분", // 선택된 증상을 표시
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
        if (selectedSymptomDuration == null && symptomDurationStatus == false)
          Text(
            "${symptomDurationInitialValue ?? 0}",
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
            const Icon(Icons.sick_outlined, color: Colors.black),
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
            const Icon(Icons.directions_run_outlined, color: Colors.black),
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
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _ContentPopup(
      {required this.onSaved, required this.initialValue, super.key});

  @override
  Widget build(BuildContext context) {
    String? content = ''; // 추가: 팝업 내용을 저장할 변수
    // if (initialValue.isNotEmpty) {
    //   // 초기값이 있을 때만 사용
    //   content = initialValue;
    // }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.edit, color: Colors.black),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // String initialValue = content ?? '여기콘';

                    return AlertDialog(
                      title: const Text('기타설명'),
                      content: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        // controller: TextEditingController(text: initialValue),

                        controller: TextEditingController(text: initialValue),

                        onChanged: (value) {
                          // 추가: 내용이 변경될 때마다 변수에 저장
                          content = value;
                        },
                        decoration: InputDecoration(
                          hintText:
                              initialValue.isNotEmpty ? null : '기타 내용을 작성 해주세요.',
                        ),
                        // decoration: InputDecoration(
                        //   hintText: '내용을 입력하세요.',
                        // ),
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
                            // 추가: 저장 버튼이 눌리면 내용을 전달
                            Navigator.pop(context, content);
                          },
                          backgroundColor: SAVE_COLOR2,
                        ),
                      ],
                    );
                  },
                ).then((result) {
                  // 추가: 팝업이 닫힌 후의 처리
                  if (result != null) {
                    // 저장 버튼이 눌렸을 때만 처리
                    print("저장된 내용: $result");
                    onSaved(result);
                  }
                });
              },
              style: TextButton.styleFrom(),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: '기타작성',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: BODY_TEXT_COLOR,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          initialValue.isEmpty
              ? "기타내용을 작성 해주세요."
              : (initialValue.length > 20)
              ? '${initialValue.substring(0, 15)} ...' // 10자 이상이면 일부만 출력
              : initialValue,
          style: TextStyle(
            fontSize: 14.0,
            color: initialValue.isEmpty ? SUB_TEXT_COLOR : BODY_TEXT_COLOR,
          ),
        ),

      ],
    );
  }
}

// ------------ 내용 입력 --------------
class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Content(
      {required this.onSaved, required this.initialValue, super.key});

// Icon(Icons.mark_unread_chat_alt_outlined)
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        // label: "기타설명( 기타 선택시 필수 )",
        label: "기타설명(증상 기타 선택시 필수)",
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}

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

// ---------- 증상지속시간 다이얼로그 ---------------------------
class SymptomDurationDialog extends StatefulWidget {
  final ValueChanged<int?> onSymptomDurationSelected;

  SymptomDurationDialog({required this.onSymptomDurationSelected});

  @override
  State<SymptomDurationDialog> createState() => _SymptomDurationDialogState();
}

class _SymptomDurationDialogState extends State<SymptomDurationDialog> {
  int? selectedSymptomDuration;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: Text(
        '증상 종료시간',
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // buildSymptomDurationRadio('10초', 0.16),
            // buildSymptomDurationRadio('30초', 0.5),
            buildSymptomDurationRadio('1분 이내 증상 발생', 1),
            buildSymptomDurationRadio('5분 이내 증상 발생', 5),
            buildSymptomDurationRadio('30분 이내 증상 발생', 30),
            buildSymptomDurationRadio('1시간 이내 증상발생', 60),
            buildSymptomDurationRadio('직접입력', 0),
            // buildSymptomDurationRadio('기타', -1), // None
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
            if (selectedSymptomDuration != null &&
                selectedSymptomDuration != -1) {
              widget.onSymptomDurationSelected(selectedSymptomDuration);
              Navigator.pop(context, selectedSymptomDuration);
            } else {
              print("else 구문");
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('알림'),
                    content: const Text('선택한 증상지속시간이 없습니다.'),
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

  Widget buildSymptomDurationRadio(String title, int value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSymptomDuration = value;
        });
      },
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: selectedSymptomDuration,
            // activeColor: PRIMARY_COLOR2,
            onChanged: (int? newValue) {
              setState(() {
                selectedSymptomDuration = newValue;
              });
            },
          ),
          Text(title),
        ],
      ),
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

      title: Text(
        '증상선택',
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
            // activeColor: PRIMARY_COLOR2,
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

      title: Text(
        '활동 선택',
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
  final Function(BuildContext context, bool parameter) onSelectTime;

  const BlinkingButton(
      {required this.onSelectTime, required this.textLabel, Key? key})
      : super(key: key);

  @override
  _BlinkingButtonState createState() => _BlinkingButtonState();
}

class _BlinkingButtonState extends State<BlinkingButton> {
  bool isVisible = true;


  @override
  void initState() {
    super.initState();

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
        color:
            isVisible ? Colors.redAccent.withOpacity(0.1) : Colors.transparent,
        // color: isVisible ? PRIMARY_COLOR2.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          // 새벽 여기까지 진행함, 증상지속시간 함수

          // widget.onSelectTime(context, false); // 콜백 함수 호출
          widget.onSelectTime(context, false); // 콜백 함수 호출

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
