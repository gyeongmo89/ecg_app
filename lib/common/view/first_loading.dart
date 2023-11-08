// 화면이동 테스트 1

import 'dart:async';

import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/component/custom_text_form_field.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/common/view/connect_info.dart';
import 'package:flutter/material.dart';

class FirstLoading extends StatelessWidget {
  const FirstLoading({super.key});

  @override
  Widget build(BuildContext context) {

    // 첫 페이지를 표시
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ConnectionInfo(),
        ),
      );
    });

    return DefaultLayout(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          //스크롤
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          //드래그 할때 키보드 내림
          child: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                const SizedBox(
                  height: 50.0,
                ),
                _Title(),
                const SizedBox(
                  height: 55.0,
                ),
                // const CircularProgressIndicator(
                //   color: Colors.red,
                // ),
                Image.asset(
                  "asset/img/misc/firstLoading2.PNG",
                  // width: 200,
                  // height: 100,
                  fit: BoxFit.contain,
                  // width: MediaQuery.of(context).size.width/3*2,
                ),

                const SizedBox(
                  height: 66.0,
                ),
                _SubInfo(),
                const SizedBox(
                  height: 40.0,
                ),
                _ButtomInfo(),
                // _SubInfo(),
                // CustomTextFormField(
                //   hintText: "성명을 입력해주세요.",
                //   onChanged: (String value) {},
                // ),
                // const SizedBox(
                //   height: 16.0,
                // ),
                // CustomTextFormField(
                //   hintText: "환자식별 코드를 입력해주세요.",
                //   onChanged: (String value) {},
                //   obscureText: true,
                // ),
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     primary: PRIMARY_COLOR,
                //   ),
                //   child: Text(
                //     "Next",
                //   ),
                // ),
                // const SizedBox(
                //   height: 16.0,
                // ),
                // TextButton(
                //   onPressed: () {},
                //   style: TextButton.styleFrom(
                //     primary: Colors.black,
                //   ),
                //   child: Text(
                //     "회원가입",
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "asset/img/logo/HolmesAI PNG.png",
      width: 350,
      height: 150,
      fit: BoxFit.contain,
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       "환영합니다.",
//       style: TextStyle(
//         fontSize: 34,
//         fontWeight: FontWeight.w500,
//         color: Colors.black,
//       ),
//     );
//   }
// }

class _SubInfo extends StatelessWidget {
  const _SubInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Holmes AIreport is focusing on wearable medical\ndevices market.\nThe objective is developing next\ngeneration products for better life.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: BODY_TEXT_COLOR,
        ),
      ),
    );
  }
}

class _ButtomInfo extends StatelessWidget {
  const _ButtomInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "ⓒ Holmes AI Co.,Ltd. ALL Rights Reserved.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: SUB_TEXT_COLOR,
        ),
      ),
    );
  }
}
//
// class _FirstLoadingDelayedState extends State<FirstLoadingDelayed> {
//   @override
//   void initState() {
//     super.initState();
//
//     // ConnectionInfo 실행 후 2초 후에 다음 작업 수행
//     Timer(Duration(seconds: 2), () {
//       ConnectionInfo();
//     }
//       // 여기에서 원하는 다음 작업을 수행하면 됩니다.
//     });
//   }
