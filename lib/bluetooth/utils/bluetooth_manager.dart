import 'dart:async';
import 'package:ecg_app/bluetooth/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothManager {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  static const String DEVICE_ID_KEY = 'DEVICE_ID';


  Future<void> connectToDevice(BluetoothDevice device) async {
    // Connect to the device
    await device.connect();

    // Save the device ID
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DEVICE_ID_KEY, device.id.id);
  }

  Future<void> connectAndSaveDevice(BluetoothDevice device) async {
    // Connect to the device
    await device.connect();

    // Save the device ID
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DEVICE_ID_KEY, device.id.id);
  }

  Future<String?> getSavedDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DEVICE_ID_KEY);
  }

  Future<BluetoothDevice?> getSavedDevice(BuildContext context) async {
    String? savedDeviceId = await getSavedDeviceId();
    if (savedDeviceId != null) {
      BluetoothDevice? savedDevice;
      bool isScanScreenPushed = false; // 플래그 추가
      FlutterBluePlus.startScan(
          timeout: Duration(seconds: 5), androidUsesFineLocation: true);

      await for (var results in FlutterBluePlus.onScanResults) {
        for (ScanResult r in results) {
          if (r.device.id.id == savedDeviceId) {
            savedDevice = r.device;
            FlutterBluePlus.stopScan();
            print("Saved Device: $savedDevice");
            break;
          }
        }
        if (savedDevice != null) {
          break;

        }
        else if (!isScanScreenPushed) { // 스캔이 완료되지 않은 경우 ScanScreen으로 이동
          Navigator.of(context as BuildContext).push(
            MaterialPageRoute(
              builder: (_) => ScanScreen(title: ''),
            ),
          );
          isScanScreenPushed = true;
        }
      }
      return savedDevice;
    }
    return null;
  }
}
