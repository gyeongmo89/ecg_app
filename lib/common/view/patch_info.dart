// 2024-02-05 18:05 시작
// Patch info 화면
// Patch 정보를 보여주는 화면

import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class PatchInfo extends StatelessWidget {
  PatchInfo({Key? key}) : super(key: key);

  final List<Map<String, String>> infoList = [
    {"패치 정보": ""},
    {"제품 명": "CLtime"},
    {"사용목적": "심전도 측정"},
    {"모델명": "HCL_C101"},
    {"제조사": "Holmes AI"},
    {"품목인증번호": "제인 24-1234호"},
    {"제조업 허가 번호": "제 1234호"},
    {"중량 및 포장 단위": "12g 이하 개별포장 1EA"},
    {"정격에 대한 보호 형식 및 보호정도": "  내부 전원형 기기, BF형 장착부"},
    {"정격 전압 및 정격 주파수": "DC 3V"},
    {"최대 측정 가능시간": "200 시간"},
    {"제품문의": "070-1234-1234"},
    {"본 제품은 의료기기 입니다.": ""}
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
        title: const Text('Patch Info'),
      ),
      body: Center(
        child: Column(
          children: [
            //image
            SizedBox(height: deviceHeight / 30 * 1),
            Row(
              children: [
                Image.asset(
                  "asset/img/misc/heartCare1.png",
                  width: deviceWidth / 2 * 1,
                  fit: BoxFit.fill,
                ),
                //input image mountingPosition_3.png
                // Image.asset(
                //   "asset/img/misc/heartCare2.png",
                //   width: deviceWidth / 1.5 * 1,
                //   fit: BoxFit.contain,
                // ),
                Image.asset(
                  "asset/img/misc/heartCare2.png",
                  width: deviceWidth / 2 * 1,
                  fit: BoxFit.fill,
                ),
              ],
            ),
            //왼쪽정렬
            SizedBox(height: deviceHeight / 30 * 1),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: deviceWidth / 4 * 5,
                  // height: deviceHeight / 5 * 2.31,
                  height: deviceHeight / 5 * 2.8,
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
                          child: title == "패치 정보"
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
