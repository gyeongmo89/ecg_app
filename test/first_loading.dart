// import 'dart:async';
// import 'package:ecg_app/common/const/colors.dart';
// import 'package:ecg_app/common/layout/default_layout.dart';
// import 'package:ecg_app/common/view/connect_info.dart';
// import 'package:flutter/material.dart';
//
// class FirstLoading extends StatelessWidget {
//   const FirstLoading({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     // 첫 페이지를 표시
//     Future.delayed(Duration(seconds: 2), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => ConnectionInfo(),
//         ),
//       );
//     });
//
//     return DefaultLayout(
//         backgroundColor: Colors.white,
//         child: SingleChildScrollView(
//           //스크롤
//           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//           //드래그 할때 키보드 내림
//           child: SafeArea(
//             top: true,
//             bottom: false,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(
//                   height: 50.0,
//                 ),
//                 _Title(),
//                 const SizedBox(
//                   height: 55.0,
//                 ),
//                 Image.asset(
//                   "asset/img/misc/firstLoading2.PNG",
//                   fit: BoxFit.contain,
//                 ),
//                 const SizedBox(
//                   height: 66.0,
//                 ),
//                 _SubInfo(),
//                 const SizedBox(
//                   height: 40.0,
//                 ),
//                 _ButtomInfo(),
//
//               ],
//             ),
//           ),
//         ));
//   }
// }
//
// class _Title extends StatelessWidget {
//   const _Title({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(
//       "asset/img/logo/HolmesAI_LOGO.png",
//       width: 350,
//       height: 150,
//       fit: BoxFit.contain,
//     );
//   }
// }
//
// class _SubInfo extends StatelessWidget {
//   const _SubInfo({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         "Holmes AIreport is focusing on wearable medical\ndevices market.\nThe objective is developing next\ngeneration products for better life.",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 15,
//           color: BODY_TEXT_COLOR,
//         ),
//       ),
//     );
//   }
// }
//
// class _ButtomInfo extends StatelessWidget {
//   const _ButtomInfo({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         "ⓒ Holmes AI Co.,Ltd. ALL Rights Reserved.",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 13,
//           color: SUB_TEXT_COLOR,
//         ),
//       ),
//     );
//   }
// }