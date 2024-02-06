// 2024-02-05 18:05 시작
// Patch info 화면
// Patch 정보를 보여주는 화면

import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class AboutInfo extends StatelessWidget {
  AboutInfo({Key? key}) : super(key: key);

  final List<Map<String, String>> infoList = [
    {"앱 정보": ""},
    {"제품 명": "  IheartU"},
    {"모델 명": "  HCL_M101"},
    {"최신 버전": "  Ver 1.0.0"},
    {"앱 버전": "  Ver 1.0.0\n"},
    {"제조사 정보": ""},
    {"제조사": "  HolmesAI"},
    {"본사 주소": "  서울특별시 종로구 새문안로 76\n  콘코디언빌딩 3층"},
    {"대표번호": "  070-1234-1234"},
    {"팩스": "  +82-70-1234-1234"},
    {"이메일": "  sales@holmesai.com"},
    {"홈페이지": "  https://holmesai.kr"},
  ];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    final titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      // color: Colors.black,
      color: PRIMARY_COLOR2,
    );

    final keyStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: BODY_TEXT_COLOR,
    );

    final contentStyle = TextStyle(
      fontSize: 16,
      color: BODY_TEXT_COLOR,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: deviceHeight / 30 * 1),
            //image HolmesAI 로고
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "asset/img/logo/HolmesAI_LOGO.png",
                  width: deviceWidth / 3 * 1,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: deviceWidth / 20 * 1),
                Column(
                  children: [
                    Text("IheartU",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    //image
                    Image.asset(
                      "asset/img/icon/app_icon.png",
                      width: deviceWidth / 20 * 2,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
            const Text(
              "ⓒ Holmes AI Co.,Ltd. ALL Rights Reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                // color: Colors.white60,
                color: SUB_TEXT_COLOR,
              ),
            ),
            //왼쪽정렬
            SizedBox(height: deviceHeight / 20 * 1),

            // Text(
            //   "제조사 정보",
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: deviceWidth / 4 * 5,
                  // height: deviceHeight / 5 * 2.31,
                  height: deviceHeight / 5 * 3,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xFFE6EBF0),
                      border: Border.all(
                        color: Colors.white,
                        width: deviceWidth / 4 * 0.01,
                      )),
                  child: ListView.builder(
                    itemCount: infoList.length,
                    itemBuilder: (context, index) {
                      String title = infoList[index].keys.first;
                      String content = infoList[index].values.first;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                2), // Adjust the padding to control the space between items
                        child: Container(
                          child: title == "제조사 정보" || title == "앱 정보"
                              ? Text(title, style: titleStyle)
                              : RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "• $title ", style: keyStyle),
                                      TextSpan(
                                          text: content, style: contentStyle),
                                    ],
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
