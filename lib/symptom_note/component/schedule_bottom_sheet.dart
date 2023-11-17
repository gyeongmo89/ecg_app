// 수정시작 2023-11-17 11:06 / 시간타입 수정시작 1

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
      {required this.selectedDate,
        required this.scheduleId,
        super.key});

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
              : GetIt.I<LocalDatabase>().getScheduleById(widget.scheduleId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("증상노트를 불러올 수 없습니다."),
              );
            }

            // FutureBuilder 처음 실행됐고, 로딩중일때
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return Center(
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
                          SizedBox(
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
                            startInitialValue: startTime,
                            // null 값이면 엠티스티링을 넣겟다.
                            endInitialValue: endTime,
                            // startInitialValue: startTime?.toString() ?? '',
                            // // null 값이면 엠티스티링을 넣겟다.
                            // endInitialValue: endTime?.toString() ?? '',
                            // ----------------

                            // onStartSaved: (String? val) {
                            //   startTime = int.parse(val!);
                            // },
                            // onEndSaved: (String? val) {
                            //   endTime = int.parse(val!);
                            // },
                            // startInitialValue: startTime?.toString() ?? '',
                            // // null 값이면 엠티스티링을 넣겟다.
                            // endInitialValue: endTime?.toString() ?? '',
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
                            symptomSaved: (String? val){
                              symptom = val;
                            },
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
                            activitySaved: (String? val){
                              activity = val;
                            },
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
                          // ----------- COlor -----------
                          // FutureBuilder<List<CategoryColor>>(
                          //   future:
                          //       GetIt.I<LocalDatabase>().getCategoryColors(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.hasData &&
                          //         selectedColorId == null &&
                          //         snapshot.data!.isNotEmpty) {
                          //       selectedColorId = snapshot.data![0].id;
                          //     }
                          //
                          //     // print(snapshot.data);
                          //     return _ColorPicker(
                          //       colors: snapshot.hasData ? snapshot.data! : [],
                          //       selectedColorId: selectedColorId,
                          //       colorIdSetter: (int id) {
                          //         setState(() {
                          //           selectedColorId = id;
                          //         });
                          //       },
                          //     );
                          //   },
                          // ),
                          // ---------------------------------
                          SizedBox(
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
    if (formKey.currentState == null) {
      return;
    }

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
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            symptom: Value(symptom!),
            activity: Value(activity!),
            content: Value(content!),
            // colorID: Value(selectedColorId!),
          ),
        );
      } else {
        print("데이터 업데이트");
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            symptom: Value(symptom!),
            activity: Value(activity!),
            content: Value(content!),
            // colorID: Value(selectedColorId!),
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

// ----------------------------------------------
// ------------ 시작/종료시간 입력 --------------
class _Time extends StatefulWidget {
  // final FormFieldSetter<String> onStartSaved;
  // final FormFieldSetter<String> onEndSaved;
  final FormFieldSetter<int?> onStartSaved;
  final FormFieldSetter<int?> onEndSaved;
  final int? startInitialValue;
  final int? endInitialValue;
  // final String startInitialValue;
  // final String endInitialValue;

  _Time(
      {required this.onStartSaved,
      required this.onEndSaved,
      required this.startInitialValue,
      required this.endInitialValue,
      super.key});

  @override
  State<_Time> createState() => _TimeState();
}

class _TimeState extends State<_Time> {
  // ------------------- TimePicker -------------------
  TimeOfDay _startSelectedTime = TimeOfDay.now(); // 시작시간 선택을 위한 변수 추가
  TimeOfDay _endSelectedTime = TimeOfDay.now();


  // 버튼 수정시작
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startSelectedTime : _endSelectedTime,
      builder: (BuildContext context, Widget? child) {

        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: PRIMARY_COLOR2,
            colorScheme: ColorScheme.light(primary: PRIMARY_COLOR2),
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
                title: Text('알림'),
                content: Text('종료시간은 시작시간 이후여야 합니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('확인'),
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

        if (startDateTime.isAfter(endDateTime)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('알림'),
                content: Text('시작시간은 종료시간 이전이어야 합니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
          return;
        }
      }
      setState(() {
        if (isStartTime) {
          _startSelectedTime = picked;
          widget.onStartSaved(_startSelectedTime.hour * 60 + _startSelectedTime.minute);

          // widget.onStartSaved("${_startSelectedTime.hourOfPeriod.toString()}:${_startSelectedTime.minute.toString().padLeft(2, '0')}");

        } else {
          _endSelectedTime = picked;
          widget.onEndSaved(_endSelectedTime.hour * 60 + _endSelectedTime.minute);
        }
      });
    }
  }


  // ----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
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

                child: Text("시작시간"),
              ),
            ),
            // Expanded(
            //     child: CustomTextField(
            //   label: "시작시간",
            //   isTime: true,
            //   onSaved: onStartSaved,
            //   initialValue: startInitialValue,
            // )),
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
                child: Text("종료시간"),
              ),
            )
            // Expanded(
            //     child: CustomTextField(
            //   label: "종료시간",
            //   isTime: true,
            //   onSaved: onEndSaved,
            //   initialValue: endInitialValue,
            // )),
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Text(
                "${_startSelectedTime.period == DayPeriod.am ? '오전' : '오후'} ${_startSelectedTime.hourOfPeriod.toString()}:${_startSelectedTime.minute.toString().padLeft(2, '0')}",
                // "${_startSelectedTime.hourOfPeriod.toString()}:${_startSelectedTime.minute.toString().padLeft(2, '0')}",
                // "${_startSelectedTime.hourOfPeriod}:${_startSelectedTime.minute}",
                style: TextStyle(
                  fontSize: 16.0,
                  color: BODY_TEXT_COLOR,
                ),
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Container(
              child: Text(
                "${_endSelectedTime.period == DayPeriod.am ? '오전' : '오후'} ${_endSelectedTime.hourOfPeriod.toString()}:${_endSelectedTime.minute.toString().padLeft(2, '0')}",
                // "${_endSelectedTime.hourOfPeriod.toString()}:${_endSelectedTime.minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 16.0,
                  color: BODY_TEXT_COLOR,
                ),
              ),
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

  const _SymptomSelect({
    required this.symptomSaved,
    super.key});

  @override
  State<_SymptomSelect> createState() => _SymptomSelectState();
}

