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
    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ConnectionInfo(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 반응형이 되도록 설정
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        // 배경 블루계열로 그라데이션 설정
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xFF000118),
            Color(0xFF03045e),
            Color(0xFF023e8a),
            Color(0xFF0077b6),
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
                SizedBox(
                  height: deviceHeight / (5 * 4),
                ),
                // heartCare 로고
                Image.asset(
                  "asset/img/misc/atPatch.png",
                  fit: BoxFit.contain,
                  width: deviceWidth / (1 * 2),
                ),
                SizedBox(
                  height: deviceHeight / (5 * 4),
                ),
                // 로딩 프로그레스 바
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_COLOR2),
                  strokeWidth: 3,
                ),
                SizedBox(
                  height: deviceHeight / (5 * 4),
                ),
                // 솔루션 모토
                const Text(
                  "Holmes AI haertCare is focusing on wearable medical\ndevices market.\nThe objective is developing next\ngeneration products for better life.",
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
                  "Version 0.1.0",
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
