import 'package:flutter/foundation.dart';

class BleConnectionState with ChangeNotifier {
  String _stateText = 'Disconnected';

  String get stateText => _stateText;

  set stateText(String value) {
    _stateText = value;
    notifyListeners();
  }
}