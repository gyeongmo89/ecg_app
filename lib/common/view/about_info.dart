// about_info.dart: Patch 정보를 보여주는 화면

import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class AboutInfo extends StatelessWidget {
  AboutInfo({Key? key}) : super(key: key);

  final List<Map<String, String>> infoList = [
    {"앱 정보": ""},
    {"제품 명": "  CLheart"},
    {"모델 명": "  HCL_M101"},
    {"최신 버전": "  Ver 1.0.0"},
    {"앱 버전": "  Ver 1.0.0\n"},
    {"제조사 정보": ""},
    {"제조사": "  HolmesAI"},
    {"본사 주소": "  대구시 동구 동대구로 455 대구\n  스케일업 허브 465"},
    {"이메일": "  skhong@holmesai.co.kr"},
    {"홈페이지": "  www.holmesai.co.kr"},
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
            SizedBox(height: deviceHeight / 30 * 2),
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
                    Text("CLheart",
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
                color: SUB_TEXT_COLOR,
              ),
            ),
            SizedBox(height: deviceHeight / 20 * 2),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: deviceWidth / 4 * 5,
                  height: deviceHeight / 5 * 2.5,
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
                        padding: EdgeInsets.symmetric(vertical: 2),
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
