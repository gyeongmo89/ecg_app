import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/ecg/view/ecg_monitoring.dart';
import 'package:ecg_app/symptom_note/view/symptom_note2_view.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller; // 컨트롤러 선언

  int index = 0; //처음엔 네비게이터 홈(ECG)

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
    // length 는 children에 넣은 값들 여기선 ECG, Note 2개
    // vsync는 렌더링 엔진에서 필요 한것인데 컨트롤러 현재 스테이트를 넣어주면됨
    // vsync는 무조건 with SingleTickerProviderStateMixin 넣어야함

    controller.addListener(tabListener); //값이 변경이 될때마다 특정 변수를 실행하라는 뜻
  }

  @override
  void dispose() { // 메모리 해제
    // TODO: implement dispose
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {  // 컨트롤러의 인덱스가 변경될때마다 호출되는 함수
    setState(() {
      index = controller.index; // 컨트롤러의 인덱스를 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'ECG Monitoring',  
      bottomNavigationBar: BottomNavigationBar( // 하단 네비게이션 바
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
        physics: const NeverScrollableScrollPhysics(),  // 스크롤 비활성화
        controller: controller,
        children: const [
          EcgMonitoringScreen(),  // ECG 화면
          SymptomNote2(),         // Note 화면
        ],
      ),
    );
  }
}
