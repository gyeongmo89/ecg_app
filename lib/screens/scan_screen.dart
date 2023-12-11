// // 패치수령후 BLE 테스트 코드
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// import 'device_screen.dart';
// import '../utils/snackbar.dart';
// import '../widgets/system_device_tile.dart';
// import '../widgets/scan_result_tile.dart';
// import '../utils/extra.dart';
//
// class ScanScreen extends StatefulWidget {
//   const ScanScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }
//
// class _ScanScreenState extends State<ScanScreen> {
//   List<BluetoothDevice> _systemDevices = [];
//   List<ScanResult> _scanResults = [];
//   bool _isScanning = false;
//   late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
//   late StreamSubscription<bool> _isScanningSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
//       _scanResults = results;
//       setState(() {});
//     }, onError: (e) {
//       Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
//     });
//
//     _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
//       _isScanning = state;
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _scanResultsSubscription.cancel();
//     _isScanningSubscription.cancel();
//     super.dispose();
//   }
//
//   Future onScanPressed() async {
//     try {
//       _systemDevices = await FlutterBluePlus.systemDevices;
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("System Devices Error:", e), success: false);
//     }
//
//     try {
//       // android is slow when asking for all advertisments,
//       // so instead we only ask for 1/8 of them
//       int divisor = Platform.isAndroid ? 8 : 1;
//       await FlutterBluePlus.startScan(
//           timeout: const Duration(seconds: 15), continuousUpdates: true, continuousDivisor: divisor);
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("Start Scan Error:", e), success: false);
//     }
//     setState(() {}); // force refresh of systemDevices
//   }
//
//   Future onStopPressed() async {
//     try {
//       FlutterBluePlus.stopScan();
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e), success: false);
//     }
//   }
//
//   void onConnectPressed(BluetoothDevice device) {
//     device.connectAndUpdateStream().catchError((e) {
//       Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
//     });
//     MaterialPageRoute route = MaterialPageRoute(
//         builder: (context) => DeviceScreen(device: device), settings: RouteSettings(name: '/DeviceScreen'));
//     Navigator.of(context).push(route);
//   }
//
//   Future onRefresh() {
//     if (_isScanning == false) {
//       FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
//     }
//     setState(() {});
//     return Future.delayed(Duration(milliseconds: 500));
//   }
//
//   Widget buildScanButton(BuildContext context) {
//     if (FlutterBluePlus.isScanningNow) {
//       return FloatingActionButton(
//         child: const Icon(Icons.stop),
//         onPressed: onStopPressed,
//         backgroundColor: Colors.red,
//       );
//     } else {
//       return FloatingActionButton(child: const Text("SCAN"), onPressed: onScanPressed);
//     }
//   }
//
//   List<Widget> _buildSystemDeviceTiles(BuildContext context) {
//     return _systemDevices
//         .map(
//           (d) => SystemDeviceTile(
//         device: d,
//         onOpen: () => Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => DeviceScreen(device: d),
//             settings: RouteSettings(name: '/DeviceScreen'),
//           ),
//         ),
//         onConnect: () => onConnectPressed(d),
//       ),
//     )
//         .toList();
//   }
//
//   List<Widget> _buildScanResultTiles(BuildContext context) {
//     return _scanResults
//         .map(
//           (r) => ScanResultTile(
//         result: r,
//         onTap: () => onConnectPressed(r.device),
//       ),
//     )
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger(
//       key: Snackbar.snackBarKeyB,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Find Devices'),
//         ),
//         body: RefreshIndicator(
//           onRefresh: onRefresh,
//           child: ListView(
//             children: <Widget>[
//               ..._buildSystemDeviceTiles(context),
//               ..._buildScanResultTiles(context),
//             ],
//           ),
//         ),
//         floatingActionButton: buildScanButton(context),
//       ),
//     );
//   }
// }

// -------------아래가 원래코드임(시연용) 블루투스 테스트하기위해서 주석처리함 2023-12-05 --------------
// 패치 받은 후 아래의 코드로 테스트할 예정
// Provider 추가, 날짜 관리때문에 1
// 중간화면 채우기 시작 1 10:57
import 'dart:async';
import 'dart:io';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import './device_screen.dart';
import '../../utils/snackbar.dart';
import '../../widgets/connected_device_tile.dart';
import '../../widgets/scan_result_tile.dart';
import '../../utils/extra.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<BluetoothDevice> _connectedDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  List<ScanResult> scanResultList = [];
  @override
  void initState() {
    super.initState();

    FlutterBluePlus.systemDevices.then((devices) {
      _connectedDevices = devices;
      setState(() {});
    });

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      setState(() {});
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  void generateDummyData() {
    for (int i = 0; i < 5; i++) {
      ScanResult dummyResult = ScanResult(
        device: BluetoothDevice(
          remoteId: DeviceIdentifier("D$i:6E:D4:3$i:CA:BE"),
        ),
        advertisementData: AdvertisementData(
          advName: "HolmesAI-Cardio ${i + 1}",
          txPowerLevel: 0, // 여기서 적절한 값으로 변경해주세요
          connectable: false, // 여기서 적절한 값으로 변경해주세요
          manufacturerData: {},
          serviceData: {},
          serviceUuids: [],
        ),
        rssi: -50 + i * 2,
        timeStamp: DateTime.now(), // 시간 정보 추가
      );
      scanResultList.add(dummyResult);
    }
  }

  Future onScanPressed() async {
    try {
      // android is slow when asking for all advertisments,
      // so instead we only ask for 1/8 of them
      int divisor = Platform.isAndroid ? 8 : 1;
      await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 5),
          continuousUpdates: true,
          continuousDivisor: divisor);
      //여기다 리스트 뿌려주는 화면
      generateDummyData(); // 내가 임의로 넣음
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
          success: false);
    }
    setState(() {}); // force refresh of systemDevices
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
          success: false);
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    // conntect되고 시리얼넘버 비교해서 정상이고, ECG 데이터를 가져오면 됨.
    // 이때부터 측정 1일차로 기록하면 됨

    final appState = Provider.of<AppState>(context, listen: false);
    appState.saveConnectedDate(DateTime.now());
    //-----------------------------------------------------------------

    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    });
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => DeviceScreen(device: device),
        settings: RouteSettings(name: '/DeviceScreen'));
    Navigator.of(context).push(route);
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    setState(() {});
    return Future.delayed(Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(
          backgroundColor: PRIMARY_COLOR2,
          child: Icon(Icons.search),
          onPressed: onScanPressed);
      // 여기 수정해야함
    }
  }

  List<Widget> _buildConnectedDeviceTiles(BuildContext context) {
    return _connectedDevices
        .map(
          (d) => ConnectedDeviceTile(
            device: d,
            onOpen: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DeviceScreen(device: d),
                settings: RouteSettings(name: '/DeviceScreen'),
              ),
            ),
            onConnect: () => onConnectPressed(d),
          ),
        )
        .toList();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .asMap()
        .entries
        .map(
          (entry) => ListTile(
            onTap: () {
              if (entry.key == 0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => RootTab()));
              } else {
                onConnectPressed(entry.value.device);
              }
            },
            leading: leading(entry.value),
            title: deviceName(entry.value),
            subtitle: deviceMacAddress(entry.value),
            trailing: deviceSignal(entry.value),
          ),
        )
        .toList();
  }

  //아래가 원래코드임 -----------시연을위해서 주석
  //   return _scanResults
  //       .map(
  //         (r) => ScanResultTile(
  //       result: r,
  //       onTap: () => onConnectPressed(r.device),
  //     ),
  //   )
  //       .toList();
  // }
