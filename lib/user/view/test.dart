// {"success":true,"data":[
// {"codeGroupKey":4,"codeKey":9,"codeValue":"Chest discomfort","removeYn":false},
// {"codeGroupKey":4,"codeKey":10,"codeValue":"Discomfort int the arms, neck, chin, etc.","removeYn":false},
// {"codeGroupKey":4,"codeKey":11,"codeValue":"Palpitaition(rapid heartbeat)","removeYn":false},
// {"codeGroupKey":4,"codeKey":12,"codeValue":"Shortness of Breath","removeYn":false},
// {"codeGroupKey":4,"codeKey":13,"codeValue":"Dizziness","removeYn":false},
// {"codeGroupKey":4,"codeKey":14,"codeValue":"Fatigue","removeYn":false},
// {"codeGroupKey":4,"codeKey":21,"codeValue":"ETC","removeYn":false}
// ],"error":null}
//
// int chestDiscomfortKey =
// dataList[0]['codeKey']; // 1번째 {}의 codeKey, 가슴 불편함
// int discomfortArmsNeckChinEtcKey =
// dataList[1]['codeKey']; // 2번째 {}의 codeKey, 팔, 목, 턱 등이 불편함
// int palpitaitionRapidHeartbeat =
// dataList[2]['codeKey']; // 3번째 {}의 codeKey, 심계항진(빠른 심장박동)
// int shortnessOfBreath =
// dataList[3]['codeKey']; // 4번째 {}의 codeKey, 호흡곤란
// int dizziness = dataList[4]['codeKey']; // 5번째 {}의 codeKey, 현기증
// int fatigue = dataList[5]['codeKey']; // 6번째 {}의 codeKey, 현기증
// int etc = dataList[6]['codeKey']; // 7번째 {}의 codeKey, 기타
//----------------------
// {"success":true,"data":[{"codeGroupKey":5,"codeKey":15,"codeValue":"Work (physical activity)","removeYn":false},  //업무(육체활동)
// {"codeGroupKey":5,"codeKey":16,"codeValue":"Work (non-physical activity)","removeYn":false},  //업무(비 육체활동)
// {"codeGroupKey":5,"codeKey":17,"codeValue":"Activities such as watching TV and reading","removeYn":false},  // TV 시청, 독서 등의 활동
// {"codeGroupKey":5,"codeKey":18,"codeValue":"Walking","removeYn":false}, // 걷기
// {"codeGroupKey":5,"codeKey":19,"codeValue":"Running","removeYn":false}, // 달리기
// {"codeGroupKey":5,"codeKey":20,"codeValue":"Housework","removeYn":false}, // 집안일
// {"codeGroupKey":5,"codeKey":22,"codeValue":"ETC","removeYn":false}],"error":null} // 기타
//
// // -- 증상선택 공통 코드 변수--
// int workPhysicalActivityKey = codeKeys[0]; // 업무(육체활동)
// int workNonPhysicalActivityKey = codeKeys[1];  // 업무(비 육체활동)
// int watchingTVReadingKey = codeKeys[2];  // TV 시청, 독서 등의 활동
// int walkingKey = codeKeys[3]; // 걷기
// int runningKey = codeKeys[4]; // 달리기
// int houseworkKey = codeKeys[5]; // 집안일
// int activityEtcKey = codeKeys[6]; // 기타

