import 'package:drift/drift.dart' show Value;
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:ecg_app/symptom_note/component/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet({
      required this.selectedDate,
      required this.scheduleId,
      super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime; // null 이 될 수 있게 "?"를 넣은것임
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
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
              content = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorID;
            }

            return SafeArea(
              child: Container(
                // height: MediaQuery.of(context).size.height / 1.05 +
                    height: MediaQuery.of(context).size.height / 1.9 +
                    bottomInset, // 노트 입력 시트 크기 조정
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 16.0,
                    ),
                    child: Form(
                      // 아래에 있는 모든 텍스트폼 필드를 컨트롤 할 수 있다.
                      // 폼에는 key를 넣어줘야한다
                      key: formKey, // Form의 컨트롤러 역할
                      // autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ----------- 시작/종료시간 -----------
                          _Time(
                            onStartSaved: (String? val) {
                              startTime = int.parse(val!);
                            },
                            onEndSaved: (String? val) {
                              endTime = int.parse(val!);
                            },
                            startInitialValue: startTime?.toString() ?? '',
                            // null 값이면 엠티스티링을 넣겟다.
                            endInitialValue: endTime?.toString() ?? '',
                          ),
                          // ---------------------------------
                          SizedBox(
                            height: 16.0,
                          ),
                          // ----------- 시작/종료시간 -----------


                      // Row(
                      //       children: <Widget>[
                      //         SizedBox(height: 40, width: 70,
                      //         child:  Radio<RadioImage>(
                      //           value: RadioImage.all,
                      //             groupValue: _radioImage,
                      //             onChanged: (RadioImage value){
                      //             setState(() {
                      //               _radioImage = value;
                      //               print('라디오 테스트 : $value');
                      //             });
                      //             },
                      //         ),)
                      //       ],
                      //     ),
                          // 증상 라디오 버튼 추가 해야함 추가필요
                          // 활동 라디오 버튼 추가 해야함 추가필요
                          _Content(
                            onSaved: (String? val) {
                              content = val;
                            },
                            initialValue: content ?? '',
                          ),
                          // ---------------------------------
                          SizedBox(
                            height: 16.0,
                          ),
                          // ----------- COlor -----------
                          FutureBuilder<List<CategoryColor>>(
                            future:
                                GetIt.I<LocalDatabase>().getCategoryColors(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  selectedColorId == null &&
                                  snapshot.data!.isNotEmpty) {
                                selectedColorId = snapshot.data![0].id;
                              }

                              // print(snapshot.data);
                              return _ColorPicker(
                                colors: snapshot.hasData ? snapshot.data! : [],
                                selectedColorId: selectedColorId,
                                colorIdSetter: (int id) {
                                  setState(() {
                                    selectedColorId = id;
                                  });
                                },
                              );
                            },
                          ),
                          // ---------------------------------
                          SizedBox(
                            height: 8.0,
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
      print("Content : $content");
      print("----------------");

      if (widget.scheduleId == null) {
        await GetIt.I<LocalDatabase>().createSchedule(
          // 데이터 생성
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorID: Value(selectedColorId!),
          ),
        );
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorID: Value(selectedColorId!),
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
class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;

  const _Time(
      {required this.onStartSaved,
      required this.onEndSaved,
      required this.startInitialValue,
      required this.endInitialValue,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          label: "시작시간",
          isTime: true,
          onSaved: onStartSaved,
          initialValue: startInitialValue,
        )),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
            child: CustomTextField(
          label: "종료시간",
          isTime: true,
          onSaved: onEndSaved,
          initialValue: endInitialValue,
        )),
      ],
    );
  }
// ----------------------------------------------
}

// ------------ 내용 입력 --------------
class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Content(
      {required this.onSaved, required this.initialValue, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: "증상선택 (Radio 버튼으로 변경예정)",
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}
// ----------------------------------------------

// ------------ Color 입력 --------------
typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Row(   // Row 대신 Wrap으로 변경하면 자동으로 아랫줄로 내려감
    return Wrap(
      // Row 대신 Wrap으로 변경하면 자동으로 아랫줄로 내려감
      spacing: 8.0, // 좌우간격
      runSpacing: 10.0, // 위아래 간격
      children: colors
          .map(
            (e) => GestureDetector(
              // 색깔을 누를때마다
              onTap: () {
                colorIdSetter(e.id);
              },
              child: renderColor(
                e,
                selectedColorId == e.id,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    // 실제로 선택이 되어있으면 bool값이 true가 되게
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(int.parse(
          "FF${color.hexCode}",
          radix: 16,
        )),
        border: isSelected
            ? Border.all(
                color: Colors.black,
                width: 4.0,
              )
            : null,
      ),
      width: 32.0,
      height: 32.0,
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
              primary: PRIMARY_COLOR2,
              // primary:  PRIMARY_COLOR,
            ),
            child: Text("저장"),
          ),
        ),
      ],
    );
  }
}
// ----------------------------------------------

