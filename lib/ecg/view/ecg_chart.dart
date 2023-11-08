// 아래는 예시 1
// 병합시작
// 실시간 병합 시작 1
// 사이즈 조정 시작
import 'dart:async';
import 'dart:math';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/const/colors2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: SafeArea(
//       child: Directionality(
//         textDirection: TextDirection.ltr, // 또는 TextDirection.rtl, 앱의 텍스트 방향을 설정
//         child: LineChartSample2(),
//       ),
//     ),
//   ));
// }
// //
// //
// //
// // void main(){
// //   runApp(const LineChartSample2());
// // }

class EcgChart extends StatefulWidget {
  const EcgChart({super.key});

  @override
  State<EcgChart> createState() => _EcgChartState();
}

class _EcgChartState extends State<EcgChart> {
  List<FlSpot> ecgData = []; // 추가
  double xValue = 0; // 추가
  Timer? ecgTimer; // 추가

  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  bool showAvg = false;
  // 추가 --------------------------------------------------
  @override
  void initState() {
    super.initState();
    startEcgSimulation();
  }

  void startEcgSimulation() {
    const ecgInterval = Duration(milliseconds: 200);
    ecgTimer = Timer.periodic(ecgInterval, (timer) {
      updateEcgData();
      // if (ecgData.length > 100) {
      //   ecgData.removeAt(0);
      // }
    });
  }

  void updateEcgData() {
    final random = Random();

    final newData = List<FlSpot>.empty(growable: true);

    // for (double i = 0; i < 11; i += 0.2) {
    for (double i = 0; i < 50; i += 0.2) {
      newData.add(FlSpot(i, 0 + Random().nextDouble() * 4));
    }

    setState(() {
      ecgData = newData;
    });
  }

  // void startEcgSimulation() {
  //   const ecgInterval = Duration(milliseconds: 100);
  //   ecgTimer = Timer.periodic(ecgInterval, (timer) {
  //     if (mounted) {
  //       setState(() {
  //         // ecgData.add(FlSpot(xValue, 0 + Random().nextDouble() * 0.5));
  //         ecgData.add(FlSpot(xValue, 0 + Random().nextDouble() * 4));
  //         // xValue += 0.1;
  //         xValue += 0.1;
  //         // if (ecgData.length > 100) {
  //         //   ecgData.removeAt(0);
  //         // }
  //       });
  //     }
  //   });
  // }
  // 추가 --------------------------------------------------
  @override
  void dispose() {
    ecgTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: LineChart(
              // showAvg ? avgData() : mainData(),
              mainData()),
        ),
        // SizedBox(
        //   width: 60,
        //   height: 34,
        //   child: TextButton(
        //     onPressed: () {
        //       setState(() {
        //         showAvg = !showAvg;
        //       });
        //     },
        //     child: Text(
        //       '',//avg
        //       style: TextStyle(
        //         fontSize: 12,
        //         color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     // fontWeight: FontWeight.bold,
  //     color: Colors.white,
  //     fontSize: 16,
  //   );
  //   Widget text;
  //   switch (value.toInt()) {
  //   // case 2:
  //   //   text = const Text('MAR', style: style);
  //   //   break;
  //   // case 5:
  //   //   text = const Text('JUN', style: style);
  //   //   break;
  //     case 10:
  //       text = const Text('', style: style);  //sec
  //       break;
  //     default:
  //       text = const Text('', style: style);
  //       break;
  //   }
  //
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     child: text,
  //   );
  // }

  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     // fontWeight: FontWeight.bold,
  //     color: Colors.white,
  //     fontSize: 15,
  //   );
  //   String text;
  //   switch (value.toInt()) {
  //   // case 1:
  //   //   text = '10K';
  //   //   break;
  //   // case 3:
  //   //   text = '30k';
  //   //   break;
  //     case 6:
  //       text = ''; // mv
  //       break;
  //     default:
  //       return Container();
  //   }
  //
  //   return Text(text, style: style, textAlign: TextAlign.right);
  // }

  LineChartData mainData() {
    return LineChartData(
      backgroundColor: Colors.black,

      clipData: FlClipData.horizontal(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(
        show: false,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        // bottomTitles: AxisTitles(
        //   sideTitles: SideTitles(
        //     showTitles: true,
        //     reservedSize: 30,
        //     interval: 1,
        //     getTitlesWidget: bottomTitleWidgets,
        //   ),
        // ),
        // leftTitles: AxisTitles(
        //   sideTitles: SideTitles(
        //     showTitles: true,
        //     interval: 1,
        //     getTitlesWidget: leftTitleWidgets,
        //     reservedSize: 42,
        //   ),
        // ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: ecgData.isEmpty ? [FlSpot(0, 0)] : ecgData, // 초기화  // 추가

          // spots: const [
          //   FlSpot(0, 3),
          //   FlSpot(2.6, 2),
          //   FlSpot(4.9, 5),
          //   FlSpot(6.8, 3.1),
          //   FlSpot(8, 4),
          //   FlSpot(9.5, 3),
          //   FlSpot(11, 4),
          // ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2, // 차트 굵기
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            // show: false,    // 차트 선 아래 배경색 없게
            show: false, // 차트 선 아래 배경색 있게
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // LineChartData avgData() {
  //   return LineChartData(
  //     lineTouchData: const LineTouchData(enabled: false),
  //     gridData: FlGridData(
  //       show: true,
  //       drawHorizontalLine: true,
  //       verticalInterval: 1,
  //       horizontalInterval: 1,
  //       getDrawingVerticalLine: (value) {
  //         return const FlLine(
  //           color: Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //       getDrawingHorizontalLine: (value) {
  //         return const FlLine(
  //           color: Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //     ),
  //     // titlesData: FlTitlesData(
  //     //   show: true,
  //     //   bottomTitles: AxisTitles(
  //     //     sideTitles: SideTitles(
  //     //       showTitles: true,
  //     //       reservedSize: 30,
  //     //       getTitlesWidget: bottomTitleWidgets,
  //     //       interval: 1,
  //     //     ),
  //     //   ),
  //     //   leftTitles: AxisTitles(
  //     //     sideTitles: SideTitles(
  //     //       showTitles: true,
  //     //       getTitlesWidget: leftTitleWidgets,
  //     //       reservedSize: 42,
  //     //       interval: 1,
  //     //     ),
  //     //   ),
  //     //   topTitles: const AxisTitles(
  //     //     sideTitles: SideTitles(showTitles: false),
  //     //   ),
  //     //   rightTitles: const AxisTitles(
  //     //     sideTitles: SideTitles(showTitles: false),
  //     //   ),
  //     // ),
  //     borderData: FlBorderData(
  //       show: true,
  //       border: Border.all(color: const Color(0xff37434d)),
  //     ),
  //     minX: 0,
  //     maxX: 11,
  //     minY: 0,
  //     maxY: 6,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: const [
  //           FlSpot(0, 3.44),
  //           FlSpot(2.6, 3.44),
  //           FlSpot(4.9, 3.44),
  //           FlSpot(6.8, 3.44),
  //           FlSpot(8, 3.44),
  //           FlSpot(9.5, 3.44),
  //           FlSpot(11, 3.44),
  //         ],
  //         isCurved: true,
  //         gradient: LinearGradient(
  //           colors: [
  //             ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                 .lerp(0.2)!,
  //             ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                 .lerp(0.2)!,
  //           ],
  //         ),
  //         barWidth: 5,
  //         isStrokeCapRound: true,
  //         dotData: const FlDotData(
  //           show: false,
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           gradient: LinearGradient(
  //             colors: [
  //               ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                   .lerp(0.2)!
  //                   .withOpacity(0.1),
  //               ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                   .lerp(0.2)!
  //                   .withOpacity(0.1),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
