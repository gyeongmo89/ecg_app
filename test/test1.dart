// if (snapshot.hasData && snapshot.data!.isEmpty) {
// if (isSameDay(widget.selectedDate, DateTime.now())) {
// // 오늘이라면
// return Center(
// child: Text(
// "오늘은 등록된 증상노트가 없습니다.",
// style: TextStyle(color: Colors.white),
// ),
// );
// } else if (isTodayOrBefore) {
// // 오늘 이전의 날짜일 경우
// return Center(
// child: Text(
// // "등록된 증상노트가 없습니다.",
// "검사가 진행되지 않은 날짜 이므로 등록할 수 없습니다.",
// style: TextStyle(color: Colors.white),
// ),
// );
// } else {
// // 오늘 이후의 날짜일 경우
// return const Center(
// child: Text(
// "등록된 증상노트가 없습니다.",
// style: TextStyle(color: Colors.white),
// ),
// );
// }
// }

// //
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: SafeArea(
//       child: Directionality(
//         textDirection: TextDirection.ltr,
//         child: LineChartSample2(),
//       ),
//     ),
//   ));
// }
//
// class LineChartSample2 extends StatefulWidget {
//   const LineChartSample2({super.key});
//
//   @override
//   State<LineChartSample2> createState() => _LineChartSample2State();
// }
//
// class _LineChartSample2State extends State<LineChartSample2> {
//   List<FlSpot> ecgData = [];
//   List<BluetoothDevice> devices = [];
//   BluetoothDevice? selectedDevice;
//   double xValue = 0;
//
//   StreamSubscription<ScanResult>? scanSubscription;
//   StreamSubscription<List<int>>? valueSubscription;
//
//   final FlutterBlue flutterBlue = FlutterBlue.instance;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Bluetooth 장치 스캔
//     scanSubscription = flutterBlue.scan().listen((scanResult) {
//       // 원하는 장치를 찾으면 연결
//       if (scanResult.device.name == 'YourDeviceName') {
//         selectedDevice = scanResult.device;
//         _connectToDevice();
//       }
//     });
//
//     // 차트 업데이트를 위한 타이머
//     const ecgInterval = Duration(milliseconds: 100);
//     Timer.periodic(ecgInterval, (timer) {
//       if (selectedDevice != null) {
//         // Bluetooth로부터 데이터를 읽어옴
//         selectedDevice!.readCharacteristic(characteristic).then((value) {
//           // 데이터를 처리하여 FlSpot 리스트 업데이트
//           final newData = List<FlSpot>.empty(growable: true);
//           // 여기서 데이터 처리를 수행하여 newData에 FlSpot 추가
//           // 예를 들어, selectedDevice에서 읽은 데이터를 파싱하고 newData에 추가
//           // newData.add(FlSpot(xValue, parsedData));
//           xValue += 1;
//           setState(() {
//             ecgData = newData;
//           });
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     scanSubscription?.cancel();
//     valueSubscription?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _connectToDevice() async {
//     await selectedDevice!.connect();
//     await selectedDevice!.discoverServices();
//     // 서비스와 캐릭터리스틱 설정
//     // 예: selectedDevice!.services, selectedDevice!.services[0].characteristics 등 설정
//     // 데이터 수신을 위한 캐릭터리스틱을 선택
//     // valueSubscription = characteristic.subsribe().listen((data) {
//     //   // 데이터를 처리하고 차트 업데이트
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AspectRatio(
//           aspectRatio: 1.70,
//           child: Padding(
//             padding: const EdgeInsets.only(
//               right: 18,
//               left: 12,
//               top: 24,
//               bottom: 12,
//             ),
//             child: LineChart(
//               showAvg ? avgData() : mainData(),
//             ),
//           ),
//         ),
//         SizedBox(
//           width: 60,
//           height: 34,
//           child: TextButton(
//             onPressed: () {
//               setState(() {
//                 showAvg = !showAvg;
//               });
//             },
//             child: Text(
//               'avg',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   LineChartData mainData() {
//     return LineChartData(
//       // 나머지 차트 설정
//       // ...
//       lineBarsData: [
//         LineChartBarData(
//           spots: ecgData,
//           isCurved: false,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 3,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   LineChartData avgData() {
//     return LineChartData(
//       // 나머지 차트 설정
//       // ...
//       lineBarsData: [
//         LineChartBarData(
//           spots: ecgData,
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: [
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!,
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!,
//             ],
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [
//                 ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                     .lerp(0.2)!
//                     .withOpacity(0.1),
//                 ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                     .lerp(0.2)!
//                     .withOpacity(0.1),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

//--------------------------------------------------------
// // 실시간 이동--------------------------------------------------------
// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: Directionality(
//       textDirection: TextDirection.ltr,
//       child: RealtimeEcgChart(),
//     ),
//   ));
// }
//
// class RealtimeEcgChart extends StatefulWidget {
//   const RealtimeEcgChart({super.key});
//
//   @override
//   State<RealtimeEcgChart> createState() => _RealtimeEcgChartState();
// }
//
// class _RealtimeEcgChartState extends State<RealtimeEcgChart> {
//   List<FlSpot> ecgData = [];
//   Timer? dataUpdateTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     startDataUpdate();
//   }
//
//   void startDataUpdate() {
//     dataUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       updateEcgData();
//     });
//   }
//
//   void updateEcgData() {
//     final random = Random();
//     final newData = List<FlSpot>.empty(growable: true);
//
//     for (double i = 0; i < 10; i += 1) {
//       newData.add(FlSpot(i, 0 + Random().nextDouble() * 4));
//     }
//
//     setState(() {
//       ecgData = newData;
//     });
//   }
//
//   @override
//   void dispose() {
//     dataUpdateTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AspectRatio(
//           aspectRatio: 1.70,
//           child: Padding(
//             padding: const EdgeInsets.only(
//               right: 18,
//               left: 12,
//               top: 24,
//               bottom: 12,
//             ),
//             child: LineChart(
//               LineChartData(
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: ecgData,
//                     isCurved: true,
//                     barWidth: 2,
//                     isStrokeCapRound: true,
//                     belowBarData: BarAreaData(show: false),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// --------------------------------------------------------
// import 'dart:async';
// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: EcgChart(),
//   ));
// }
//
// class EcgChart extends StatefulWidget {
//   @override
//   _EcgChartState createState() => _EcgChartState();
// }
//
// class _EcgChartState extends State<EcgChart> {
//   List<FlSpot> ecgData = [];
//   double xValue = 0;
//   Timer? ecgTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     startEcgSimulation();
//   }
//
//   void startEcgSimulation() {
//     const ecgInterval = Duration(milliseconds: 100);
//     ecgTimer = Timer.periodic(ecgInterval, (timer) {
//       if (mounted) {
//         setState(() {
//           ecgData.add(FlSpot(xValue, 0 + Random().nextDouble() * 0.5));
//           xValue += 0.1;
//           // if (ecgData.length > 10) {
//           //   ecgData.removeAt(0);
//           // }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     ecgTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Real-Time ECG Chart'),
//       ),
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: 1.5,
//           child: LineChart(
//             LineChartData(
//               gridData: FlGridData(show: false),
//               titlesData: FlTitlesData(show: false),
//               borderData: FlBorderData(
//                 show: true,
//                 border: Border.all(color: Colors.blue),
//               ),
//               minX: 0,
//               maxX: 10,
//               minY: -1,
//               maxY: 1,
//
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: ecgData.isEmpty ? [FlSpot(0, 0)] : ecgData,  // 초기화
//                   // spots: ecgData,
//                   // isCurved: false,
//                   isCurved: true,
//                   color: Colors.blue,
//                   belowBarData: BarAreaData(show: false),
//                   dotData: const FlDotData(
//                     show: false,
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// --------------------------------------------------------
// import 'package:flutter/material.dart';
//
//
// class _SettingsScreenState extends StatefulWidget {
//   const _SettingsScreenState({super.key});
//
//   @override
//   State<_SettingsScreenState> createState() => _SettingsScreenStateState();
//
// }
//
// class _SettingsScreenStateState extends State<_SettingsScreenState> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
//
//
//
//
// // import 'dart:math';
// //
// // import 'package:ecg_app/common/const/colors.dart';
// // import 'package:ecg_app/common/layout/default_layout.dart';
// // import 'package:flutter/material.dart';
// //
// // class Test1 extends StatelessWidget {
// //   const Test1({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 3, // 탭의 개수
// //       child: Scaffold(
// //         appBar: AppBar(
// //
// //           backgroundColor: Colors.blue, // AppBar 배경색을 설정
// //           title: Text('Your App Title'),
// //           bottom: TabBar(
// //             indicatorColor: Colors.white, // 선택된 탭의 아래선 색상
// //             tabs: [
// //               Tab(text: 'Tab 1'),
// //               Tab(text: 'Tab 2'),
// //               Tab(text: 'Tab 3'),
// //             ],
// //           ),
// //         ),
// //         body: TabBarView(
// //           children: [
// //             // 탭에 따른 내용 추가
// //             Center(child: Text('Tab 1 Content')),
// //             Center(child: Text('Tab 2 Content')),
// //             Center(child: Text('Tab 3 Content')),
// //           ],
// //         ),
// //       ),
// //     );
// //
// //   }
// // }
