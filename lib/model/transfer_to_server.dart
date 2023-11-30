// 가져온 데이터 한개씩 변수로 맵핑 시작 1.
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecg_app/common/component/custom_button.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => LocalDatabase());
}

void postDataToServer(BuildContext context) async {

  final localDatabase = GetIt.I<LocalDatabase>();
  // final allSchedules = await localDatabase.getAllSchedules();
  // print("모든 등록된 일정 프린트 : $allSchedules");
  final symptomSchedules = await localDatabase.getDateSymptomActivityContent();
  print("선택된 컬럼 프린트 : $symptomSchedules");

  // 증상발현시 활동
  // 17 : None
  // 18 : Activities such as watching TV and reading / TV 시청, 독서 등의 활동
  // 19 : Walking / 걷기
  // 20 : Running / 달리기
  // 33 : Work (physical activity) / 업무(육체활동)
  // 35 : Work (non-physical activity) 업무(비 육체활동)

  // 증상종류
  // 10 : None
  // 11 : Discomfort int the arms, neck, chin, etc. / 팔, 목, 턱 등이 불편함
  // 12 : Palpitaition(rapid heartbeat) / 심계항진(빠른 심장박동)
  // 13 : Shortness of Breath / 호흡곤란
  // 14 : Dizziness / 현기증
  // 15 : Fatigue / 피로
  // 16 : Chest discomfort / 가슴 불편함

  List<Map<String, dynamic>> postData = [];
  for (var schedule in symptomSchedules) {
    String mappedSymptom = ''; // 기본값 설정
    String mappedActivity = ''; // 기본값 설정

    // // symptom 매핑   // 지용씨
    // if (schedule['symptom'] == '팔, 목, 턱 등이 불편함') {
    //   mappedSymptom = '11';
    // } else if (schedule['symptom'] == '심계항진(빠른 심장박동)') {
    //   mappedSymptom = '12';
    // }
    // else if (schedule['symptom'] == '호흡곤란') {
    //   mappedSymptom = '13';
    // }
    // else if (schedule['symptom'] == '현기증') {
    //   mappedSymptom = '14';
    // }
    // else if (schedule['symptom'] == '피로') {
    //   mappedSymptom = '15';
    // }
    // else if (schedule['symptom'] == '가슴 불편함') {
    //   mappedSymptom = '16';
    // }
    // else{
    //   mappedSymptom = '10';
    // }
    // symptom 매핑   // 테스트 서버용
    if (schedule['symptom'] == '팔, 목, 턱 등이 불편함') {
      mappedSymptom = '11';
    } else if (schedule['symptom'] == '심계항진(빠른 심장박동)') {
      mappedSymptom = '12';
    }
    else if (schedule['symptom'] == '호흡곤란') {
      mappedSymptom = '13';
    }
    else if (schedule['symptom'] == '현기증') {
      mappedSymptom = '14';
    }
    else if (schedule['symptom'] == '피로') {
      mappedSymptom = '15';
    }
    else if (schedule['symptom'] == '가슴 불편함') {
      mappedSymptom = '10';
    }
    else if (schedule['symptom'] == '기타') {
      mappedSymptom = '32'; // 변경해야함
    }
    else{
      mappedSymptom = '';
    }

    // // activity 매핑 // 지용씨
    // if (schedule['activity'] == 'TV 시청, 독서 등의 활동') {
    //   mappedActivity = '18';
    // } else if (schedule['activity'] == '걷기') {
    //   mappedActivity = '19';
    // }
    // else if (schedule['activity'] == '달리기') {
    //   mappedActivity = '20';
    // }
    // else if (schedule['activity'] == '업무(육체활동)') {
    //   mappedActivity = '33';
    // }
    // else if (schedule['activity'] == '업무(비 육체활동)') {
    //   mappedActivity = '35';
    // }
    // else {
    //   mappedActivity = '17';
    // }
    // activity 매핑 // 테스트 서버용
    if (schedule['activity'] == 'TV 시청, 독서 등의 활동') {
      mappedActivity = '18';
    } else if (schedule['activity'] == '걷기') {
      mappedActivity = '19';
    }
    else if (schedule['activity'] == '달리기') {
      mappedActivity = '20';
    }
    else if (schedule['activity'] == '업무(육체활동)') {
      mappedActivity = '16';
    }
    else if (schedule['activity'] == '업무(비 육체활동)') {
      mappedActivity = '17';
    }
    else if (schedule['activity'] == '기타') {
      mappedActivity = '25';  // 변경해야함
    }
    else {
      mappedActivity = '';  // null
    }

    // 날짜 데이터 포맷 변경
    // String formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(schedule['date'].add(Duration(minutes: schedule['endTime'])));
    // String formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(schedule['date'].add(Duration(minutes: schedule['startTime'])));
    String formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(schedule['date'].add(Duration(minutes: schedule['startTime'])));
    String formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(schedule['date'].add(Duration(minutes: schedule['endTime'])));
    print("Original Start Time: $formattedStartDate");
    print("Original End Time: $formattedEndDate");

    // 문자열로 된 날짜를 DateTime 형식으로 변환
    DateTime StartDate = DateTime.parse(formattedStartDate);
    DateTime endDate = DateTime.parse(formattedEndDate);

    // 9시간을 뺀 시간 계산
    DateTime adjustedStartTime = StartDate.subtract(Duration(hours: 9));
    DateTime adjustedEndTime = endDate.subtract(Duration(hours: 9));

    // 변경된 시간을 다시 문자열로 변환
    String adjustedStartString = DateFormat('yyyy-MM-dd HH:mm:ss').format(adjustedStartTime);
    String adjustedEndString = DateFormat('yyyy-MM-dd HH:mm:ss').format(adjustedEndTime);
    print("Adjusted Start Time: $adjustedStartString");
    print("Adjusted End Time: $adjustedEndString");


    print("handWritten --> $schedule['content']");
    print("symptomActivity --> ${[mappedActivity]}");
    print("symptomStartDatetime --> $adjustedStartString");
    print("symptomEndDatetime --> $adjustedEndString");
    print("symptomType --> ${[mappedSymptom]}");



    postData.add({
      "patchSn": "serial_00001",
      "symptomNote": {
        "handWritten": schedule['content'] ?? "",
        "symptomActivity": [mappedActivity], // activity 값을 사용
        "symptomEndDatetime": adjustedEndString,
        "symptomStartDatetime": adjustedStartString,
        "symptomType": [mappedSymptom], // 매핑된 symptom 값 사용
      }
    });
  }

  // // 데이터 생성
  // List<Map<String, dynamic>> postData = [
  //   {
  //     "patchSn": "serial_00001",
  //     // "patchSn": "serial_00012",
  //     "symptomNote": {
  //       "handWritten": "1개 값만 입력 테스트",
  //       // "symptomActivity": [19, 20],
  //       "symptomActivity": [19],
  //       "symptomEndDatetime": "2023-11-10 10:20:00",
  //       "symptomStartDatetime": "2023-11-10 10:20:00",
  //       // "symptomType": [14, 15]
  //       "symptomType": [14]
  //     }
  //   },
  //   // {
  //   //   "patchSn": "serial_00002",
  //   //   "symptomNote": {
  //   //     "handWritten": "수기 등록한 내용 ",
  //   //     "symptomActivity": [19, 20],
  //   //     "symptomEndDatetime": "2023-11-10 10:40:00",
  //   //     "symptomStartDatetime": "2023-11-10 10:20:00",
  //   //     "symptomType": [14, 15]
  //   //   }
  //   // },
  // ];

  // 서버 URL
  // String url = "http://192.168.0.21:8080/"; // 지용씨 서버
  String url = "http://112.218.170.60:8080/"; // 테스트 서버
  String path = "symptom-note/app";
  String symptomURL = url+path;

  // Dio 인스턴스 생성
  Dio dio = Dio();

  // JSON 형식으로 데이터 변환
  String jsonData = jsonEncode(postData);

  if(symptomSchedules.isEmpty){
    // 전송할 데이터가 없습니다.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
          content: Text("전송할 데이터가 없습니다."),
          actions: <Widget>[
            CustomButton(
              text: "확인",
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: SAVE_COLOR2,
            ),
          ],
        );
      },
    );

  }
  else{
    try {
      final response = await dio.post(
        symptomURL,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: jsonData,
      );

      if (response.statusCode == 200) {
        // 성공적으로 요청이 처리됨
        print("서버 응답: ${response.data}");
        print("성공적으로 요청이 처리됨");
        // AlertDialog 표시
        print("response data 분기 ${response.data["success"]}");
        if (response.data["success"] == true){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("전송 완료"),
                content: Text("데이터가 성공적으로 전송되었습니다."),
                actions: <Widget>[
                  CustomButton(
                    text: "확인",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: SAVE_COLOR2,
                  ),
                ],
              );
            },
          );
        }
        else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("전송 실패"),
                content: Text("전송이 실패 되었습니다. 에러코드 : ${response.data["error"]}"),
                actions: <Widget>[
                  CustomButton(
                    text: "확인",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: SAVE_COLOR2,
                  ),
                ],
              );
            },
          );
        }
      } else {
        // 요청이 실패함
        print("서버 응답 에러: ${response.statusCode}");
        print("요청이 실패함");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("전송 요청 실패"),
              content: Text("전송 요청이 실패 되었습니다. 에러코드 : ${response.statusCode}"),
              actions: <Widget>[
                CustomButton(
                  text: "확인",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: SAVE_COLOR2,
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // 예외 처리
      print("에러 발생: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("전송 실패"),
            content: Text("에러가 발생 하였습니다. 에러코드 : $e"),
            actions: <Widget>[
              CustomButton(
                text: "확인",
                onPressed: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: SAVE_COLOR2,
              ),
            ],
          );
        },
      );
    }


  }

  // POST 요청 보내기
}

// void main() {
//   // WidgetsFlutterBinding.ensureInitialized(); // 이 부분을 추가합니다.
//   setupLocator(); // 앱 시작 시 GetIt을 설정
//   // 앱 실행 시 데이터 를 서버로 보내는 함수 호출
//   postDataToServer();
// }
