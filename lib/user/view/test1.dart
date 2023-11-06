import 'package:flutter/material.dart';


class _SettingsScreenState extends StatefulWidget {
  const _SettingsScreenState({super.key});

  @override
  State<_SettingsScreenState> createState() => _SettingsScreenStateState();

}

class _SettingsScreenStateState extends State<_SettingsScreenState> {


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}




// import 'dart:math';
//
// import 'package:ecg_app/common/const/colors.dart';
// import 'package:ecg_app/common/layout/default_layout.dart';
// import 'package:flutter/material.dart';
//
// class Test1 extends StatelessWidget {
//   const Test1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // 탭의 개수
//       child: Scaffold(
//         appBar: AppBar(
//
//           backgroundColor: Colors.blue, // AppBar 배경색을 설정
//           title: Text('Your App Title'),
//           bottom: TabBar(
//             indicatorColor: Colors.white, // 선택된 탭의 아래선 색상
//             tabs: [
//               Tab(text: 'Tab 1'),
//               Tab(text: 'Tab 2'),
//               Tab(text: 'Tab 3'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // 탭에 따른 내용 추가
//             Center(child: Text('Tab 1 Content')),
//             Center(child: Text('Tab 2 Content')),
//             Center(child: Text('Tab 3 Content')),
//           ],
//         ),
//       ),
//     );
//
//   }
// }
