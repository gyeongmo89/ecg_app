import 'dart:async';
import 'dart:math';
import 'package:ecg_app/common/const/colors2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HrChart extends StatefulWidget {
  const HrChart({super.key});

  @override
  State<HrChart> createState() => _HrChartState();
}

class _HrChartState extends State<HrChart> {
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
    const ecgInterval = Duration(milliseconds: 500);
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
    for (double i = 0; i < 21; i += 1.0) {
      newData.add(FlSpot(i, 0 + Random().nextDouble() * 4));
    }

    setState(() {
      ecgData = newData;
    });
  }

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
      ],
    );
  }

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
            strokeWidth: 2,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 2,
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
      maxX: 20,
      minY: -4,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: ecgData.isEmpty ? [FlSpot(0, 0)] : ecgData, // 초기화  // 추가
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4, // 차트 굵기
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            // show: false,    // 차트 선 아래 배경색 없게
            show: true, // 차트 선 아래 배경색 있게
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
