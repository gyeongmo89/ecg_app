// default_layout.dart: 기본 레이아웃 설정

import 'package:ecg_app/bluetooth/utils/bluetooth_manager.dart';
import 'package:ecg_app/common/component/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultLayout extends StatefulWidget {
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
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  String saveStartDate = '';

  @override
  void initState() {
    super.initState();
    loadStartDate();
  }
  // 시작날짜를 불러오는 함수
  Future<void> loadStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveStartDate = prefs.getString(BluetoothManager.START_DATE_KEY) ?? '';
    if (saveStartDate.isNotEmpty && DateTime.tryParse(saveStartDate) == null) {
      saveStartDate = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.white,
      appBar: renderAppBar(context),
      drawer: MenuDrawer(
        device: widget.device,
      ),
      body: widget.child,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  AppBar? renderAppBar(BuildContext context) {
    if (widget.title == null) {
      return null;
    } else {
      return AppBar(
        title: Builder(builder: (BuildContext context) {
          String dayText = "DAY 1"; // 기본값 설정
          if (saveStartDate.isNotEmpty) {
            DateTime? startDate = DateTime.tryParse(saveStartDate);
            if (startDate != null) {
              // startDate의 시간, 분, 초 정보를 제거
              startDate = DateTime(startDate.year, startDate.month, startDate.day);
              // DateTime.now()의 시간, 분, 초 정보를 제거
              DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              int daysDifference = now.difference(startDate).inDays + 1;  // 시작날짜부터 +1일씩 추가
              dayText = 'DAY $daysDifference';
            }
          } else {
            print("startDate is empty");
          }
          double screenWidth = MediaQuery.of(context).size.width;
          return Row(
            children: [
              Text(
                widget.title!,
              ),
              SizedBox(
                width: screenWidth / 3.1,
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