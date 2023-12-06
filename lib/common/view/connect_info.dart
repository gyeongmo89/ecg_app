// 그래디언트 적용 시작1
// 다시 블루투스 연결시작1
import 'package:ecg_app/ble_main.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:ecg_app/common/view/first_loading.dart';
import 'package:ecg_app/ecg_test.dart';
import 'package:ecg_app/screens/scan_screen.dart';
import 'package:ecg_app/user/view/test.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../utils/snackbar.dart';

class ConnectionInfo extends StatelessWidget {
  const ConnectionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Container(
        decoration: const BoxDecoration(
            // gradient: RadialGradient( // 가운데부터 확장
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              // 다크블루 계열---
              Color(0xFF000118),
              Color(0xFF03045e),
              Color(0xFF023e8a),
              Color(0xFF0077b6),
              // --------------
              // 그린 계열---
              // Color(0xFF143601),
              // Color(0xFF1a4301),
              // Color(0xFF245501),
              // Color(0xFF538d22),
              // --------------
              // 보라 계열---
              // Color(0xFF10002b),
              // Color(0xFF240046),
              // Color(0xFF3c096c),
              // Color(0xFF5a189a),
              // Color(0xFF7b2cbf),
              // Color(0xFF9d4edd),
              // --------------
              // 청록 계열---
              // Color(0xFF081c15),
              // Color(0xFF1b4332),
              // Color(0xFF2d6a4f),
              // Color(0xFF40916c),
              // Color(0xFF52b788),
              // --------------
            ])),
        // child: SingleChildScrollView(
        child: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 홈즈 AI 로고
                  SizedBox(
                    height: 14.0,
                  ),
                  Image.asset(
                    "asset/img/logo/HolmesAI PNG.png",
                    width: MediaQuery.of(context).size.width / 3 * 1,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),

                  // 부착설명 로고
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.antiAlias, // 이미지를 컨테이너의 경계에 따라 잘라내도록 설정
                    child: Image.asset(
                      "asset/img/misc/mountingPosition.PNG",
                      width: MediaQuery.of(context).size.width / 2 * 2,
                    ),
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),

                  // 사용설명 박스
                  Container(
                    // width: MediaQuery.of(context).size.width / 3 * 5,
                    width: MediaQuery.of(context).size.width / 4 * 5,
                    // height: MediaQuery.of(context).size.height / 5 * 2.2,
                    height: MediaQuery.of(context).size.height / 5 * 2.31,
                    padding: const EdgeInsets.all(12.0),
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
                            "✔ 1번의 쇄골 중앙지점과 2번의 왼쪽 유두 사이를 "
                            "45도 각도로 가상의 선을 그을 때 3번에 해당 하는"
                            "영역 중앙부에 패치를 부착 합니다.",
                            style: TextStyle(
                              fontSize: 16,
                              color: BODY_TEXT_COLOR,
                            )),
                        SizedBox(
                          height: 25.0,
                        ),
                        Text(
                            "✔ 부착사진과 비교시, 일반적인 경우 파란색 부위(중앙 ~ 중앙하단) 근처에 부착 합니다.",
                            style: TextStyle(
                              fontSize: 16,
                              // color: BODY_TEXT_COLOR,
                            )),
                        SizedBox(
                          height: 25.0,
                        ),
                        Text(
                            "✔ X-ray 확인시 심장이 이보다 아래에 위치한 경우 "
                            "심장이 위치한 부위와 가깝게 붙이도록 합니다.",
                            style: TextStyle(
                              fontSize: 16,
                              color: BODY_TEXT_COLOR,
                            )),
                        SizedBox(
                          height: 25.0,
                        ),
                        Text("✔ 패치 부착 후 파형이 정상인지 확인 합니다.",
                            style: TextStyle(
                              fontSize: 16,
                              color: BODY_TEXT_COLOR,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  // 버튼
                  ElevatedButton(
                    onPressed: () async {
                      print("Connect 버튼 클릭");
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (_) => EcgMonitoring(),),
                      // );
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (_) => RootTab(),),
                      // );
                      //   MaterialPageRoute(builder: (_) => FlutterBlueApp(),),
                      // );
                      try {
                        if (Platform.isAndroid) {
                          await FlutterBluePlus.turnOn();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (_) => RootTab(),),
                          // );

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => Scaffold(
                          //       appBar: AppBar(
                          //         title: Text('HolmesAI 실시간 심전도',style: TextStyle(color: Colors.white),),
                          //         backgroundColor: APPBAR_COLOR,
                          //       ),
                          //       backgroundColor: Colors.black,
                          //       body: EcgChart(),
                          //     ),
                          //   ),
                          // );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ScanScreen(),
                            ),
                          );
                        }
                      } catch (e) {
                        Snackbar.show(
                            ABC.a, prettyException("Error Turning On:", e),
                            success: false);
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
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
