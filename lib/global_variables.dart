// global_variables.dart: 전역변수 설정

import 'package:flutter/foundation.dart';

// menu_drawer.dart에서 사용하는 전역변수
String globalDeviceName = '';
// 업로드 완료 상태를 추적하는 전역변수
// bool isUploadComplete = false;
bool globalIsUploadComplete = false;
//
// lib/global_variables.dart
String saveStartDate = ''; // BLE 최초 연결 날짜

class BleConnectionState with ChangeNotifier {
  String _stateText = 'Disconnected';

  String get stateText => _stateText;

  set stateText(String value) {
    _stateText = value;
    notifyListeners();
  }
}