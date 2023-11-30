// 수정 완료( 비동기 문제 해결 완료 )
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/view/connect_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FirstLoading0 extends StatefulWidget {
  const FirstLoading0({super.key});

  @override
  State<FirstLoading0> createState() => _FirstLoading0State();
}

class _FirstLoading0State extends State<FirstLoading0> {
  // late BuildContext myContext;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () async {
      if (mounted) {
        // Check if the state is mounted before navigation
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

    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        // child: Image.asset("asset/img/logo/HolmesAI_LOGO.svg"),
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                SvgPicture.asset(
                  "asset/img/logo/HolmesAI_LOGO.svg",
                  width: 150,
                ),

                SizedBox(
                  height: 100.0,
                ),
                // SvgPicture.asset(
                //   "asset/img/logo/홈즈AI_파비콘_안1.svg",
                //   width: 60,
                // ),
                Image.asset(
                  // "asset/img/misc/HolmesCardio_2.png",
                  // fit: BoxFit.contain,
                  // width: 200.0,
                  "asset/img/icon/Cardio1.png",
                  fit: BoxFit.contain,
                  width: 180.0,
                ),
                SizedBox(
                  height: 80.0,
                ),
                // const Text(
                //   "Leader in healthcare platform",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 22,
                //     color: Colors.pinkAccent,
                //
                //   ),
                // ),
                // 로딩 프로그레스 바
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_COLOR2),
                  strokeWidth: 3,
                ),

                SizedBox(
                  height: 30.0,
                ),
                const Text(
                  "Holmes AIReport is focusing on wearable medical\ndevices market.\nThe objective is developing next\ngeneration products for better life.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                SvgPicture.asset(
                  "asset/img/logo/홈즈AI_파비콘_안1.svg",
                  width: 60,
                ),
                SizedBox(
                  height: 15.0,
                ),
                const Text(
                  "Version 0.1.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
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
