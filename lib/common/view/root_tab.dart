// root_tab.dart: bottom 탭 구현 화면

import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/ecg/view/ecg_monitoring.dart';
import 'package:ecg_app/model/transfer_to_server.dart';
import 'package:ecg_app/symptom_note/view/symptom_note_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecg_app/global_variables.dart';

class RootTab extends StatefulWidget {
  RootTab({Key? key, required this.device}) : super(key: key);
  // 장치 정보 전달 받기
  final BluetoothDevice? device;

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  // vsync는 무조건 with SingleTickerProviderStateMixin 넣어야함
  late TabController controller; // 컨트롤러 선언
  late Future<bool> isUploadCompleteFuture;
  late Future<bool> isUploadComplete;
  BluetoothDevice? get device => widget.device;
  int index = 0; //처음엔 네비게이터 홈(ECG)
  // String saveStartDate = ''; // saveStartDate 필드 추가  // 2024-07-16 불필요할 것으로 판단되어 주석처리함

  @override
  void initState() {
    super.initState();
    // 탭 컨트롤러 생성, length는 탭의 갯수
    controller = TabController(
        length: 2, vsync: this); // vsync는 렌더링 엔진에서 필요 한것인데 컨트롤러 현재 스테이트를 넣어주면됨
    controller.addListener(tabListener); //값이 변경이 될때마다 특정 변수를 실행하라는 뜻

    isUploadCompleteFuture = () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isUploadCompleteFuture') ?? false;
    }();

    isUploadComplete = () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isUploadComplete') ?? false;
    }();
  }
  // // 2024-07-16 불필요할 것으로 판단되어 주석처리함
  // Future<void> loadStartDate() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   saveStartDate = prefs.getString(BluetoothManager.START_DATE_KEY) ?? '';
  //   if (saveStartDate.isNotEmpty && DateTime.tryParse(saveStartDate) == null) {
  //     saveStartDate = '';
  //   }
  // }

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
    // 장치가 종료 되었을경우 데이터 업로드할 수 있는 화면
    if (device == null) {
      return DefaultLayout(
        backgroundColor: Colors.black87,
        title: "Upload",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: FutureBuilder<bool>(
                future: isUploadCompleteFuture,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return Text(
                      snapshot.data == true || snapshot.data == null || globalIsUploadComplete == true
                          ? '업로드가 완료 되었습니다.\n심전도 장치는 병원으로 반납해주시면 됩니다.\n감사합니다.'
                          : '주변에 심전도 수집 장치가 없거나\n장치의 전원이 종료되었습니다.\n데이터를 서버에 전송해주세요.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                },
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height / 40,
            ),
            FutureBuilder<bool>(
                future: isUploadCompleteFuture,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (snapshot.data == null ||
                              snapshot.data == true ||
                              globalIsUploadComplete == true) {
                            return Colors.grey;
                          }
                          return PRIMARY_COLOR2;
                        },
                      ),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      bool? isUploadComplete =
                          prefs.getBool('isUploadComplete');
                      if (isUploadComplete == null || !isUploadComplete) {
                        postDataToServer(context);
                        print("업로드 버튼 클릭");
                      } else {
                        Fluttertoast.showToast(
                          msg: "이미 업로드가 완료되었습니다.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Text(
                      snapshot.data == true || globalIsUploadComplete == true ? '업로드 완료' : '업로드 시작',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }),
          ],
        ),
      );
    }

    return DefaultLayout(
      device: device,
      title: 'CLheart',
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
            device: device,
          ), // ECG 화면
          SymptomNote(), // Note 화면
        ],
      ),
    );
  }
}
