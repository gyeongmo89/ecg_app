import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => LocalDatabase());
}

void postDataToServer() async {

  final localDatabase = GetIt.I<LocalDatabase>();
  final allSchedules = await localDatabase.getAllSchedules();
  print("모든 등록된 일정 프린트 : $allSchedules");


  // 데이터 생성
  List<Map<String, dynamic>> postData = [
    {
      "patchSn": "zxcv",
      "symptomNote": {
        "handWritten": "수기 등록한 내용",
        "symptomActivity": [19, 20],
        "symptomEndDatetime": "2023-11-10 10:40:00",
        "symptomStartDatetime": "2023-11-10 10:20:00",
        "symptomType": [14, 15]
      }
    },
    {
      "patchSn": "zxcv",
      "symptomNote": {
        "handWritten": "수기 등록한 내용 ",
        "symptomActivity": [19, 20],
        "symptomEndDatetime": "2023-11-10 10:40:00",
        "symptomStartDatetime": "2023-11-10 10:20:00",
        "symptomType": [14, 15]
      }
    },
  ];

  // 서버 URL
  String url = "http://192.168.0.21:8080/";
  String path = "symptom-note/app";
  String symptomURL = url+path;

  // Dio 인스턴스 생성
  Dio dio = Dio();

  // JSON 형식으로 데이터 변환
  String jsonData = jsonEncode(postData);

  // POST 요청 보내기
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
    } else {
      // 요청이 실패함
      print("서버 응답 에러: ${response.statusCode}");
      print("요청이 실패함");
    }
  } catch (e) {
    // 예외 처리
    print("에러 발생: $e");
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 이 부분을 추가합니다.
  setupLocator(); // 앱 시작 시 GetIt을 설정합니다.
  // 앱 실행 시 데이터를 서버로 보내는 함수 호출
  postDataToServer();
}
