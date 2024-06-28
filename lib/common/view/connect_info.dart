// 2024-02-06 지문인식 추가
// 2024-05-09 13:23 Provider 변경
// 2024-05-09 13:43 Provider 변경2

import 'package:ecg_app/bluetooth/utils/bluetooth_manager.dart';
import 'package:ecg_app/bluetooth/utils/snackbar.dart';
import 'package:ecg_app/common/component/custom_button.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/bluetooth/screens/scan_screen.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:ecg_app/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:ecg_app/common/view/local_auth.dart';  // 지문인식기능 (현재는 불필요하여 주석처리함)

class ConnectionInfo extends StatefulWidget {
  const ConnectionInfo({super.key});

  @override
  State<ConnectionInfo> createState() => _ConnectionInfoState();
}

class _ConnectionInfoState extends State<ConnectionInfo> {
  // final LocalAuthentication auth = LocalAuthentication();  // 지문인식기능 (현재는 불필요하여 주석처리함)
  bool _isDialogShown = false; // 앱 최대 사용시간 제한을 위해서 추가

  @override
  void initState() {
    super.initState();
    // authenticateUser();
  }

  // 지문인식기능 (현재는 불필요하여 주석처리함)
  // Future<bool> authenticateUser() async {
  //   await Future.delayed(Duration(milliseconds: 500)); // 0.5초 딜레이
  //   bool authenticated = await LocalAuthApi
  //       .authenticate();
  //   if (!authenticated) {
  //     SystemNavigator.pop();
  //   }
  //   return authenticated;
  // }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final timerService =
        Provider.of<TimerService>(context); // 앱 최대 사용시간 제한을 위해서 추가

    return StreamBuilder<int>(
      stream: timerService.timerStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData && snapshot.data! >= 3600000 && !_isDialogShown) {
          // 테스트를 위해 시간설정을 길게 함, 배포할때는 주석하고 밑에 코드를 주석 해제
          // if (snapshot.hasData && snapshot.data! >= 3600 && !_isDialogShown) { // 1시간 설정 3600초 = 1시간
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _isDialogShown = true; // Set the flag to true
            });
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('앱 최대 사용시간 알림'),
                  content: Text('앱은 최대 1시간만 사용할 수 있습니다.\n앱을 종료합니다.'),
                  actions: [
                    CustomButton(
                      text: "확인",
                      onPressed: () {
                        Navigator.of(context).pop();
                        exit(0);
                      },
                      backgroundColor: SAVE_COLOR2,
                    ),
                  ],
                );
              },
            ).then((_) {
              _isDialogShown = true;
            });
          });
        }
        return DefaultLayout(
          child: Container(
            // 배경 그린계열로 그라데이션 설정
            decoration: const BoxDecoration(
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
                ])),
            // child: SingleChildScrollView(
            child: SafeArea(
              top: true,
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: deviceHeight / 5 * 0.1,
                      ),
                      // 홈즈AI 로고
                      Image.asset(
                        "asset/img/logo/HolmesAI_LOGO.png",
                        width: deviceWidth / 3 * 1,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: deviceHeight / 20 * 0.1,
                      ),
                      // 부착설명 사진
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          "asset/img/misc/mountingPosition_3.png",
                          width: deviceWidth,
                          height: deviceHeight / 5,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // 사용설명 박스
                      Container(
                        width: deviceWidth / 4 * 5,
                        height: deviceHeight / 5 * 2.31,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xFFE6EBF0),
                            border: Border.all(
                              color: Colors.white,
                              width: deviceWidth / 4 * 0.01,
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                "✔ 부착시 오른쪽 확대 사진 처럼 전원 버튼이 8시 방향을 향하게 부착 합니다.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: BODY_TEXT_COLOR,
                                )),
                            SizedBox(
                              height: deviceHeight / 5 * 0.2,
                            ),
                            const Text(
                                "✔ 1번의 쇄골 중앙지점과 2번의 왼쪽 유두 사이를 "
                                "45도 각도로 가상의 선을 그을 때 3번에 해당 하는"
                                "영역 중앙부에 패치를 부착 합니다.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: BODY_TEXT_COLOR,
                                )),
                            SizedBox(
                              height: deviceHeight / 5 * 0.2,
                            ),
                            const Text(
                                "✔ X-ray 확인시 심장이 이보다 아래에 위치한 경우 "
                                "심장이 위치한 부위와 가깝게 붙이도록 합니다.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: BODY_TEXT_COLOR,
                                )),
                            SizedBox(
                              height: deviceHeight / 5 * 0.2,
                            ),
                            const Text("✔ 패치 부착 후 파형이 정상인지 확인 합니다.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: BODY_TEXT_COLOR,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight / 5 * 0.2,
                      ),
                      // Start 버튼
                      ElevatedButton(
                        onPressed: () async {
                          // 지문인식 기능 (현재는 불필요하여 주석처리)
                          // bool authenticated = await authenticateUser();
                          // if (!authenticated) {
                          //   return;
                          // }
                          try {
                            if (Platform.isAndroid) {
                              await FlutterBluePlus.turnOn(); // 블루투스 키도록 설정
                              BluetoothDevice? savedDevice =
                                  await BluetoothManager().getSavedDevice(context);
                              print("savedDeviceId: $savedDevice");
                              if (savedDevice != null) {
                                // 저장된 장치 ID가 있으면 ECG 화면으로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DefaultLayout(
                                      child: RootTab(
                                        device: savedDevice,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // 저장된 장치 ID가 없으면 스캔하는 화면으로 이동
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ScanScreen(title: ''),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            Snackbar.show(
                              ABC.a,
                              prettyException("Error Turning On:", e),
                              success: false,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: PRIMARY_COLOR2,
                            fixedSize: Size(400, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            )),
                        child: Text(
                          "Start",
                          style: TextStyle(fontSize: 26, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