//-------------------------------------------------
//   /* 장치의 명 위젯  */
  Widget deviceName(ScanResult r) {
    String name = r.device.name.isNotEmpty
        ? r.device.name
        : r.advertisementData.localName.isNotEmpty
            ? r.advertisementData.localName
            : 'N/A';
    return Text(name);
  }
// -------------------아래는 내가 임의 추가 시연을 위해서---그리고 주석함------
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

  /* BLE 아이콘 위젯 */
  Widget leading(ScanResult r) {
    return CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  /*  장치의 신호값 위젯  */
  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  /* 장치 아이템 위젯 */
  Widget listItem(ScanResult r) {
    return ListTile(
      // onTap: (){
      //   _buildScanResultTiles(context);
      // },
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => RootTab()));
        // if (r.device.name == 'HolmesAI-Cardio 1') {
        //   Navigator.of(context).push(MaterialPageRoute(builder: (_) => RootTab()));
        // }
        // else {
        //   onConnectPressed(r.device);
      },
      // onTap: () => onTap(r), // 원래 소스코드임 시연을 위해서 주석처리
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress(ScanResult r) {
    // return Text(r.device.id.id);
    return Text(r.device.id.id ?? 'N/A');
  }
  // -------------------위에는 내가 임의 추가 시연을 위해서---------

  @override
  Widget build(BuildContext context) {
    // return ScaffoldMessenger(
    return DefaultLayout(
      key: Snackbar.snackBarKeyB,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: APPBAR_COLOR,
          title: const Text('Holmes Cardio 연결'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 4.0,
              ),
              // 카디오 로고
              Image.asset(
                // "asset/img/misc/Cardio1.png",
                "asset/img/misc/HolmesCardio_2.png",
                width: MediaQuery.of(context).size.width / 6 * 2,
              ),
              const SizedBox(
                height: 4.0,
              ),
              // 사용설명 박스
              Container(
                width: MediaQuery.of(context).size.width / 3 * 5,
                // height: MediaQuery.of(context).size.height / 7.2 * 2,
                height: MediaQuery.of(context).size.height / 6.0 * 2,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFE6EBF0),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    )),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "1. Holmes Cardio를 앱에 등록하기 위해, "
                        "전원을 켜주세요.",
                        style: TextStyle(
                          fontSize: 16,
                          color: BODY_TEXT_COLOR,
                        )),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                        "2. 패치의 전원을 3초이상 누르면, 소리와 함께"
                        " 버튼의 색상이 노란색으로 3번 깜빡 거립니다.",
                        style: TextStyle(
                          fontSize: 16,
                          // color: BODY_TEXT_COLOR,
                        )),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '3. ',
                            style: TextStyle(fontSize: 16), // 폰트 사이즈 변경
                          ),
                          WidgetSpan(
                            child: Icon(Icons.search),
                          ),
                          TextSpan(
                            text: '버튼을 누르고 패치와 연결 합니다.',
                            style: TextStyle(fontSize: 16), // 폰트 사이즈 변경
                          ),
                        ],
                      ),
                    )