// import 'package:ecg_app/common/const/colors.dart';
// import 'package:ecg_app/common/layout/default_layout.dart';
// import 'package:flutter/material.dart';
//
//
// void main() => runApp(const MaterialApp(
//   home: SymptomRegistration(),
// ));
//
// class SymptomRegistration extends StatelessWidget {
//   const SymptomRegistration({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     double deviceHeight = MediaQuery.of(context).size.height;
//     double deviceWidth = MediaQuery.of(context).size.width;
//     return const DefaultLayout(
//
//         child: Padding(
//           padding: EdgeInsets.all(14.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Registration",
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                       color: BODY_TEXT_COLOR,
//                     ),
//                   ),
//                   Text("Symptom",
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         color: SUB_TEXT_COLOR,
//                       ))
//                 ],
//               ),
//               RadioButtonWidget(),
//               // Row(
//               //   children: [
//               //     // RadioButtonWidget(),
//               //
//               //   ],
//               // )
//             ],
//           ),
//         ));
//   }
// }
//
// enum SymptomName { Symptom1, Symptom2, Symptom3, Symptom4 }
//
// /// This is the stateful widget that the main application instantiates.
// class RadioButtonWidget extends StatefulWidget {
//   const RadioButtonWidget({Key? key}) : super(key: key);
//
//   @override
//   State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
// }
//
// /// This is the private State class that goes with MyStatefulWidget.
// class _RadioButtonWidgetState extends State<RadioButtonWidget> {
// //처음에는 사과가 선택되어 있도록 Apple로 초기화 -> groupValue에 들어갈 값!
//   SymptomName? _symptom = SymptomName.Symptom1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//
//       children: <Widget>[
//         ListTile(
//           //ListTile - title에는 내용,
//           //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
//           title: const Text("두근거림"),
//           leading: Radio<SymptomName>(
//             value: SymptomName.Symptom1,
//             groupValue: _symptom,
//             onChanged: (SymptomName? value) {
//               setState(() {
//                 _symptom = value;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           title: const Text('불안감'),
//           leading: Radio<SymptomName>(
//             value: SymptomName.Symptom2,
//             groupValue: _symptom,
//             onChanged: (SymptomName? value) {
//               setState(() {
//                 _symptom = value;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           title: const Text('어지러움'),
//           leading: Radio<SymptomName>(
//             value: SymptomName.Symptom3,
//             groupValue: _symptom,
//             onChanged: (SymptomName? value) {
//               setState(() {
//                 _symptom = value;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           title: const Text('흉통 또는 불편감'),
//           leading: Radio<SymptomName>(
//             value: SymptomName.Symptom4,
//             groupValue: _symptom,
//             onChanged: (SymptomName? value) {
//               setState(() {
//                 _symptom = value;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           //ListTile - title에는 내용,
//           //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
//           title: const Text("두근거림"),
//           leading: Radio<SymptomName>(
//             value: SymptomName.Symptom1,
//             groupValue: _symptom,
//             onChanged: (SymptomName? value) {
//               setState(() {
//                 _symptom = value;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           title: const Text('불안감'),
//           leading: Radio<SymptomName>(
//             value: SymptomName.Symptom2,
//             groupValue: _symptom,
//             onChanged: (SymptomName? value) {
//               setState(() {
//                 _symptom = value;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           title: const Text('어지러움'),
//           leading: Radio<SymptomName>(
//             value: SymptomName.Symptom3,
//             groupValue: _symptom,
//             onChanged: (SymptomName? value) {
//               setState(() {
//                 _symptom = value;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           title: const Text('흉통 또는 불편감'),
//           leading: Radio<SymptomName>(
//             value: SymptomName.Symptom4,
//             groupValue: _symptom,
//             onChanged: (SymptomName? value) {
//               setState(() {
//                 _symptom = value;
//               });
//             },
//           ),
//         ),
//
//
//       ],
//     );
//
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// //
// // void main() => runApp(MaterialApp(
// //   home: AddItemApp(),
// // ));
// //
// // class AddItemApp extends StatefulWidget {
// //   @override
// //   _AddItemAppState createState() => _AddItemAppState();
// // }
// //
// // class _AddItemAppState extends State<AddItemApp> {
// //   List<String> items = [];
// //   String newItem = '';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Items'),
// //       ),
// //       body: ListView.builder(
// //         itemCount: items.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text(items[index]),
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           showDialog(
// //             context: context,
// //             builder: (context) {
// //               return AlertDialog(
// //                 title: Text('Add New Item'),
// //                 content: TextField(
// //                   onChanged: (value) {
// //                     newItem = value;
// //                   },
// //                 ),
// //                 actions: [
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       setState(() {
// //                         items.add(newItem);
// //                       });
// //                       Navigator.of(context).pop();
// //                     },
// //                     child: Text('Add'),
// //                   ),
// //                 ],
// //               );
// //             },
// //           );
// //         },
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
