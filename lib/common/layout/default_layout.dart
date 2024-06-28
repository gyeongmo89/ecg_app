// 반응형 적용
// APP BAR 색상변경

import 'package:ecg_app/common/component/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final BluetoothDevice? device;

  DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.device,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor ?? Colors.white, // 입력을 받지 않으면 기본 색깔인 흰색으로 설정
      appBar: renderAppBar(context),
      drawer: MenuDrawer(
        device: device,
      ),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar(BuildContext context) {
    if (title == null) {
      return null;
    } else {
      // final appState = Provider.of<AppState>(context, listen: true); // Provider로부터 AppState 가져옴
      // String dayText = 'DAY ${appState.getConnectedDayText()}';
      return AppBar(
        title: Builder(builder: (BuildContext context) {
          // String dayText = 'DAY ${appState.firstConnectedDate}'; // 'DAY' 뒤에 일(day) 정보를 가져와서 텍스트 생성
          String dayText = 'DAY 1'; // 'DAY' 뒤에 일(day) 정보를 가져와서 텍스트 생성
          double screenWidth = MediaQuery.of(context).size.width;
          return Row(
            children: [
              const Text(
                "CLheart",
              ),
              SizedBox(
                width: screenWidth / 3,
              ),
              Text(
                dayText,
              ),
            ],
          );
        }),
      );
    }
  }
}
