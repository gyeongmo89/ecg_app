// 패치 받은 후 아래의 코드로 테스트할 예정

// Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ecg_app/bluetooth/screens/bluetooth_off_screen.dart';
import 'package:ecg_app/bluetooth/screens/scan_screen.dart';


void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const FlutterBlueApp());
}

class FlutterBlueApp extends StatefulWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  State<FlutterBlueApp> createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const ScanScreen()
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      color: Colors.lightBlue,
      home: screen,
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
// // ---------------------------------------------------------------------------


// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// import 'screens/device_screen.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final title = 'BLE Set Notification';
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: title,
//       home: MyHomePage(title: title),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   FlutterBluePlus flutterBlue = FlutterBluePlus();
//   List<ScanResult> scanResultList = [];
//   bool _isScanning = false;
//
//   @override
//   initState() {
//     super.initState();
//     // 블루투스 초기화
//     initBle();
//   }
//
//   void initBle() {
//     // BLE 스캔 상태 얻기 위한 리스너
//     FlutterBluePlus.isScanning.listen((isScanning) {
//       _isScanning = isScanning;
//       setState(() {});
//     });
//   }
//
//   /*
//   스캔 시작/정지 함수
//   */
//   scan() async {
//     if (!_isScanning) {
//       // 스캔 중이 아니라면
//       // 기존에 스캔된 리스트 삭제
//       scanResultList.clear();
//       // 스캔 시작, 제한 시간 4초
//       FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
//       // 스캔 결과 리스너
//       FlutterBluePlus.scanResults.listen((results) {
//         scanResultList = results;
//         // UI 갱신
//         setState(() {});
//       });
//     } else {
//       // 스캔 중이라면 스캔 정지
//       FlutterBluePlus.stopScan();
//     }
//   }
//
//   /*
//    여기서부터는 장치별 출력용 함수들
//   */
//   /*  장치의 신호값 위젯  */
//   Widget deviceSignal(ScanResult r) {
//     return Text(r.rssi.toString());
//   }
//
//   /* 장치의 MAC 주소 위젯  */
//   Widget deviceMacAddress(ScanResult r) {
//     return Text(r.device.id.id);
//   }
//
//   /* 장치의 명 위젯  */
//   Widget deviceName(ScanResult r) {
//     String name = '';
//
//     if (r.device.name.isNotEmpty) {
//       // device.name에 값이 있다면
//       name = r.device.name;
//     } else if (r.advertisementData.localName.isNotEmpty) {
//       // advertisementData.localName에 값이 있다면
//       name = r.advertisementData.localName;
//     } else {
//       // 둘다 없다면 이름 알 수 없음...
//       name = 'N/A';
//     }
//     return Text(name);
//   }
//
//   /* BLE 아이콘 위젯 */
//   Widget leading(ScanResult r) {
//     return CircleAvatar(
//       child: Icon(
//         Icons.bluetooth,
//         color: Colors.white,
//       ),
//       backgroundColor: Colors.cyan,
//     );
//   }
//
//   /* 장치 아이템을 탭 했을때 호출 되는 함수 */
//   void onTap(ScanResult r) {
//     // 단순히 이름만 출력
//     print('${r.device.name}');
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => DeviceScreen(device: r.device)),
//     );
//   }
//
//   /* 장치 아이템 위젯 */
//   Widget listItem(ScanResult r) {
//     return ListTile(
//       onTap: () => onTap(r),
//       leading: leading(r),
//       title: deviceName(r),
//       subtitle: deviceMacAddress(r),
//       trailing: deviceSignal(r),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         /* 장치 리스트 출력 */
//         child: ListView.separated(
//           itemCount: scanResultList.length,
//           itemBuilder: (context, index) {
//             return listItem(scanResultList[index]);
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider();
//           },
//         ),
//       ),
//       /* 장치 검색 or 검색 중지  */
//       floatingActionButton: FloatingActionButton(
//         onPressed: scan,
//         // 스캔 중이라면 stop 아이콘을, 정지상태라면 search 아이콘으로 표시
//         child: Icon(_isScanning ? Icons.stop : Icons.search),
//       ),
//     );
//   }
// }

// // 아래는 GPT 예제
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   FlutterBluePlus flutterBlue = FlutterBluePlus();
//   List<ScanResult> devicesList = [];
//   bool isScanning = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('BLE Scanner'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               scanDevices();
//             },
//             child: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: devicesList.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(
//                     devicesList[index].device.name.isNotEmpty
//                         ? devicesList[index].device.name
//                         : 'Unknown Device',
//                   ),
//                   subtitle: Text(devicesList[index].device.id.toString()),
//                   onTap: () {
//                     connectToDevice(devicesList[index].device);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> scanDevices() async {
//     setState(() {
//       devicesList.clear();
//       isScanning = true;
//     });
//
//     try {
//       FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
//       FlutterBluePlus.scanResults.listen((results) {
//         for (ScanResult result in results) {
//           if (!devicesList.contains(result)) {
//             setState(() {
//               devicesList.add(result);
//             });
//           }
//         }
//       });
//     } catch (e) {
//       print('Error while scanning: $e');
//     } finally {
//       setState(() {
//         isScanning = false;
//       });
//     }
//   }
//
//   Future<void> connectToDevice(BluetoothDevice device) async {
//     try {
//       await device.connect();
//       // 연결에 성공한 후 작업을 수행할 수 있습니다.
//       print('Connected to ${device.name}');
//     } catch (e) {
//       print('Error while connecting: $e');
//     }
//   }
// }