class _SymptomSelectState extends State<_SymptomSelect> {
  String? selectedSymptom;

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
                      });
                    },
                  );
                },
              );
              if (selectedSymptom != null) {
                // 다이얼로그에서 선택된 증상을 처리
                // 여기에서는 선택된 증상을 사용할 수 있음
                setState(() {
                  this.selectedSymptom = selectedSymptom;
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR2),
            child: Text("증상선택"),
          ),
        ),
        if (selectedSymptom != null)
          Text(
            "$selectedSymptom", // 변수로 변경필요
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
        if (selectedSymptom == null)
          Text(
            "증상을 선택해주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.red, // 원하는 색상으로 변경 가능
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

  const _ActivitySelect({
    required this.activitySaved,
    super.key});

  @override
  State<_ActivitySelect> createState() => _ActivitySelectState();
}

class _ActivitySelectState extends State<_ActivitySelect> {
  String? selectedActivity;

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
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR2),
            child: Text("활동선택"),
          ),
        ),
        if (selectedActivity != null)
          Text(
            "$selectedActivity", // 변수로 변경필요
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: BODY_TEXT_COLOR,
            ),
          ),
        if (selectedActivity == null)
          Text(
            "활동을 선택해주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.red, // 원하는 색상으로 변경 가능
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
        label: "기타설명",
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}
// -------------------------------------
// ------------ Color 입력 --------------
// typedef ColorIdSetter = void Function(int id);
//
// class _ColorPicker extends StatelessWidget {
//   final List<CategoryColor> colors;
//   final int? selectedColorId;
//   final ColorIdSetter colorIdSetter;
//
//   const _ColorPicker({
//     required this.colors,
//     required this.selectedColorId,
//     required this.colorIdSetter,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // return Row(   // Row 대신 Wrap으로 변경하면 자동으로 아랫줄로 내려감
//     return Wrap(
//       // Row 대신 Wrap으로 변경하면 자동으로 아랫줄로 내려감
//       spacing: 8.0, // 좌우간격
//       runSpacing: 10.0, // 위아래 간격
//       children: colors
//           .map(
//             (e) => GestureDetector(
//               // 색깔을 누를때마다
//               onTap: () {
//                 colorIdSetter(e.id);
//               },
//               child: renderColor(
//                 e,
//                 selectedColorId == e.id,
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }
//
//   Widget renderColor(CategoryColor color, bool isSelected) {
//     // 실제로 선택이 되어있으면 bool값이 true가 되게
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Color(int.parse(
//           "FF${color.hexCode}",
//           radix: 16,
//         )),
//         border: isSelected
//             ? Border.all(
//                 color: Colors.black,
//                 width: 4.0,
//               )
//             : null,
//       ),
//       width: 32.0,
//       height: 32.0,
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
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: SAVE_COLOR,
              // primary:  PRIMARY_COLOR,
            ),
            child: Text("저장"),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      titlePadding: EdgeInsets.all(0.1), // title의 패딩 조절
      title: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        child: Container(
          color: PRIMARY_COLOR2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
            buildSymptomRadio('기타', '기타설명에 작성해 주세요.'),
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
          child: Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSymptomSelected(selectedSymptom);
            Navigator.pop(context, selectedSymptom);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SAVE_COLOR,
          ),
          child: Text('저장'),
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
  _ActivitySelectionDialogState createState() => _ActivitySelectionDialogState();
}

class _ActivitySelectionDialogState extends State<ActivitySelectionDialog> {
  String? selectedActivity;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      titlePadding: EdgeInsets.all(0.1), // title의 패딩 조절
      title: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        child: Container(
          color: PRIMARY_COLOR2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
            buildActivityRadio('기타', '기타설명에 작성해 주세요.'),
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
          child: Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onActivitySelected(selectedActivity);
            Navigator.pop(context, selectedActivity);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SAVE_COLOR,
          ),
          child: Text('저장'),
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