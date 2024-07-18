// scan_screen.dart: 블루투스 통신을 위해 스캔하는 화면

import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ecg_app/global_variables.dart';

class ScanScreen extends StatefulWidget {
  ScanScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final String targetDeviceName = 'HolmesAI_'; // BLE 장치의 제품명이 HolmesAI_로 시작하는 장치만 검색
  BluetoothDevice? targetDevice;
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;
  int tapCount = 0;

  @override
  initState() {
    super.initState();
    initBle();
  }

  void initBle() {
    // BLE 스캔 상태 얻기 위한 리스너
    FlutterBluePlus.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  // 스캔 시작/정지 함수
  scan() async {
    if (!_isScanning) {
      // 기존에 스캔된 리스트 삭제
      scanResultList.clear();
      // 스캔 시작, 제한 시간 15초
      FlutterBluePlus.startScan(timeout: Duration(seconds: 15),androidUsesFineLocation: true);
      // 스캔 결과 리스너
      FlutterBluePlus.onScanResults.listen((results) {
        // 결과 값을 루프로 돌림
        results.forEach((element) {
          //찾는 장치명인지 확인
          if (element.device.name.contains(targetDeviceName)) {
            //장치의 ID를 비교해 이미 등록된 장치인지 확인
            if (scanResultList
                    .indexWhere((e) => e.device.id == element.device.id) <
                0) {
              //찾는 장치명이고 scanResultList에 등록된적이 없는 장치라면 리스트에 추가
              scanResultList.add(element);
            }
          } else {
            // print('element.device.name: ${element.device.name}');
          }
        });
        setState(() {});
      });
    } else {
      // 스캔 중이라면 스캔 정지
      FlutterBluePlus.stopScan();
    }
  }

  // 여기서부터는 장치별 출력용 함수들
  // 장치의 신호값 위젯
  Widget deviceSignal(ScanResult r) {
    return Text(
      r.rssi.toString(),
      style: TextStyle(
        color: Colors.white, // Set the text color to white
      ),
    );
  }

  // 장치의 MAC 주소 위젯
  Widget deviceMacAddress(ScanResult r) {
    return Text(
      r.device.id.id,
      style: TextStyle(
        color: Colors.white60, // Set the text color to white
      ),
    );
  }

  // 장치의 명 위젯
  Widget deviceName(ScanResult r) {
    String name = '';
    if (r.device.name.isNotEmpty) {
      name = r.device.name;
      globalDeviceName = name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      name = r.advertisementData.localName;
    } else {
      name = 'N/A';
    }

    return Text(
      name,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // BLE 아이콘 위젯
  Widget leading(ScanResult r) {
    return CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  void onTap(ScanResult r) {
  // print('선택했을때 Device Name: ${r.device.name}');
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DefaultLayout(
        device: r.device,
        child: RootTab(
          device: r.device,
        ),
      ),
    ),
  );
}

  // 장치 아이템 위젯
  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
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
        // 장치 검색 or 검색 중지
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
