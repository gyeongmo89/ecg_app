import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/ecg/view/ecg_monitoring.dart';
import 'package:ecg_app/symptom_note/view/symptom_note.dart';
import 'package:ecg_app/symptom_note/view/symptom_note2_view.dart';
import 'package:ecg_app/user/view/test.dart';
import 'package:ecg_app/user/view/test1.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:ecg_app/symptom_note/view/symptom_note2_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';




class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab>
  with
    SingleTickerProviderStateMixin{
  late TabController controller; //init 세팅해야함, late는 나중에 값이 들어갈 것이라는 것

  int index = 0; //처음엔 네비게이터 홈 으로 보이게 해야하므로


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 처음 시작했을 때 토스트 메시지 띄우기



    controller = TabController(length: 2, vsync: this);
    // length 는 children에 넣은 값들 여기선 ECG, Note 2개
    // vsync는 렌더링 엔진에서 필요 한것인데 컨트롤러 현재 스테이트를 넣어주면됨
    // vsync는 무조건 with SingleTickerProviderStateMixin 넣어야함
    
    controller.addListener(tabListener); //값이 변경이 될때마다 특정 변수를 실행하라는 뜻


  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener(){
    setState(() {
      index = controller.index; // 컨트롤러의 인덱스를 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'ECG Monitoring',

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR2,
        unselectedItemColor: SUB_TEXT_COLOR,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        type: BottomNavigationBarType.shifting, // shifting이 기본, 선택된 메뉴가 더 커보임
        // type: BottomNavigationBarType.fixed, // shifting이 기본, 선택된 메뉴가 더 커보임
        onTap: (int index){
          controller.animateTo(index); // 눌렀을때 화면 이동
          // setState(() {
          //   this.index = index;
          // });
        },

        currentIndex: index, //처음엔 네비게이터 홈 으로 보이게 해야하므로
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_outlined),
            label: 'ECG',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar_outlined),
            label: 'Note',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.info_outline),
          //   label: 'Information',
          // )
        ],
      ),
      child : TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          EcgMonitoringScreen(),
          SymptomNote2(),
          // SymptomNoteScreen(),
          // Test1(),
          // Center(child: Text('ECG')),
          // Center(child: Text('Note')),
        ],
      ),
      // child: const Center(
      //   child: Text("ecg monitoring Root tab"),
      // ),
    );
  }
}
