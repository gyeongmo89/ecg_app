// 2024-05-02 12:55 HR 차트 수정 시작 1
// 2024-05-09 16:49 HR 차트 수정 시작 2
import 'dart:async';
import 'package:ecg_app/common/const/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HrChart extends StatefulWidget {
  final double bpm;

  const HrChart({required this.bpm, Key? key}) : super(key: key);
  @override
  State<HrChart> createState() => _HrChartState();
}

class _HrChartState extends State<HrChart> {
  List<FlSpot> ecgData = [];
  double xValue = 0;
  Timer? ecgTimer;
  List<FlSpot> bpm = [];
  List<FlSpot> spots = [];
  double? lastBpm; // 이전 widget.bpm 값을 저장할 변수 추가

  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  bool showAvg = false;
  @override
  void initState() {
    super.initState();
    startEcgSimulation();
    updateEcgData();
  }

  void startEcgSimulation() {
    const ecgInterval = Duration(milliseconds: 500);
    ecgTimer = Timer.periodic(ecgInterval, (timer) {
      print("정기적 업데이트");
      updateEcgData();
    });
  }

  void updateEcgData() {
    setState(() {
      // 새로운 bpm 값을 spots 리스트의 오른쪽에 추가
      if (widget.bpm != lastBpm) {
        // 값이 다르면 spots 리스트에 새로운 FlSpot 객체를 추가
        spots.add(FlSpot(xValue++, widget.bpm));
        lastBpm = widget.bpm; // 이전 widget.bpm 값 업데이트
      }
      // spots 리스트의 크기가 21을 초과하면 왼쪽에서 데이터를 제거
      if (spots.length > 21) {
        spots.removeAt(0);

        // 모든 FlSpot의 x 좌표를 1씩 감소시켜 왼쪽으로 이동
        for (int i = 0; i < spots.length; i++) {
          spots[i] = FlSpot(i.toDouble(), spots[i].y);
          // spots[i] = FlSpot(spots[i].x - 1, spots[i].y);
        }
      }
    });
  }

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
          aspectRatio: 2.35, //차트 높이
          child: LineChart(mainData()),
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
            color: Colors.white,
            strokeWidth: 0.2,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
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
      minY: -4, // Y축의 최소값을 설정
      maxY: 200.0, // Y축의 최대값을 설정
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
      ],
    );
  }
}
