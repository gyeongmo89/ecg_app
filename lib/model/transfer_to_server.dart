// transfer_to_server.dart: 서버로 데이터(증상노트)를 전송

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecg_app/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => LocalDatabase());
}

// 서버로부터 증상 공통 코드를 가져오는 함수
Future<List<int>> fetchKeySymptomCodesFromServer() async {
  try {
    // Dio 인스턴스 생성
    Dio dio = Dio();

    // 서버 URL
    // String url = "http://112.218.170.60:8083/"; // 테스트 서버
    String url = "https://dev.holmesai.co.kr/api/"; // 개발 서버
    // String url = "https://report.holmesai.co.kr/api/"; // 운영 서버

    String path = "code";
    String symptomParam = "?domain=note&name=symptom";
    String symptomGetURL = url + path + symptomParam;

    // Symptom API 호출
    final symptomResponse = await dio.get(
      symptomGetURL,
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    if (symptomResponse.statusCode == 200) {
      // 응답이 성공적으로 도착했을 때의 처리
      print("응답이 성공적으로 도착했을 때의 처리 진입");
      final responseData = symptomResponse.data;
      if (responseData != null && responseData.containsKey('data')) {
        List<dynamic>? dataList = responseData['data'];
        print("Symptom dataList =======> $dataList");

        // 데이터가 없거나 비어있는 경우 처리
        if (dataList == null || dataList.isEmpty) {
          print("symptom Data List 데이터가 비어있습니다.");
          return []; // 빈 리스트 반환 또는 예외 처리 방식으로 수정
        }
        int chestDiscomfortKey =
        dataList[0]['codeKey']; // 1번째 {}의 codeKey, 가슴 불편함
        int discomfortArmsNeckChinetcKey =
        dataList[1]['codeKey']; // 2번째 {}의 codeKey, 팔, 목, 턱 등이 불편함
        int palpitaitionRapidHeartbeatKey =
        dataList[2]['codeKey']; // 3번째 {}의 codeKey, 심계항진(빠른 심장박동)
        int shortnessOfBreathKey =
        dataList[3]['codeKey']; // 4번째 {}의 codeKey, 호흡곤란
        int dizzinessKey = dataList[4]['codeKey']; // 5번째 {}의 codeKey, 현기증
        int fatigueKey = dataList[5]['codeKey']; // 6번째 {}의 codeKey, 피로
        int symptomEtcKey = dataList[6]['codeKey']; // 7번째 {}의 codeKey, 기타

        print("-------- 증상 코드 --------");
        print("1 번째 codeKey: $chestDiscomfortKey");
        print("2 번째 codeKey: $discomfortArmsNeckChinetcKey");
        print("3 번째 codeKey: $palpitaitionRapidHeartbeatKey");
        print("4 번째 codeKey: $shortnessOfBreathKey");
        print("5 번째 codeKey: $dizzinessKey");
        print("6 번째 codeKey: $fatigueKey");
        print("7 번째 codeKey: $symptomEtcKey");
        print("------------------------");

        return [
          chestDiscomfortKey,
          discomfortArmsNeckChinetcKey,
          palpitaitionRapidHeartbeatKey,
          shortnessOfBreathKey,
          dizzinessKey,
          fatigueKey,
          symptomEtcKey,
        ];
      } else {
        print("응답이나 키가 null입니다.");
        print("responseData => $responseData");
      }
    } else {
      print("Symptom else 진입");
    }
  } catch (e) {
    // 예외 처리
    print("SymptomCodes 에러 발생: $e");
    return [];
    // 에러에 대한 처리 로직 추가
  }
  return [];
}
// 프로젝트 초기에는 Activity 코드도 가져와야했지만 현재는 불필요하여 주석처리함
// Future<List<int>> fetchKeyActivityCodesFromServer() async {
//   // 수정된 부분: 반환 타입 변경
//   try {
//     // Dio 인스턴스 생성
//     Dio dio = Dio();
//     // 서버 URL
//     // String url = "http://112.218.170.60:8080/"; // 테스트 서버
//     // String url = "http://112.218.170.60:8083/"; // 테스트 서버
//     String url = "https://dev.holmesai.co.kr/api/"; // 개발 서버
//     // String url = "https://report.holmesai.co.kr/api/"; // 운영 서버
//
//     String path = "code";
//     String activityParam = "?domain=note&name=activity";
//     String activityGetURL = url + path + activityParam;
//
//     // Activity API 호출
//     final activityResponse = await dio.get(
//       activityGetURL,
//       options: Options(
//         headers: {
//           "Content-Type": "application/json",
//         },
//       ),
//     );
//
//     if (activityResponse.statusCode == 200) {
//       // 응답이 성공적으로 도착했을 때의 처리
//       final responseData = activityResponse.data;
//       if (responseData != null && responseData.containsKey('data')) {
//         List<dynamic>? dataList = responseData['data'];
//         print("Activity dataList =======> $dataList");
//         print("activityResponse.statusCode == 200 진입");
//
//         // 추가된 부분: 데이터가 없거나 비어있는 경우 처리
//         if (dataList == null || dataList.isEmpty) {
//           print("activity Data List 데이터가 비어있습니다.");
//           return []; // 빈 리스트 반환 또는 예외 처리 방식으로 수정
//         }
//         print("if (dataList!.isNotEmpty) 진입");
//
//         int workPhysicalActivityKey =
//         dataList[0]['codeKey']; // 1번째 {}의 codeKey, 업무(육체활동)
//         int workNonPhysicalActivityKey =
//         dataList[1]['codeKey']; // 2번째 {}의 codeKey, 업무(비 육체활동)
//         int watchingTVReadingKey =
//         dataList[2]['codeKey']; // 3번째 {}의 codeKey, TV 시청, 독서 등의 활동
//         int walkingKey = dataList[3]['codeKey']; // 4번째 {}의 codeKey, 걷기
//         int runningKey = dataList[4]['codeKey']; // 5번째 {}의 codeKey, 달리기
//         int houseworkKey = dataList[5]['codeKey']; // 6번째 {}의 codeKey, 집안일
//         int activityEtcKey = dataList[6]['codeKey']; // 7번째 {}의 codeKey, 기타
//
//         print("-------- 활동 코드 --------");
//         print("1 번째 codeKey: $workPhysicalActivityKey");
//         print("2 번째 codeKey: $workNonPhysicalActivityKey");
//         print("3 번째 codeKey: $watchingTVReadingKey");
//         print("4 번째 codeKey: $walkingKey");
//         print("5 번째 codeKey: $runningKey");
//         print("6 번째 codeKey: $houseworkKey");
//         print("7 번째 codeKey: $activityEtcKey");
//         print("------------------------");
//
//         return [
//           workPhysicalActivityKey,
//           workNonPhysicalActivityKey,
//           watchingTVReadingKey,
//           walkingKey,
//           runningKey,
//           houseworkKey,
//           activityEtcKey,
//         ];
//       } else {
//         print("응답이나 키가 null입니다.");
//         print("responseData => $responseData");
//       }
//     } else {
//       print("Activity else 진입");
//     }
//   } catch (e) {
//     // 예외 처리
//     print("ActivityCodes 에러 발생: $e");
//     return [];
//     // 에러에 대한 처리 로직 추가
//   }
//   return [];
// }

// 서버로 데이터를 전송하는 함수
void postDataToServer(BuildContext context) async {
  final localDatabase = GetIt.I<LocalDatabase>();
  // final allSchedules = await localDatabase.getAllSchedules();
  // print("모든 등록된 일정 프린트 : $allSchedules");
  final symptomSchedules = await localDatabase.getDateSymptomActivityContent();
  print("선택된 컬럼 프린트 : $symptomSchedules");

  await Future.delayed(Duration(seconds: 1));

  final List<int> symptomCodeKeys = await fetchKeySymptomCodesFromServer();
  // final List<int> activityCodeKeys = await fetchKeyActivityCodesFromServer();  // 활동 코드는 현재 사용하지 않음

// 증상선택 공통 코드 변수
  print("symptomCodeKeys: $symptomCodeKeys");
  int chestDiscomfortKey = symptomCodeKeys[0]; //  가슴 불편함   //여기서 문제발생
  int discomfortArmsNeckChinetcKey = symptomCodeKeys[1]; // 팔, 목, 턱 등이 불편함
  int palpitaitionRapidHeartbeatKey = symptomCodeKeys[2]; // 심계항진(빠른 심장박동)
  int shortnessOfBreathKey = symptomCodeKeys[3]; // 호흡곤란
  int dizzinessKey = symptomCodeKeys[4]; // 현기증
  int fatigueKey = symptomCodeKeys[5]; // 피로
  int symptomEtcKey = symptomCodeKeys[6]; // 기타

  // // -- 활동선택 공통 코드 변수--
  // int workPhysicalActivityKey = activityCodeKeys[0]; // 업무(육체활동)
  // int workNonPhysicalActivityKey = activityCodeKeys[1]; //업무(비 육체활동)
  // int watchingTVReadingKey = activityCodeKeys[2]; // TV 시청, 독서 등의 활동
  // int walkingKey = activityCodeKeys[3]; // 걷기
  // int runningKey = activityCodeKeys[4]; // 달리기
  // int houseworkKey = activityCodeKeys[5]; // 집안일
  // int activityEtcKey = activityCodeKeys[6]; // 기타

  // 증상발현시 활동
  // 17 : None
  // 18 : Activities such as watching TV and reading / TV 시청, 독서 등의 활동
  // 19 : Walking / 걷기
  // 20 : Running / 달리기
  // 33 : Work (physical activity) / 업무(육체활동)
  // 35 : Work (non-physical activity) 업무(비 육체활동)

  // 증상종류
  // 10 : None
  // 11 : Discomfort int the arms, neck, chin, etcKey. / 팔, 목, 턱 등이 불편함
  // 12 : Palpitaition(rapid heartbeat) / 심계항진(빠른 심장박동)
  // 13 : Shortness of Breath / 호흡곤란
  // 14 : dizzinessKey / 현기증
  // 15 : fatigueKey / 피로
  // 16 : Chest discomfort / 가슴 불편함

  // 증상노트 데이터를 담을 리스트
  List<Map<String, dynamic>> postData = [];
  for (var schedule in symptomSchedules) {
    String mappedSymptom = ''; // 기본값 설정
    String mappedActivity = ''; // 기본값 설정

    if (schedule['symptom'] == '팔, 목, 턱 등이 불편함') {
      mappedSymptom = '$discomfortArmsNeckChinetcKey';
    } else if (schedule['symptom'] == '심계항진(빠른 심장박동)') {
      mappedSymptom = '$palpitaitionRapidHeartbeatKey';
    } else if (schedule['symptom'] == '호흡곤란') {
      mappedSymptom = '$shortnessOfBreathKey';
    } else if (schedule['symptom'] == '현기증') {
      mappedSymptom = '$dizzinessKey';
    } else if (schedule['symptom'] == '피로') {
      mappedSymptom = '$fatigueKey';
    } else if (schedule['symptom'] == '가슴 불편함') {
      // Chest discomfort
      mappedSymptom = '$chestDiscomfortKey';
    } else if (schedule['symptom'] == '기타') {
      mappedSymptom = '$symptomEtcKey'; // 변경해야함
    } else {
      mappedSymptom = '';
    }

    // 날짜 데이터 포맷 변경
    String formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(schedule['date'].add(Duration(minutes: schedule['startTime'])));
    String formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(schedule['date'].add(Duration(minutes: schedule['endTime'])));
    print("Original Start Time: $formattedStartDate");
    print("Original End Time: $formattedEndDate");

    // 문자열로 된 날짜를 DateTime 형식으로 변환
    DateTime StartDate = DateTime.parse(formattedStartDate);
    DateTime endDate = DateTime.parse(formattedEndDate);

    // // 9시간을 뺀 시간 계산(한국시간으로 변경)
    DateTime adjustedStartTime = StartDate.subtract(Duration(hours: 9));
    DateTime adjustedEndTime = endDate.subtract(Duration(hours: 9));

    // 변경된 시간을 다시 문자열로 변환
    String adjustedStartString =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(adjustedStartTime);
    String adjustedEndString =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(adjustedEndTime);

    print("handWritten --> $schedule['content'],타입: ${schedule['content'].runtimeType}, 길이: ${schedule['content'].length}");
    print("symptomActivity --> ${[mappedActivity]}, 타입: ${[mappedActivity].runtimeType}, 길이: ${[mappedActivity].length}");
    print("symptomStartDatetime --> $adjustedStartString, 타입: ${adjustedStartString.runtimeType}, 길이: ${adjustedStartString.length}");
    print("symptomEndDatetime --> $adjustedEndString, 타입: ${adjustedEndString.runtimeType}, 길이: ${adjustedEndString.length}");
    print("symptomType --> ${[mappedSymptom]}, 타입: ${[mappedSymptom].runtimeType}, 길이: ${[mappedSymptom].length}");
    print("mappedActivity --> $mappedActivity, ${mappedActivity.runtimeType}, 길이: ${mappedActivity.length}");
    //스웨거 확인 http://112.218.170.60:8080/swagger-ui.html -> symptom-note-controller -> /symptom-note/app
    print('postData: $postData');

    postData.add({
      // "patchSn": "serial_00001",
      // "patchSn": "OQ240702002"
      "patchSn": "sample1",
      "symptomNote": {
        // "handWritten": schedule['content'] ?? "",
        "situation": schedule['content'] ?? "",
        // "symptomActivity": [mappedActivity], // activity 값을 사용
        "symptomActivity": mappedActivity.isEmpty ? [-1] : [int.parse(mappedActivity[0])],
        "symptomEndDateTime": adjustedEndString,
        "symptomStartDateTime": adjustedStartString,
        // "symptomType": [mappedSymptom],
        // "symptomType": mappedSymptom.isEmpty ? [-1] : [int.parse(mappedSymptom[0])],
        "symptomType": mappedSymptom.isEmpty ? [-1] : [mappedSymptom],
      }
    });
  }
  // 서버 URL
  // String url = "http://192.168.0.21:8080/"; // 엄팀장 서버
  // String url = "http://112.218.170.60:8083/"; // 테스트 서버
  String url = "https://dev.holmesai.co.kr/api/"; // 개발 서버
  // String url = "https://report.holmesai.co.kr/api/"; // 운영 서버
  String path = "symptom-note/app";
  String symptomURL = url + path;



  // Dio 인스턴스 생성
  Dio dio = Dio();

  // JSON 형식으로 데이터 변환
  String jsonData = jsonEncode(postData);

  if (symptomSchedules.isEmpty) {
    // 전송할 데이터가 없습니다.
    noDataToast();
    // showEmptyDataDialog(context);
  } else {
    // 데이터 전송
    try {
      print('Sending data: $postData');
      final response = await dio.post(
        symptomURL,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        // data: jsonData,
        data: postData,
      );

      if (response.statusCode == 200) {
        // 성공적으로 요청이 처리됨
        print("서버 응답: ${response.data}");
        print("성공적으로 요청이 처리됨");
        // AlertDialog 표시
        print("response data 분기 ${response.data["success"]}");
        if (response.data["success"] == true) {
          print("요청이 성공함");
          dataTransferSuccessToast();
        } else {
          print("서버 응답 에러: ${response.statusCode}");
          print("요청이 실패함");
          // showFailureDialog(context, response.statusCode.toString());
          dataTransferFailToast();
        }
      }

    } catch (e) {
      // 예외 처리
      print("에러 발생: $e");
      dataTransferFailToast();
    }
  } // POST 요청 보내기
}
// 데이터 전송 성공 토스트 메시지
Future<void> dataTransferSuccessToast() async {
  Fluttertoast.showToast(
    msg: "데이터 업로드가 완료 되었습니다.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    // backgroundColor: Colors.green,
    // textColor: Colors.white,
    fontSize: 16.0,
  );
  globalIsUploadComplete = true;
  // print("isUploadComplete: $isUploadComplete");
  // SharedPreferences 인스턴스를 가져옴
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // isUploadComplete 값을 SharedPreferences에 저장합니다.
  await prefs.setBool('isUploadComplete', true);
  await prefs.setBool('isUploadCompleteFuture', true);

  print("isUploadComplete: ${prefs.getBool('isUploadComplete')}");
}
// 데이터 전송 실패 토스트 메시지
void dataTransferFailToast() {
  Fluttertoast.showToast(
    msg: "데이터 전송이 실패 하였습니다.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
// 전송할 데이터가 없을 때 토스트 메시지
void noDataToast() {
  Fluttertoast.showToast(
    msg: "전송할 데이터가 없습니다.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}





