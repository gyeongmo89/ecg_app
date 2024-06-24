// 가져온 데이터 한개씩 변수로 맵핑 시작 1.
// 데이터 전송 Dialog 에러 수정 시작
// 공통코드 수정, 시리얼넘버 최 로 바꿈
// 2024-01-22 수정 시작 서버 업로드 팝업
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecg_app/common/component/custom_button.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void setupLocator() {
  GetIt.I.registerLazySingleton(() => LocalDatabase());
}

// void showSuccessDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         title: Text("전송 완료"),
//         content: Text("데이터가 성공적으로 전송되었습니다."),
//         actions: <Widget>[
//           CustomButton(
//             text: "확인",
//             onPressed: () {
//               Navigator.of(dialogContext).pop();
//             },
//             backgroundColor: SAVE_COLOR2,
//           ),
//         ],
//       );
//     },
//   );
// }
//
// void showFailureDialog(BuildContext context, String errorMessage) {
//   showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         title: Text("전송 실패"),
//         content: Text("전송이 실패 되었습니다. 에러코드 : $errorMessage"),
//         actions: <Widget>[
//           CustomButton(
//             text: "확인",
//             onPressed: () {
//               Navigator.of(dialogContext).pop();
//             },
//             backgroundColor: SAVE_COLOR2,
//           ),
//         ],
//       );
//     },
//   );
// }

