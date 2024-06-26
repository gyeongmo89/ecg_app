// 2024-04-12 10:20 BLE 통신테스트 코드를 IheartU에 병합 시작 1
// 2024-04-12 10:44 BLE 통신테스트 코드를 IheartU에 병합 시작 2
// 2024-04-12 11:30 Widget build(BuildContext context) 수정시작 1
// 2024-04-12 15:33 Widget build(BuildContext context) 수정완료
// 2024-04-12 15:34 검색된 HW 눌렀을때 Root 탭이동 수정 시작 1
// 2024-05-28 15:42 디바이스장치 명 전역변수 설정(Drawer에 적용하기위해)
// 2024-06-19 16:55 flutter_blue_plus library 업데이트 시작

import 'package:ecg_app/common/component/menu_drawer.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ecg_app/global_variables.dart';
// -----
//flutter build apk --release --target-platform=android-arm64

import 'device_screen.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final title = 'CLtime 검색목록';
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: title,
//       home: ScanScreen(title: title),
//     );
//   }
// }

class ScanScreen extends StatefulWidget {
  ScanScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // String globalDeviceName = '';

  // BLE 장치의 제품명이 HolmesAI_로 시작하는 장치만 검색
  final String targetDeviceName = 'HolmesAI_';
  BluetoothDevice? targetDevice; // Add this line to store the target device
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;
  int tapCount = 0;





  @override
  initState() {
    super.initState();
    // 블루투스 초기화
    initBle();
  }

