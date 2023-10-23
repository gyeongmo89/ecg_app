import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:ecg_app/common/view/first_loading.dart';
import 'package:ecg_app/user/view/test.dart';
import 'package:flutter/material.dart';

class ConnectionInfo extends StatelessWidget {
  const ConnectionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        child: SafeArea(
          top: true,
          bottom: false,
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 홈즈 AI 로고
                Image.asset(
                  "asset/img/logo/HolmesAI PNG.png",
                  width: MediaQuery.of(context).size.width / 3 * 1,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                
                // 카디오 로고
                Image.asset(
                  "asset/img/misc/Cardio1.png",
                  width: MediaQuery.of(context).size.width / 4 * 2,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                
                // 사용설명 박스
                Container(
                  width: MediaQuery.of(context).size.width / 3 * 5,
                  height: MediaQuery.of(context).size.height / 6 * 2,
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
                          "1. Holmes Cardio를 앱에 등록하기 위해,\n"
                          "전원을 켜주세요.",
                          style: TextStyle(
                            fontSize: 16,
                            color: BODY_TEXT_COLOR,
                          )),
                      SizedBox(
                        height: 35.0,
                      ),
                      Text(
                          "2. 패치의 전원을 3초이상 누르면, 소리와 함께\n"
                          "버튼의 색상이 노란색으로 3번 깜빡 거립니다.",
                          style: TextStyle(
                            fontSize: 16,
                            color: BODY_TEXT_COLOR,
                          )),
                      SizedBox(
                        height: 35.0,
                      ),
                      Text("3. Connect 버튼을 눌러 페어링 합니다.",
                          style: TextStyle(
                            fontSize: 16,
                            color: BODY_TEXT_COLOR,
                          )),

                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                // 버튼
                ElevatedButton(
                  onPressed: (){
                    print("Connect 버튼 클릭");
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (_) => EcgMonitoring(),),
                    // );
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RootTab(),),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                        primary: PRIMARY_COLOR,
                    fixedSize: Size(400, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )
                      ),
                  child: Text(
                    "Connect",
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
    );
  }
}