Future<List<int>> fetchKeySymptomCodesFromServer() async {
  // 수정된 부분: 반환 타입 변경
  try {
    // Dio 인스턴스 생성
    Dio dio = Dio();

    // 서버 URL
    String url = "http://112.218.170.60:8083/"; // 테스트 서버
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

        // 추가된 부분: 데이터가 없거나 비어있는 경우 처리
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

Future<List<int>> fetchKeyActivityCodesFromServer() async {
  // 수정된 부분: 반환 타입 변경
  try {
    // Dio 인스턴스 생성
    Dio dio = Dio();
    // 서버 URL
    // String url = "http://112.218.170.60:8080/"; // 테스트 서버
    String url = "http://112.218.170.60:8083/"; // 테스트 서버
    String path = "code";
    String activityParam = "?domain=note&name=activity";
    String activityGetURL = url + path + activityParam;

    // Activity API 호출
    final activityResponse = await dio.get(
      activityGetURL,
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    if (activityResponse.statusCode == 200) {
      // 응답이 성공적으로 도착했을 때의 처리
      final responseData = activityResponse.data;
      if (responseData != null && responseData.containsKey('data')) {
        List<dynamic>? dataList = responseData['data'];
        print("Activity dataList =======> $dataList");
        print("activityResponse.statusCode == 200 진입");

        // 추가된 부분: 데이터가 없거나 비어있는 경우 처리
        if (dataList == null || dataList.isEmpty) {
          print("activity Data List 데이터가 비어있습니다.");
          return []; // 빈 리스트 반환 또는 예외 처리 방식으로 수정
        }
        print("if (dataList!.isNotEmpty) 진입");

        int workPhysicalActivityKey =
        dataList[0]['codeKey']; // 1번째 {}의 codeKey, 업무(육체활동)
        int workNonPhysicalActivityKey =
        dataList[1]['codeKey']; // 2번째 {}의 codeKey, 업무(비 육체활동)
        int watchingTVReadingKey =
        dataList[2]['codeKey']; // 3번째 {}의 codeKey, TV 시청, 독서 등의 활동
        int walkingKey = dataList[3]['codeKey']; // 4번째 {}의 codeKey, 걷기
        int runningKey = dataList[4]['codeKey']; // 5번째 {}의 codeKey, 달리기
        int houseworkKey = dataList[5]['codeKey']; // 6번째 {}의 codeKey, 집안일
        int activityEtcKey = dataList[6]['codeKey']; // 7번째 {}의 codeKey, 기타

        print("-------- 활동 코드 --------");
        print("1 번째 codeKey: $workPhysicalActivityKey");
        print("2 번째 codeKey: $workNonPhysicalActivityKey");
        print("3 번째 codeKey: $watchingTVReadingKey");
        print("4 번째 codeKey: $walkingKey");
        print("5 번째 codeKey: $runningKey");
        print("6 번째 codeKey: $houseworkKey");
        print("7 번째 codeKey: $activityEtcKey");
        print("------------------------");

        return [
          workPhysicalActivityKey,
          workNonPhysicalActivityKey,
          watchingTVReadingKey,
          walkingKey,
          runningKey,
          houseworkKey,
          activityEtcKey,
        ];
      } else {
        print("응답이나 키가 null입니다.");
        print("responseData => $responseData");
      }
    } else {
      print("Activity else 진입");
    }
  } catch (e) {
    // 예외 처리
    print("ActivityCodes 에러 발생: $e");
    return [];
    // 에러에 대한 처리 로직 추가
  }
  return [];
}


// void postDataToServer(BuildContext context) async {
void postDataToServer(BuildContext context) async {
// Future<void> postDataToServer(BuildContext context) async {
  final localDatabase = GetIt.I<LocalDatabase>();
  // final allSchedules = await localDatabase.getAllSchedules();
  // print("모든 등록된 일정 프린트 : $allSchedules");
  final symptomSchedules = await localDatabase.getDateSymptomActivityContent();
  print("선택된 컬럼 프린트 : $symptomSchedules");

  await Future.delayed(Duration(seconds: 1));

  final List<int> symptomCodeKeys = await fetchKeySymptomCodesFromServer();
  final List<int> activityCodeKeys = await fetchKeyActivityCodesFromServer();
  // int chestDiscomfortKey = codeKeys.isNotEmpty ? codeKeys[0] : 0; // 첫 번째 코드 키
  // int discomfortArmsNeckChinetcKey =
  //     codeKeys.length > 1 ? codeKeys[1] : 0; // 두 번째 코드 키
  // -- 활동선택 공통 코드 변수--
  // int chestDiscomfortKey = symptomCodeKeys[0]; //  가슴 불편함
  // int discomfortArmsNeckChinetcKey = symptomCodeKeys[1];  // 팔, 목, 턱 등이 불편함
  // int palpitaitionRapidHeartbeatKey = symptomCodeKeys[2];  // 심계항진(빠른 심장박동)
  // int shortnessOfBreathKey = symptomCodeKeys[3]; // 호흡곤란
  // int dizzinessKey = symptomCodeKeys[4]; // 현기증
  // int fatigueKey = symptomCodeKeys[5]; // 피로
  // int symptomEtcKey = symptomCodeKeys[6]; // 기타
// -- 증상선택 공통 코드 변수--
  print("symptomCodeKeys: $symptomCodeKeys");
  int chestDiscomfortKey = symptomCodeKeys[0]; //  가슴 불편함   //여기서 문제발생
  int discomfortArmsNeckChinetcKey = symptomCodeKeys[1]; // 팔, 목, 턱 등이 불편함
  int palpitaitionRapidHeartbeatKey = symptomCodeKeys[2]; // 심계항진(빠른 심장박동)
  int shortnessOfBreathKey = symptomCodeKeys[3]; // 호흡곤란
  int dizzinessKey = symptomCodeKeys[4]; // 현기증
  int fatigueKey = symptomCodeKeys[5]; // 피로
  int symptomEtcKey = symptomCodeKeys[6]; // 기타

  // -- 활동선택 공통 코드 변수--
  int workPhysicalActivityKey = activityCodeKeys[0]; // 업무(육체활동)
  int workNonPhysicalActivityKey = activityCodeKeys[1]; //업무(비 육체활동)
  int watchingTVReadingKey = activityCodeKeys[2]; // TV 시청, 독서 등의 활동
  int walkingKey = activityCodeKeys[3]; // 걷기
  int runningKey = activityCodeKeys[4]; // 달리기
  int houseworkKey = activityCodeKeys[5]; // 집안일
  int activityEtcKey = activityCodeKeys[6]; // 기타

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
    // fetcKeyhSymptomCodesFromServer();

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
      mappedActivity = '$watchingTVReadingKey';
    } else if (schedule['activity'] == '걷기') {
      mappedActivity = '$walkingKey';
    } else if (schedule['activity'] == '달리기') {
      mappedActivity = '$runningKey';
    } else if (schedule['activity'] == '업무(육체활동)') {
      mappedActivity = '$workPhysicalActivityKey';
    } else if (schedule['activity'] == '업무(비 육체활동)') {
      mappedActivity = '$workNonPhysicalActivityKey';
    } else if (schedule['activity'] == '집안일') {
      mappedActivity = '$houseworkKey';
    } else if (schedule['activity'] == '기타') {
      mappedActivity = '$activityEtcKey'; // 기타
    } else {
      mappedActivity = ''; // null
    }

    // 날짜 데이터 포맷 변경
    // String formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(schedule['date'].add(Duration(minutes: schedule['endTime'])));
    // String formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(schedule['date'].add(Duration(minutes: schedule['startTime'])));
    String formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(schedule['date'].add(Duration(minutes: schedule['startTime'])));
    String formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(schedule['date'].add(Duration(minutes: schedule['endTime'])));
    print("Original Start Time: $formattedStartDate");
    print("Original End Time: $formattedEndDate");

    // 문자열로 된 날짜를 DateTime 형식으로 변환
    DateTime StartDate = DateTime.parse(formattedStartDate);
    DateTime endDate = DateTime.parse(formattedEndDate);

    // 9시간을 뺀 시간 계산
    DateTime adjustedStartTime = StartDate.subtract(Duration(hours: 9));
    DateTime adjustedEndTime = endDate.subtract(Duration(hours: 9));

    // 변경된 시간을 다시 문자열로 변환
    String adjustedStartString =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(adjustedStartTime);
    String adjustedEndString =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(adjustedEndTime);

    print("patchSn --> serial_00001");
    print("handWritten --> $schedule['content'],타입: ${schedule['content'].runtimeType}, 길이: ${schedule['content'].length}");
    print("symptomActivity --> ${[mappedActivity]}, 타입: ${[mappedActivity].runtimeType}, 길이: ${[mappedActivity].length}");
    print("symptomStartDatetime --> $adjustedStartString, 타입: ${adjustedStartString.runtimeType}, 길이: ${adjustedStartString.length}");
    print("symptomEndDatetime --> $adjustedEndString, 타입: ${adjustedEndString.runtimeType}, 길이: ${adjustedEndString.length}");
    print("symptomType --> ${[mappedSymptom]}, 타입: ${[mappedSymptom].runtimeType}, 길이: ${[mappedSymptom].length}");
    print("mappedActivity --> $mappedActivity, ${mappedActivity.runtimeType}, 길이: ${mappedActivity.length}");
    //스웨거 확인 http://112.218.170.60:8080/swagger-ui.html -> symptom-note-controller -> /symptom-note/app
    print('postData: $postData');

    postData.add({
      "patchSn": "serial_00001",
      "symptomNote": {
        "handWritten": schedule['content'] ?? "",
        // "symptomActivity": [mappedActivity], // activity 값을 사용
        "symptomActivity": mappedActivity.isEmpty ? [-1] : [int.parse(mappedActivity[0])],
        "symptomEndDatetime": adjustedEndString,
        "symptomStartDatetime": adjustedStartString,
        // "symptomType": [mappedSymptom],
        "symptomType": mappedSymptom.isEmpty ? [-1] : [int.parse(mappedSymptom[0])],
      }
    });

    postData.add({
      "patchSn": "serial_00001",
      "symptomNote": {
        "handWritten": schedule['content'] ?? "",
        "symptomActivity": [3], // activity 값을 사용
        // "symptomActivity": [int.parse(mappedActivity)],
        "symptomEndDatetime": adjustedEndString,
        "symptomStartDatetime": adjustedStartString,
        "symptomType": [10],
        // "symptomType": [int.parse(mappedSymptom)],
      }
    });
  }

  //   postData.add({
  //     "patchSn": "medivchoi",
  //     "symptomNote": {
  //       "handWritten": schedule['content'] ?? "",
  //       "symptomActivity": [mappedActivity], // activity 값을 사용
  //       "symptomEndDatetime": adjustedEndString,
  //       "symptomStartDatetime": adjustedStartString,
  //       "symptomType": [mappedSymptom], // 매핑된 symptom 값 사용
  //     }
  //   });
  // }

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
  // String url = "http://192.168.0.21:8080/"; // 엄팀장 서버
  String url = "http://112.218.170.60:8083/"; // 테스트 서버
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

void dataTransferSuccessToast() {
  Fluttertoast.showToast(
    msg: "데이터 업로드가 완료 되었습니다.",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    // backgroundColor: Colors.green,
    // textColor: Colors.white,
    fontSize: 16.0,
  );
}
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


// void showEmptyDataDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         title: Text("알림"),
//         content: Text("전송할 데이터가 없습니다."),
//         actions: <Widget>[
//           CustomButton(
//             text: "확인",
//             onPressed: () {
//               Navigator.of(dialogContext).pop();
//             },
//             backgroundColor: SAVE_COLOR2,
//           ),
//         ],
//       );
//     },
//   );
// }






