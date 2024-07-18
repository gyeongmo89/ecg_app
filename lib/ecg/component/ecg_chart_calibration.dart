// ecg_chart_calibraion.dart: ecg 차트를 그리는 위젯

import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class EcgChartPainter extends CustomPainter {
  final List<double> ecgData;
  final Paint backgroundPaint;

  EcgChartPainter(this.ecgData, this.backgroundPaint);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background using backgroundPaint
    canvas.drawRect(Offset.zero & size, backgroundPaint);
    final double chartWidth = size.width;
    final double chartHeight = size.height;
    final double dataSpacing =
        chartWidth / ecgData.length; // dataSpacing을 여기서 계산
    final Paint thickGridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0; // 중앙 정사각형을 두껍게 그리기 위한 페인트

    final Paint thinGridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.3; // 작은 정사각형을 얇게 그리기 위한 페인트

    List<Color> gradientColors = [
      AppColors.contentColorCyan,
      AppColors.contentColorBlue,
      AppColors.contentColorPink,
    ];

    final Paint chartPaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
      ).createShader(
          Rect.fromPoints(Offset(0, 0), Offset(chartWidth, chartHeight)))
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

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
      //데이터 켈리브레이션(정규화)
      // print("정규화 전 ecgData: $ecgData");
      final List<double> normalizedData = ecgData
          .map((v) => v / 1100)
          .toList(); //v / 700 이 였는데 1100으로 조정함(HW 변경으로 인함)
      // ecgData.map((v) => v / 700).toList(); //250Hz***
      // 차트 시작위치 설정
      path.moveTo(
          0, chartHeight * (1 - ecgData.first / 600) + 50); // 시작 위치를 아래로 조정함
      // (1 - ecgData.first / 600)); // 시작 위치를 아래로 조정함(250Hz) 원래 이부분 이였으나 하드웨 변경되면서 주석처리함
      //(1 - ecgData.first / 300) -50); // 시작 위치를 아래로 조정함(기기판 250Hz)

      // 정규화된(normalizedData) 데이터를 path에 추가
      for (int i = 1; i < normalizedData.length; i++) {
        final double x = i * dataSpacing;
        final double y = chartHeight *
            (1 - normalizedData[i]); //Y축 위치조정(이게 베스트 프로토 타입 250Hz)
        // final double y = chartHeight * (1 - normalizedData[i]) - 50; //Y축 위치조정(기기판 250Hz)
        path.lineTo(x, y);  // path에 x, y 추가하여 차트를 그림
      }
    } else {
      ecgData.clear();
      // print("ecgData is empty");
    }
    canvas.drawPath(path, chartPaint);
  }

  // shouldRepaint는 CustomPainter가 다시 그려져야 하는지를 결정하는 메서드
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
