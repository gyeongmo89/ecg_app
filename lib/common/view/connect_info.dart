import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/bluetooth/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ecg_app/bluetooth/utils/snackbar.dart';

class ConnectionInfo extends StatelessWidget {
  const ConnectionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      child: Container(
        // 배경 블루계열로 그라데이션 설정
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              // // 보라핑크 계열
              //     Color(0xFF666F9A,),
              //     Color(0xFF8974A3,),
              //     Color(0xFFAB79A6,),
              //     Color(0xFFCA7FA1,),
              // 그린 계열
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
                      width: deviceWidth,  // 이미지를 원하는 가로 크기로 늘림
                      height: deviceHeight / 5,  // 이미지를 원하는 세로 크기로 늘림
                      fit: BoxFit.contain,  // 이미지가 부모 컨테이너를 완전히 채우도록 설정
                    ),
                  )
,
                  // SizedBox(
                  //   height: deviceHeight / 5 * 0.1,
                  // ),
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
                      try {
                        if (Platform.isAndroid) {
                          await FlutterBluePlus.turnOn();
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
  }
}
