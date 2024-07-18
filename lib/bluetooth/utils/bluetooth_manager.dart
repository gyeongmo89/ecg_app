// bluetooth_manager.dart: BLE 장치와 연결 되었을때 관리항목을 관리함
import 'dart:async';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:ecg_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothManager extends ChangeNotifier {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  static const String DEVICE_ID_KEY = 'DEVICE_ID';
  static const String DEVICE_NAME_KEY = 'DEVICE_NAME';
  List<ScanResult> scanResultList = [];
  static const String START_DATE_KEY = 'START_DATE';


  Future<void> connectToDevice(BluetoothDevice device) async {
    // Device 연결
    await device.connect();

    // Device ID 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DEVICE_ID_KEY, device.id.id);
  }


  Future<void> connectAndSaveDevice(BluetoothDevice device) async {
    // Device 연결
    await device.connect();
    // Device ID 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DEVICE_ID_KEY, device.id.id);
    await prefs.setString(DEVICE_NAME_KEY, device.name);

    // 시작날짜가 이미 저장되어있으면
    String? startDate = prefs.getString(START_DATE_KEY);
    if (startDate == null) {
      print('startDate is null');
      startDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      startDate =startDate;
      await prefs.setString(START_DATE_KEY, startDate);
    }
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

      FlutterBluePlus.startScan(androidUsesFineLocation: true);

      await for (var results in FlutterBluePlus.onScanResults) {
        for (ScanResult r in results) {
          if (r.device.id.id == savedDeviceId) {
            savedDevice = r.device;

            FlutterBluePlus.stopScan();
            globalDeviceName = savedDevice.name;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DefaultLayout(
                    device: savedDevice,
                    child: RootTab(
                      device: savedDevice,
                    ),
                  ),
                ),
              );
            FlutterBluePlus.stopScan(); // 2024-07-05 10:40 추가
            // break;
            return savedDevice;
          }
           else if  (!isScanScreenPushed) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DefaultLayout(
                      device: savedDevice,
                      child: RootTab(
                        device: savedDevice,
                      ),
                    ),
              ),
            );
            // break;
            isScanScreenPushed = true;

            // FlutterBluePlus.stopScan();
          }
        }
        scanResultList = results;
        notifyListeners();
      }
      return savedDevice;
    }
    return null;
  }
}