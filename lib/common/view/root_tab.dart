// 2024-06-26 device

import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/ecg/view/ecg_monitoring.dart';
import 'package:ecg_app/symptom_note/view/symptom_note_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RootTab extends StatefulWidget {
  RootTab({Key? key, required this.device}) : super(key: key);
  // 장치 정보 전달 받기
  final BluetoothDevice? device;

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {// vsync는 무조건 with SingleTickerProviderStateMixin 넣어야함
  late TabController controller; // 컨트롤러 선언
  BluetoothDevice? get device => widget.device;

  int index = 0; //처음엔 네비게이터 홈(ECG)

  @override
  void initState() {
    super.initState();
    // 탭 컨트롤러 생성, length는 탭의 갯수
    controller = TabController(
        length: 2, vsync: this); // vsync는 렌더링 엔진에서 필요 한것인데 컨트롤러 현재 스테이트를 넣어주면됨
    controller.addListener(tabListener); //값이 변경이 될때마다 특정 변수를 실행하라는 뜻
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    // 컨트롤러의 인덱스가 변경될때마다 호출되는 함수
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("widget.device: ${widget.device}");
    if (widget.device == null) {
      return Scaffold(
        body: Center(
          child: Text('연결된 장치가 없습니다.'),
        ),
      );
    }

    return DefaultLayout(
      title: 'ECG Monitoring',
      bottomNavigationBar: BottomNavigationBar(
        // 하단 네비게이션 바
        backgroundColor: Colors.black,
        selectedItemColor: PRIMARY_COLOR2,
        unselectedItemColor: SUB_TEXT_COLOR,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        type: BottomNavigationBarType.shifting, // shifting이 기본, 선택된 메뉴가 더 커보임
        // type: BottomNavigationBarType.fixed, // fixed는 선택된 메뉴사이즈 고정
        onTap: (int index) {
          controller.animateTo(index); // 눌렀을때 화면 이동
        },

        currentIndex: index, // 현재 선택된 index(Deafult ECG 화면)
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_outlined),
            label: 'ECG',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar_outlined),
            label: 'Note',
          ),
        ],
      ),
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
        controller: controller,
        children: [
          EcgMonitoringScreen(
            device: device!,
          ), // ECG 화면
          SymptomNote2(), // Note 화면
        ],
      ),
    );
  }
}