  void initBle() {
    // BLE 스캔 상태 얻기 위한 리스너
    FlutterBluePlus.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  /*
  스캔 시작/정지 함수
  */
  scan() async {
    if (!_isScanning) {
      // 스캔 중이 아니라면
      // 기존에 스캔된 리스트 삭제
      scanResultList.clear();
      // 스캔 시작, 제한 시간 4초
      FlutterBluePlus.startScan(timeout: Duration(seconds: 15),androidUsesFineLocation: true);
      // 스캔 결과 리스너
      //--------------------------------
      // flutterBlue.scanResults.listen((results) {
      FlutterBluePlus.onScanResults.listen((results) {
        // 결과 값을 루프로 돌림
        results.forEach((element) {
          //찾는 장치명인지 확인
          if (element.device.name.contains(targetDeviceName)) {
            // if (element.device.name == targetDeviceName) {
            //장치의 ID를 비교해 이미 등록된 장치인지 확인
            if (scanResultList
                    .indexWhere((e) => e.device.id == element.device.id) <
                0) {
              //찾는 장치명이고 scanResultList에 등록된적이 없는 장치라면 리스트에 추가
              scanResultList.add(element);
            }
          } else {
            print('element.device.name: ${element.device.name}');
          }
        });
        // results.forEach((element) {
        //   //찾는 장치명인지 확인
        //   if (element.device.name == targetDeviceName) {
        //     //장치의 ID를 비교해 이미 등록된 장치인지 확인
        //     if (scanResultList
        //             .indexWhere((e) => e.device.id == element.device.id) <
        //         0) {
        //       //찾는 장치명이고 scanResultList에 등록된적이 없는 장치라면 리스트에 추가
        //       scanResultList.add(element);
        //     }
        //   }
        //   else
        //   {
        //     print('element.device.name: ${element.device.name}');
        //   }
        // });
        // UI 갱신
        setState(() {});
      });
//--------------------------------
//       flutterBlue.scanResults.listen((results) {
//         // 결과 값을 루프로 돌림
//         results.forEach((element) {
//           //찾는 장치명인지 확인
//           if(element.device.name == targetDeviceName){
//             //장치의 ID를 비교해 이미 등록된 장치인지 확인
//             if (scanResultList.indexWhere((e) => e.device.id == element.device.id) < 0){
//               //찾는 장치명이고 scanResultList에 등록된적이 없는 장치라면 리스트에 추가
//               scanResultList.add(element);
//             }
//           }
//         });
//
//         scanResultList = results;
//         // UI 갱신
//         setState(() {});
//       });
      //--------------------------------
    } else {
      // 스캔 중이라면 스캔 정지
      FlutterBluePlus.stopScan();
    }
  }

  /*
   여기서부터는 장치별 출력용 함수들
  */
  /*  장치의 신호값 위젯  */
  Widget deviceSignal(ScanResult r) {
    return Text(
      r.rssi.toString(),
      style: TextStyle(
        color: Colors.white, // Set the text color to white
      ),
    );
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress(ScanResult r) {
    return Text(
      r.device.id.id,
      style: TextStyle(
        color: Colors.white60, // Set the text color to white
      ),
    );
  }
  // String globalDeviceName = '';
  /* 장치의 명 위젯  */
  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      // device.name에 값이 있다면
      name = r.device.name;
      globalDeviceName = name;
      print("globalDevice Name확인: $globalDeviceName");
      // deviceNameReturn();
    } else if (r.advertisementData.localName.isNotEmpty) {
      // advertisementData.localName에 값이 있다면
      name = r.advertisementData.localName;
    } else {
      // 둘다 없다면 이름 알 수 없음...
      name = 'N/A';
    }
    // globalDeviceName = name;

    return Text(
      name,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold, // Set the text to bold
      ),
    );
  }

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

  /* 장치 아이템을 탭 했을때 호출 되는 함수 */
  // void onTap(ScanResult r) {
  //   // 단순히 이름만 출력
  //   print('${r.device.name}');
  //   Navigator.push(
  //     context,
  //     // MaterialPageRoute(builder: (context) => DeviceScreen(device: r.device)),
  //     // MaterialPageRoute(builder: (context) => RootTab()),
  //
  //     MaterialPageRoute(builder: (context) => RootTab(device: r.device)),
  //   );
  //   // MenuDrawer(device: r.device);
  // }

  void onTap(ScanResult r) {
  print('onTap 디바이스 네임: ${r.device.name}');
  print("r.device: ${r.device}");
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DefaultLayout(
        device: r.device, // Pass the device here
        child: RootTab(
          device: r.device, // Pass the device here
        ),
        // device: r.device, // Pass the device here
      ),
    ),
  );
}

  /* 장치 아이템 위젯 */
  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  //   Future onRefresh() {
  //   if (_isScanning == false) {
  //     FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
  //   }
  //   setState(() {});
  //   return Future.delayed(Duration(milliseconds: 500));
  // }

  @override
  Widget build(BuildContext context) {

    //여기
    return DefaultLayout(
      //
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: APPBAR_COLOR,
          title: const Text(
            '기기(패치) 연결',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(
                  0xFF0DB2B2,
                ),
                Color(
                  0xFF00A2C8,
                ),
                Color(
                  0xFF0D8CD0,
                ),
                Color(
                  0xFF6C70C1,
                ),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // SizedBox(
                //   height: 4.0,
                // ),
                // 카디오 로고
                Image.asset(
                  "asset/img/misc/heartCare1.png",
                  width: MediaQuery.of(context).size.width / 3,
                ),
                // 사용설명 박스
                Container(
                  width: MediaQuery.of(context).size.width / 3 * 5,
                  height: MediaQuery.of(context).size.height / 6.0 * 1.6,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xFFE6EBF0),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "1. 기기(패치)를 앱에 등록하기 위해, "
                          "전원을 켜주세요.",
                          style: TextStyle(
                            fontSize: 16,
                            color: BODY_TEXT_COLOR,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 6.0 * 0.1,
                      ),
                      Text(
                          "2. 전원을 3초이상 누르면, 소리와 함께"
                          " 버튼의 색상이 노란색으로 3번 깜빡 거립니다.",
                          style: TextStyle(
                            fontSize: 16,
                            color: BODY_TEXT_COLOR,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 6.0 * 0.1,
                      ),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '3. ',
                              style: TextStyle(
                                fontSize: 16,
                                color: BODY_TEXT_COLOR,
                              ), // 폰트 사이즈 변경
                            ),
                            WidgetSpan(
                              child: Icon(
                                Icons.search,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '버튼을 누르고 기기(패치)를 연결 합니다.',
                              style: TextStyle(
                                fontSize: 16,
                                color: BODY_TEXT_COLOR,
                              ), // 폰트 사이즈 변경
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6.0 * 0.1,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: scanResultList.length,
                    itemBuilder: (context, index) {
                      return listItem(scanResultList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Colors.white24,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        /* 장치 검색 or 검색 중지  */
        floatingActionButton: FloatingActionButton(
          onPressed: scan,
          // 스캔 중이라면 stop 아이콘을, 정지상태라면 search 아이콘으로 표시
          backgroundColor: _isScanning ? Colors.red : PRIMARY_COLOR2,
          child: Icon(_isScanning ? Icons.stop : Icons.search),
        ),
      ),
       // Pass the device here
    );
  }
}
// void deviceNameReturn(){
//   String deviceName = globalDeviceName;
//   print('deviceName: $deviceName');
//   globalDeviceName = deviceName;
// }


// -----
//   // -------------------위에는 내가 임의 추가 시연을 위해서---------
//   @override
//   Widget build(BuildContext context) {
//     // return ScaffoldMessenger(
//     return DefaultLayout(
//       key: Snackbar.snackBarKeyB,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: APPBAR_COLOR,
//           title: const Text(
//             '기기(패치) 연결',
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//         // body: Padding(
//         //   padding: const EdgeInsets.all(12.0),
//         // 배경변경하려면 위에 두줄 주석하고 아래코드 주석 풀면됨
//
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(
//                   0xFF0DB2B2,
//                 ),
//                 Color(
//                   0xFF00A2C8,
//                 ),
//                 Color(
//                   0xFF0D8CD0,
//                 ),
//                 Color(
//                   0xFF6C70C1,
//                 ),
//               ],
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               children: [
//                 // SizedBox(
//                 //   height: 4.0,
//                 // ),
//                 // 카디오 로고
//                 Image.asset(
//                   // "asset/img/misc/Cardio1.png",
//                   "asset/img/misc/heartCare1.png",
//                   width: MediaQuery.of(context).size.width / 3,
//                 ),
//                 // 사용설명 박스
//                 Container(
//                   width: MediaQuery.of(context).size.width / 3 * 5,
//                   // height: MediaQuery.of(context).size.height / 7.2 * 2,
//                   height: MediaQuery.of(context).size.height / 6.0 * 1.6,
//                   padding: const EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: const Color(0xFFE6EBF0),
//                       border: Border.all(
//                         color: Colors.white,
//                         width: 2.0,
//                       )),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                           "1. 기기(패치)를 앱에 등록하기 위해, "
//                           "전원을 켜주세요.",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: BODY_TEXT_COLOR,
//                           )),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height / 6.0 * 0.1,
//                       ),
//                       Text(
//                           "2. 전원을 3초이상 누르면, 소리와 함께"
//                           " 버튼의 색상이 노란색으로 3번 깜빡 거립니다.",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: BODY_TEXT_COLOR,
//                           )),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height / 6.0 * 0.1,
//                       ),
//                       const Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: '3. ',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: BODY_TEXT_COLOR,
//                               ), // 폰트 사이즈 변경
//                             ),
//                             WidgetSpan(
//                               child: Icon(
//                                 Icons.search,
//                                 size: 20,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             TextSpan(
//                               text: '버튼을 누르고 기기(패치)를 연결 합니다.',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: BODY_TEXT_COLOR,
//                               ), // 폰트 사이즈 변경
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 6.0 * 0.1,
//                 ),
//                 Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: onRefresh,
//                     child: ListView.separated(
//                       // 시연때문에 여기부터 임의추가함
//                       itemCount: scanResultList.length,
//                       itemBuilder: (context, index) {
//                         return listItem(scanResultList[index]);
//                       },
//                       separatorBuilder: (BuildContext context, int index) {
//                         return Divider();
//                       },
//                     ), // 시연때문에 여기부터 임의추가함
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: buildScanButton(context),
//       ),
//     );
//   }
//
//   DeviceScreen({required BluetoothDevice device}) {}
// }
//
// // Provider 때문에 추가함
// class AppState extends ChangeNotifier {
//   DateTime? firstConnectedDate; // 처음 연결된 날짜를 저장하기 위한 변수
//   int _connectedDays = 0; // 연결된 이후의 일 수를 저장하기 위한 변수
//
//   // late DateTime connectedDate = DateTime.now(); // 초기값으로 현재 날짜를 설정합니다.
//
//   void saveConnectedDate(DateTime date) {
//     if (firstConnectedDate == null) {
//       firstConnectedDate = date; // 처음 연결된 날짜를 저장합니다.
//     } else {
//       final difference = date.difference(firstConnectedDate!).inDays;
//       if (difference >= 1) {
//         _connectedDays = difference;
//         // 처음 연결된 날짜 이후 1일 이상 차이가 나면 연결된 일수를 업데이트합니다.
//       }
//     }
//     notifyListeners();
//   }
//
//   String getConnectedDayText() {
//     if (firstConnectedDate == null) {
//       return 'Not Connected'; // 아직 연결된 날짜가 없는 경우
//     } else {
//       final day = _connectedDays + 1; // 처음 연결된 날짜는 1일로 시작하므로 +1을 해줍니다.
//       return 'DAY $day';
//     }
//   }
// }
// // void checkAndUpdateDay() {
// //   final now = DateTime.now();
// //   final difference = now.difference(connectedDate).inDays;
// //
// //   if (difference >= 1) {
// //     // 하루가 지남
// //     connectedDate = now;
// //     // 연결된 날짜를 업데이트하고 상태를 알립니다.
// //     notifyListeners();
// //     // 여기에서 +1일이라는 메시지를 출력할 수 있습니다.
// //     print('+1일');
// //   }
// // }
