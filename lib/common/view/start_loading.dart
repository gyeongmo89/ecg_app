import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/view/connect_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StartLoading extends StatefulWidget {
  const StartLoading({super.key});

  @override
  State<StartLoading> createState() => _StartLoadingState();
}

class _StartLoadingState extends State<StartLoading> {
  @override
  void initState() {
    super.initState();
    // 2초간 로딩후 화면 전환
    Future.delayed(Duration(seconds: 2), () async {
      if (mounted) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ConnectionInfo(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        // 배경 그린계열로 그라데이션 설정
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xFF0DB2B2,),
            Color(0xFF00A2C8,),
            Color(0xFF0D8CD0,),
            Color(0xFF6C70C1,),
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight / (5 * 4),
                ),
                // 홈즈AI 로고
                SvgPicture.asset(
                  "asset/img/logo/HolmesAI_LOGO.svg",
                  width: deviceWidth / (3 * 1),
                ),
                // 패치 로고
                Image.asset(
                  "asset/img/misc/heartCare1.png",
                  // "asset/img/misc/atPatch.png",
                  fit: BoxFit.contain,
                  width: deviceWidth / (1.0),
                ),
                // 로딩 프로그레스 바
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_COLOR2),
                  strokeWidth: 3,
                ),
                SizedBox(
                  height: deviceHeight / (30),
                ),
                // 솔루션 모토(경쟁사 모토를 참고 한 멘트이므로 향후 변경을 권장함)
                const Text(
                  "Holmes AI CLtime is focusing on wearable\nmedical devices market.\nThe objective is developing next\ngeneration products for better life.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: deviceHeight / (5 * 4),
                ),
                // 하트 아이콘
                SvgPicture.asset(
                  "asset/img/icon/favicon.svg",
                  width: deviceWidth / (2 * 4),
                ),
                SizedBox(
                  height: deviceHeight / (5 * 4),
                ),
                // 버전 정보
                const Text(
                  "Version 1.0.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(
                  height: deviceHeight / (8 * 6),
                ),
                // 저작권 정보
                const Text(
                  "ⓒ Holmes AI Co.,Ltd. ALL Rights Reserved.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
