import 'package:flutter/foundation.dart';

// 전역변수 설정

// menu_drawer.dart에서 사용하는 전역변수
String globalDeviceName = '';

//
class BleConnectionState with ChangeNotifier {
  String _stateText = 'Disconnected';

  String get stateText => _stateText;

  set stateText(String value) {
    _stateText = value;
    notifyListeners();
  }
}