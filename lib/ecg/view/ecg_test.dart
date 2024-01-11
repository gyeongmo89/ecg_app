import 'dart:async';
import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class EcgChartPainter extends CustomPainter {
  final List<double> ecgData;

  EcgChartPainter(this.ecgData);

  @override
  void paint(Canvas canvas, Size size) {
    final double chartWidth = size.width;
    final double chartHeight = size.height;
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey
    // 배경색을 회색으로 설정
      ..strokeWidth = 0.5;

    final Paint thickGridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0; // 중앙 정사각형을 두껍게 그리기 위한 페인트

    final Paint thinGridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.3; // 작은 정사각형을 얇게 그리기 위한 페인트



    final Paint chartPaint = Paint()
      // ..color = Colors.red // 차트를 빨간색으로 설정
      // ..color = Color(0xFF30AFF9) // 차트를 빨간색으로 설정
      // ..color = Colors.pinkAccent // 차트를 빨간색으로 설정
      // ..color = Colors.green // 차트를 빨간색으로 설정
      ..color = Color(0xFF57da74) // 차트를 빨간색으로 설정

      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final double dataSpacing = chartWidth / ecgData.length;

    // 배경을 그리는 부분
    for (double i = 0; i < chartWidth; i += 10) {
      if ((i / 10).round() % 5 == 0) {
        canvas.drawLine(Offset(i, 0), Offset(i, chartHeight), thickGridPaint);
      } else {
        canvas.drawLine(Offset(i, 0), Offset(i, chartHeight), thinGridPaint);
      }
    }

    for (double i = 0; i < chartHeight; i += 10) {
      if ((i / 10).round() % 5 == 0) {
        canvas.drawLine(Offset(0, i), Offset(chartWidth, i), thickGridPaint);
      } else {
        canvas.drawLine(Offset(0, i), Offset(chartWidth, i), thinGridPaint);
      }
    }


    final Path path = Path();
    if (ecgData.isNotEmpty) {
      path.moveTo(0, chartHeight * (1 - ecgData.first / 2)); // 시작 위치를 조정합니다

      for (int i = 1; i < ecgData.length; i++) {
        final double x = i * dataSpacing;
        final double y = chartHeight * (1 - ecgData[i] / 2);
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, chartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class EcgChart2 extends StatefulWidget {
  @override
  _EcgChartState createState() => _EcgChartState();
}

class _EcgChartState extends State<EcgChart2> {
  List<double> ecgData = [];
  Timer? timer;
  int dataIndex = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const interval = Duration(milliseconds: 20);
    timer = Timer.periodic(interval, (timer) {
      final double value = _generateEcgData();
      setState(() {
        ecgData.add(value);
        if (ecgData.length > 100) {
          ecgData.removeAt(0);
        }
      });
      _calculateHeartRate(ecgData); // 심박수 계산 메서드 호출
    });
  }

  double _generateEcgData() {
    final List<double> sampleData = [
      0.48, 0.47, 0.5, 0.51, 0.5, 0.51, 0.49, 0.52, 0.51, 0.52, 0.52, 0.51, 0.51, 0.51, 0.51, 0.51, 0.49, 0.51, 0.51, 0.54, 0.52, 0.5, 0.54, 0.52, 0.52, 0.53, 0.53, 0.54, 0.53, 0.53, 0.55, 0.55, 0.62, 0.63, 0.64, 0.66, 0.61, 0.6, 0.58, 0.56, 0.54, 0.52, 0.56, 0.53, 0.54, 0.56, 0.54, 0.57, 0.56, 0.55, 0.56, 0.74, 1.26, 1.36, 0.69, 0.66, 0.63, 0.65, 0.62, 0.61, 0.61, 0.59, 0.63, 0.6, 0.61, 0.64, 0.64, 0.67, 0.67, 0.69, 0.71, 0.7, 0.74, 0.75, 0.76, 0.8, 0.79, 0.81, 0.81, 0.81, 0.8, 0.75, 0.72, 0.68, 0.65, 0.63, 0.61, 0.61, 0.59, 0.58, 0.62, 0.62, 0.63, 0.62, 0.64, 0.64, 0.63, 0.66, 0.64, 0.65, 0.67, 0.64, 0.64, 0.64,

      0.48,
      0.47,
      0.50,
      0.51,
      0.50,
      0.51,
      0.49,
      0.52,
      0.51,
      0.52,
      0.52,
      0.51,
      0.51,
      0.51,
      0.51,
      0.51,
      0.49,
      0.51,
      0.51,
      0.54,
      0.52,
      0.50,
      0.54,
      0.52,
      0.52,
      0.53,
      0.53,
      0.54,
      0.53,
      0.53,
      0.55,
      0.55,
      0.62,
      0.63,
      0.64,
      0.66,
      0.61,
      0.60,
      0.58,
      0.56,
      0.54,
      0.52,
      0.56,
      0.53,
      0.54,
      0.56,
      0.54,
      0.57,
      0.56,
      0.55,
      0.56,
      0.74,
      1.26,
      1.36,
      0.69,
      0.66,
      0.63,
      0.65,
      0.62,
      0.61,
      0.61,
      0.59,
      0.63,
      0.60,
      0.61,
      0.64,
      0.64,
      0.67,
      0.67,
      0.69,
      0.71,
      0.70,
      0.74,
      0.75,
      0.76,
      0.80,
      0.79,
      0.81,
      0.81,
      0.81,
      0.80,
      0.75,
      0.72,
      0.68,
      0.65,
      0.63,
      0.61,
      0.61,
      0.59,
      0.58,
      0.62,
      0.62,
      0.63,
      0.62,
      0.64,
      0.64,
      0.63,
      0.66,
      0.64,
      0.65,
      0.67,
      0.64,
      0.64,
      0.64,
      0.64,
      0.66,
      0.63,
      0.65,
      0.64,
      0.64,
      0.65,
      0.64,
      0.64,
      0.64,
      0.65,
      0.66,
      0.65,
      0.66,
      0.66,
      0.67,
      0.67,
      0.67,
      0.69,
      0.72,
      0.76,
    ]; // 간단한 데이터 샘플

    final double value = sampleData[dataIndex];
    dataIndex = (dataIndex + 1) % sampleData.length;
    return value;
  }
  void _calculateHeartRate(List<double> data) {
    // R-R 간격을 계산할 임계값(threshold) 설정
    // double threshold = 0.5; // 데이터의 변화량이 이 값을 넘으면 R-peak로 인식
    // double threshold = 1.9; // 데이터의 변화량이 이 값을 넘으면 R-peak로 인식
    double threshold = 1.0; // 데이터의 변화량이 이 값을 넘으면 R-peak로 인식

    List<int> rPeaks = [];

    // R-peak 식별
    for (int i = 1; i < data.length - 1; i++) {
      double previous = data[i - 1];
      double current = data[i];
      double next = data[i + 1];

      if ((current - previous) > threshold && (current - next) > threshold) {
        rPeaks.add(i); // R-peak로 인식된 데이터의 인덱스를 저장
      }
    }

    // R-R 간격 계산
    List<double> rrIntervals = [];
    for (int i = 1; i < rPeaks.length; i++) {
      int currentIndex = rPeaks[i];
      int previousIndex = rPeaks[i - 1];
      double rrInterval = (currentIndex - previousIndex).toDouble();
      rrIntervals.add(rrInterval);
    }

    // R-R 간격을 기반으로 심박수 계산 (단위 시간동안의 R-R 간격 수에 따라)
    // double millisecondsPerMinute = 60000; // 1분 = 60,000 밀리초
    double millisecondsPerMinute = 10000; // 1분 = 60,000 밀리초
    List<double> heartRates = [];
    for (int i = 0; i < rrIntervals.length; i++) {
      double heartRate = millisecondsPerMinute / rrIntervals[i];
      heartRates.add(heartRate);
    }

    // 심박수 출력
    // print('♥♡♥♡Heart Rates:♥♡♥♡ $heartRates');
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: 350,
        height: 130,
        width: 350,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          // borderRadius: BorderRadius.circular(8.0),
          // color: Colors.white,
          // color: Colors.black,#232628
          color: Color(0xFF232628),
        ),
        child: CustomPaint(
          painter: EcgChartPainter(ecgData),
          size: Size(double.infinity, 200),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // title: Text('HolmesAI RealTime ECG Chart',style: TextStyle(color: Colors.pinkAccent),),
          title: Text(
            'HolmesAI 실시간 심전도',
            style: TextStyle(color: Colors.white),
          ),
          // backgroundColor: NEON_COLOR,
          backgroundColor: APPBAR_COLOR,
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: EcgChart2()),
        ),
      ),
    );
  }
}
