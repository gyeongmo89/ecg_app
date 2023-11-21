// 신규 등록시 시작시간, 종료시간에 대한 정합성 완료
// 수정시 종료시간은 정합성 수정필요
// 수정시 시작시간 정합성 수정필요
// 수정시 시작시간 정합성 수정부터 시작 1
import 'package:drift/drift.dart' show Value;
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
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime; // null 이 될 수 있게 "?"를 넣은것임
  int? endTime;
  String? symptom;
  String? activity;
  String? content;

  // int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
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
            print("snapshot Data : $snapshot.data");
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
              // selectedColorId = snapshot.data!.colorID;
            }

            return SafeArea(
              child: Container(
                // height: MediaQuery.of(context).size.height / 1.05 +
                //     height: MediaQuery.of(context).size.height / 1.5 +
                height: MediaQuery.of(context).size.height / 1.6 +
                    //     height: MediaQuery.of(context).size.height / 1.9 +
                    bottomInset, // 노트 입력 시트 사이즈 조정
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
                    child: Form(
                      // 아래에 있는 모든 텍스트폼 필드를 컨트롤 할 수 있다.
                      // 폼에는 key를 넣어줘야한다
                      key: formKey, // Form의 컨트롤러 역할
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.edit_calendar_outlined),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("노트작성",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: BODY_TEXT_COLOR,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 4.0,
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
                            // ----------------
                          ),
                          // ---------------------------------
                          const SizedBox(
                            height: 4.0,
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          // ----------- 증상선택 -----------
                          _SymptomSelect(
                            symptomSaved: (String? val) {
                              symptom = val;
                            },
                            symptomInitialValue:
                                symptom?.toString() ?? '증상을 선택해 주세요.',
                          ),
                          // ---------------------------------
                          const SizedBox(
                            height: 4.0,
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          // ----------- 활동선택 -----------
                          _ActivitySelect(
                              activitySaved: (String? val) {
                                activity = val;
                              },
                              activityInitialValue:
                                  activity?.toString() ?? '활동을 선택해 주세요.'),
                          // ---------------------------------
                          const SizedBox(
                            height: 4.0,
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          // ----------- 기타설명 -----------
                          _Content(
                            onSaved: (String? val) {
                              content = val;
                            },
                            initialValue: content ?? '',
                          ),
                          // ---------------------------------
                          const SizedBox(
                            height: 8.0,
                          ),

                          const SizedBox(
                            height: 4.0,
                          ),
                          _SaveButton(
                            onPressed: onSavePressed,
                          ),
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

// -------------- 저장버튼 눌렀을때 로직 -------------------
  void onSavePressed() async {
    // formKey는 생성을 했는데, Form 위젯과 결합을 안했을때
    // if (formKey.currentState == null) {
    //   return;
    // }

    if (formKey.currentState!.validate()) {
      print("에러가 없습니다.");
      formKey.currentState!.save();
      print("----------------");
      print("startTime : $startTime");
      print("endTime : $endTime");
      print("symptom : $symptom");
      print("activity : $activity");
      print("Content : $content");
      print("----------------");

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
  TimeOfDay _startSelectedTime = TimeOfDay.now(); // 시작시간 선택을 위한 변수 추가
  TimeOfDay _endSelectedTime = TimeOfDay.now();
  late String startInitialValue; // 필드로 추가
  late String endInitialValue; // 필드로 추가
  late bool startTimeStatus;
  late bool endTimeStatus;

  @override
  void initState() {
    super.initState();

    startInitialValue = widget.startInitialValue;
    endInitialValue = widget.endInitialValue;
    startTimeStatus = false;
    endTimeStatus = false;
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

  // 버튼 수정시작
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startSelectedTime : _endSelectedTime,
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
// 종료시간이 시작시간보다 이전인 경우 알림을 표시하고 함수를 종료
        if (!isStartTime) {
          final DateTime startDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            _startSelectedTime.hour,
            _startSelectedTime.minute,
          );
          final DateTime endDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            picked.hour,
            picked.minute,
          );

          if (endDateTime.isBefore(startDateTime)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('알림'),
                  content: const Text('종료시간은 시작시간 이후여야 합니다.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('확인'),
                    ),
                  ],
                );
              },
            );
            return;
          }
        } else {
// 추가: 시작시간이 종료시간 이후일 경우 알림
          final DateTime startDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            picked.hour,
            picked.minute,
          );
          final DateTime endDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            _endSelectedTime.hour,
            _endSelectedTime.minute,
          );

          if (endTimeStatus && startDateTime.isAfter(endDateTime)) {
            print("startDateTime ----> $startDateTime");
            print("startDateTime Type ----> ${startDateTime.runtimeType}");
            print("endDateTime ----> $endDateTime");
            print("endDateTime Type ----> ${endDateTime.runtimeType}");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('알림'),
                  content: const Text('시작시간은 종료시간 이전이어야 합니다.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('확인'),
                    ),
                  ],
                );
              },
            );
            return;
          }
        }


      setState(() {
        // 중요함
        if (isStartTime) {
          _startSelectedTime = picked;
          startTimeStatus = true;
          widget.onStartSaved(
              _startSelectedTime.hour * 60 + _startSelectedTime.minute);
        } else {
          _endSelectedTime = picked;
          endTimeStatus = true;
          widget
              .onEndSaved(_endSelectedTime.hour * 60 + _endSelectedTime.minute);
        }
      });
    }else {
        setState(() {
          if (!isStartTime) {
            _endSelectedTime = TimeOfDay(hour: 0, minute: 0);
            endTimeStatus = false;
            widget.onEndSaved(null); // 종료시간을 null로 설정
          }
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    FormFieldSetter<int?> onStartSaved = widget.onStartSaved; // 내가 임의 추가

    // TimeOfDay convertedTime = convertToTimeOfDay(startInitialValue);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _selectTime(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR2,
                  // primary:  PRIMARY_COLOR,
                ),
                child: const Text("시작시간 ( 필수 )"),
              ),
            ),
            SizedBox(
              // width: 16.0,
              width: deviceWidth / 5 / 4, // 시작시간 종료시간 버튼 간격
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _selectTime(context, false); // 종료시간 설정
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR2,
                  // primary:  PRIMARY_COLOR,
                ),
                child: const Text("종료시간"),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 중요함
          children: [
            Container(
              // test 시작
              child: () {
                if (startInitialValue.toString().isEmpty) {
                  {
                    if (startTimeStatus == false) {
                      return const Text(
                        "시간을 등록해 주세요.",
                      );
                    } else {
                      if (_startSelectedTime.period == DayPeriod.am) {
                        return Text(
                          '오전 ${_startSelectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime.minute.toString().padLeft(2, '0')}',
                        );
                      } else {
                        return Text(
                          '오후 ${_startSelectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime.minute.toString().padLeft(2, '0')}',
                        );
                      }
                    }
                  }
                } else if (startTimeStatus == true) {
                  {
                    if (_startSelectedTime.period == DayPeriod.am) {
                      return Text(
                        '오전 ${_startSelectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime.minute.toString().padLeft(2, '0')}',
                      );
                    } else {
                      return Text(
                        '오후 ${_startSelectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_startSelectedTime.minute.toString().padLeft(2, '0')}',
                      );
                    }
                  }
                } else {
                  String result = convertToAmPmFormat(startInitialValue);
                  return Text("$result ");
                }
              }(),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Container(
              // test 시작
              child: () {
                if (endInitialValue.toString().isEmpty) {
                  {
                    if (endTimeStatus == false) {
                      return const Text(
                        "시간을 등록해 주세요.",
                      );
                    } else {
                      if (_endSelectedTime.period == DayPeriod.am) {
                        return Text(
                          '오전 ${_endSelectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_endSelectedTime.minute.toString().padLeft(2, '0')}',
                        );
                      } else {
                        return Text(
                          '오후 ${_endSelectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_endSelectedTime.minute.toString().padLeft(2, '0')}',
                        );
                      }
                    }
                  }
                } else if (endTimeStatus == true) {
                  {
                    if (_endSelectedTime.period == DayPeriod.am) {
                      return Text(
                        '오전 ${_endSelectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_endSelectedTime.minute.toString().padLeft(2, '0')}',
                      );
                    } else {
                      return Text(
                        '오후 ${_endSelectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_endSelectedTime.minute.toString().padLeft(2, '0')}',
                      );
                    }
                  }
                } else {
                  String result = convertToAmPmFormat(endInitialValue);
                  return Text(" $result ");
                }
              }(),
            )
          ],
        )
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
    print("♥ symptomInitialValue = > $symptomInitialValue");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: ElevatedButton(
            onPressed: () async {
              final selectedSymptom = await showDialog<String?>(
                context: context,
                builder: (BuildContext context) {
                  return SymptomSelectionDialog(
                    onSymptomSelected: (symptom) {
                      // 선택된 증상을 처리
                      print('Selected Symptom: $symptom');
                      widget.symptomSaved(symptom); //  부모 위젯에 선택된 증상 전달
                      setState(() {
                        this.selectedSymptom = symptom;
                        symptomStatus = true; // 증상 선택 상태로 변경
                      });
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
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR2),
            child: const Text("증상선택 ( 필수 )"),
          ),
        ),
        // if (selectedSymptom != null && symptomStatus == true)
        if (symptomStatus == true)
          Text(
            "$selectedSymptom", // 선택된 증상을 표시
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
        if (selectedSymptom == null && symptomStatus == false)
          // if (symptomInitialValue.isNotEmpty && symptomStatus == false)
          Text(
            // "$symptomInitialValue", // 변수로 변경필요
            "$symptomInitialValue", // 변수로 변경필요
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: BODY_TEXT_COLOR,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: ElevatedButton(
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
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR2),
            child: const Text("활동선택 ( 필수 )"),
          ),
        ),
        if (activityStatus == true)
          Text(
            "$selectedActivity", // 선택된 증상을 표시
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
        if (selectedActivity == null && activityStatus == false)
          // if (symptomInitialValue.isNotEmpty && symptomStatus == false)
          Text(
            // "$symptomInitialValue", // 변수로 변경필요
            "$activityInitialValue", // 변수로 변경필요
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
      ],
    );
  }
}
// ----------------------------------------------

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
        label: "기타설명( 기타 선택시 필수 )",
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
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: SAVE_COLOR,
              // primary:  PRIMARY_COLOR,
            ),
            child: const Text("저장"),
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
            buildSymptomRadio('두근거림', '두근거림'),
            buildSymptomRadio('불안감', '불안감'),
            buildSymptomRadio('어지러움', '어지러움'),
            buildSymptomRadio('흉통 또는 불편감', '흉통 또는 불편감'),
            buildSymptomRadio('체감온도 변화', '체감온도 변화'),
            buildSymptomRadio('호흡곤란', '호흡곤란'),
            buildSymptomRadio('기타', '기타'),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CANCEL_COLOR,
          ),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSymptomSelected(selectedSymptom);
            Navigator.pop(context, selectedSymptom);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SAVE_COLOR,
          ),
          child: const Text('저장'),
        ),
      ],
    );
  }

  Widget buildSymptomRadio(String title, String value) {
    return Row(
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
            buildActivityRadio('업무(비 육체적)', '업무(비 육체적)'),
            buildActivityRadio('걷기', '걷기'),
            buildActivityRadio('달리기', '달리기'),
            buildActivityRadio('TV, 독서 등 평온', 'TV, 독서 등 평온'),
            buildActivityRadio('집안일', '집안일'),
            buildActivityRadio('과격한 운동', '과격한 운동'),
            buildActivityRadio('기타', '기타'),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CANCEL_COLOR,
          ),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onActivitySelected(selectedActivity);
            Navigator.pop(context, selectedActivity);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SAVE_COLOR,
          ),
          child: const Text('저장'),
        ),
      ],
    );
  }

  Widget buildActivityRadio(String title, String value) {
    return Row(
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
    );
  }
}
// --------------------------------------------------------
