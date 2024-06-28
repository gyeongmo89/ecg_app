// 아래는 예시 1
// 병합시작
// 실시간 병합 시작 1
// 사이즈 조정 시작
import 'dart:async';
import 'dart:math';
import 'package:ecg_app/common/const/colors2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


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
          // aspectRatio: 1.70,
          aspectRatio: 2.50,
          child: LineChart(
              // showAvg ? avgData() : mainData(),
              mainData()),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      backgroundColor: Colors.black,

      clipData: const FlClipData.horizontal(),
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
          spots: ecgData.isEmpty ? [const FlSpot(0, 0)] : ecgData, // 초기화  // 추가
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
}
