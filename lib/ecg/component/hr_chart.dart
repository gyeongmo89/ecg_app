// 2024-05-02 12:55 HR 차트 수정 시작 1
// 2024-05-09 16:49 HR 차트 수정 시작 2
import 'dart:async';
import 'dart:math';
import 'package:ecg_app/common/const/colors2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HrChart extends StatefulWidget {
  final double bpm;

  // const HrChart({super.key});
  const HrChart({required this.bpm, Key? key}) : super(key: key);
  @override
  State<HrChart> createState() => _HrChartState();
}

class _HrChartState extends State<HrChart> {
  List<FlSpot> ecgData = []; // 추가
  double xValue = 0; // 추가
  Timer? ecgTimer; // 추가
  List<FlSpot> bpm = []; // 추가
  List<FlSpot> spots = []; // 추가
  double? lastBpm;  // 이전 widget.bpm 값을 저장할 변수 추가

  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    // AppColors.contentColorPurple,
    // AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  bool showAvg = false;
  // 추가 --------------------------------------------------
  @override
  void initState() {
    super.initState();
    startEcgSimulation();
    updateEcgData(); // Call updateEcgData here
    print('이닛bpm: ${widget.bpm}, ${widget.bpm.runtimeType}');
  }

  void startEcgSimulation() {
    // const ecgInterval = Duration(milliseconds: 500);
    const ecgInterval = Duration(milliseconds: 500);
    ecgTimer = Timer.periodic(ecgInterval, (timer) {
      print("정기적 업데이트");
      updateEcgData();
      // if (ecgData.length > 100) {
      //   ecgData.removeAt(0);
      // }
    });
  }

  void updateEcgData() {
    setState(() {
      // 새로운 bpm 값을 spots 리스트의 오른쪽에 추가합니다.
      if (widget.bpm != lastBpm) {
        // 값이 다르면 spots 리스트에 새로운 FlSpot 객체를 추가합니다.
        spots.add(FlSpot(xValue++, widget.bpm));
        lastBpm = widget.bpm;  // 이전 widget.bpm 값 업데이트
        print("프린트 spots: $spots");
        print("lastBpm: $lastBpm");
      }
      // spots 리스트의 크기가 21을 초과하면 왼쪽에서 데이터를 제거합니다.
      if (spots.length > 21) {
        spots.removeAt(0);

        // 모든 FlSpot의 x 좌표를 1씩 감소시켜 왼쪽으로 이동시킵니다.
        for (int i = 0; i < spots.length; i++) {
          // spots[i] = FlSpot(spots[i].x - 1, spots[i].y);
          spots[i] = FlSpot(i.toDouble(), spots[i].y);
        }
      }
      // ecgData = newData;
    });
  }

  // void updateEcgData() {
  //   final newData = List<FlSpot>.empty(growable: true);
  //   print("Update ECG Data");
  //   for (double i = 0; i < 21; i += 1.0) {
  //     // newData.add(FlSpot(i, widget.bpm));
  //     newData.add(FlSpot(i, widget.bpm - 1));
  //   }
  //
  //   setState(() {
  //     ecgData = newData;
  //   });
  // }

  // void updateEcgData() {
  //   final random = Random();
  //
  //   final newData = List<FlSpot>.empty(growable: true);
  //
  //   // for (double i = 0; i < 11; i += 0.2) {
  //   for (double i = 0; i < 21; i += 1.0) {
  //     newData.add(FlSpot(i, 0 + Random().nextDouble() * 4));
  //   }
  //
  //   setState(() {
  //     ecgData = newData;
  //   });
  // }

  @override
  void dispose() {
    ecgTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build bpm: ${widget.bpm}, ${widget.bpm.runtimeType}');
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2.35,  //차트 높이
          child: LineChart(
              mainData()),
        ),
      ],
    );
  }
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      // fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'bpm';
        break;
      case 35:
        text = '40';
        break;
      case 75:
        text = '80';
        break;
      case 115:
        text = '120';
        break;
      case 155:
        text = '160';
        break;
      case 195:
        text = '200';
        break;
      default:
        // return Container();
        return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: style, textAlign: TextAlign.center),
      ],
    );
  }





  LineChartData mainData() {
    print(
        'LineChartData mainData() bpm: ${widget.bpm}, ${widget.bpm.runtimeType}');
    return LineChartData(
      backgroundColor: Colors.black,
      clipData: FlClipData.horizontal(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 2,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            // color: AppColors.mainGridLineColor,
            color: Colors.white,
            strokeWidth: 0.2,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            // color: AppColors.mainGridLineColor,
            color: Colors.white,
            strokeWidth: 0.2,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 42,
            ),
          ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            // reservedSize: 42,
            reservedSize: 25,
          ),
        ),
      ),

      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 20,
      // minY: -4,
      // maxY: 10,
      minY: -4, // Y축의 최소값을 설정합니다.
      maxY: 200.0, // Y축의 최대값을 설정합니다.
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            21,
                (i) => FlSpot(i.toDouble(), i < spots.length ? spots[i].y : 0.0),
          ),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        )
        // LineChartBarData(
        //   // spots: [FlSpot(0, widget.bpm-80)],
        //   isCurved: true,
        //   gradient: LinearGradient(
        //     colors: gradientColors,
        //   ),
        //   // barWidth: 4, // 차트 굵기
        //   barWidth: 2, // 차트 굵기
        //   isStrokeCapRound: true,
        //   // isStrokeCapRound: false,
        //   dotData: const FlDotData(
        //     show: false,
        //   ),
        //   belowBarData: BarAreaData(
        //     // show: false,    // 차트 선 아래 배경색 없게
        //     show: true, // 차트 선 아래 배경색 있게
        //     gradient: LinearGradient(
        //       colors: gradientColors
        //           .map((color) => color.withOpacity(0.3))
        //           .toList(),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