,
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: ListView.separated(
                    // 시연때문에 여기부터 임의추가함
                    itemCount: scanResultList.length,
                    itemBuilder: (context, index) {
                      return listItem(scanResultList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ), // 시연때문에 여기부터 임의추가함

                  // 아래가 원래의 정상적인 코드임----------
                  // child: ListView(
                  //   children: <Widget>[
                  //     ..._buildConnectedDeviceTiles(context),
                  //     ..._buildScanResultTiles(context),
                  //   ],
                  // ),
                  // -----------------------------------
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: buildScanButton(context),
      ),
    );
  }

  DeviceScreen({required BluetoothDevice device}) {}
}

// Provider 때문에 추가함
class AppState extends ChangeNotifier {
  DateTime? firstConnectedDate; // 처음 연결된 날짜를 저장하기 위한 변수
  int _connectedDays = 0; // 연결된 이후의 일 수를 저장하기 위한 변수

  // late DateTime connectedDate = DateTime.now(); // 초기값으로 현재 날짜를 설정합니다.

  void saveConnectedDate(DateTime date) {
    if (firstConnectedDate == null) {
      firstConnectedDate = date; // 처음 연결된 날짜를 저장합니다.
    } else {
      final difference = date.difference(firstConnectedDate!).inDays;
      if (difference >= 1) {
        _connectedDays = difference;
        // 처음 연결된 날짜 이후 1일 이상 차이가 나면 연결된 일수를 업데이트합니다.
      }
    }
    notifyListeners();
  }

  String getConnectedDayText() {
    if (firstConnectedDate == null) {
      return 'Not Connected'; // 아직 연결된 날짜가 없는 경우
    } else {
      final day = _connectedDays + 1; // 처음 연결된 날짜는 1일로 시작하므로 +1을 해줍니다.
      return 'DAY $day';
    }
  }
}
// void checkAndUpdateDay() {
//   final now = DateTime.now();
//   final difference = now.difference(connectedDate).inDays;
//
//   if (difference >= 1) {
//     // 하루가 지남
//     connectedDate = now;
//     // 연결된 날짜를 업데이트하고 상태를 알립니다.
//     notifyListeners();
//     // 여기에서 +1일이라는 메시지를 출력할 수 있습니다.
//     print('+1일');
//   }
// }
