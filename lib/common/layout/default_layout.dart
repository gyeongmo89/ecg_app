// 반응형 적용
// test 1
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/component/menu_drawer.dart';
import 'package:ecg_app/bluetooth/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;

  // const DefaultLayout({
  //   required this.child,
  //   super.key});
  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 현재 화면 크기를 얻어옴.



    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      // 입력을 받지 않으면 기본색깔인 흰색으로
      // appBar: renderAppBar(),
      appBar: renderAppBar(context),
      drawer: const MenuDrawer(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar(BuildContext context) {

    if (title == null) {
      return null;
    } else {
      // final appState = Provider.of<AppState>(context, listen: true); // Provider로부터 AppState 가져오기
      // String dayText = 'DAY ${appState.getConnectedDayText()}';
      return AppBar(
        backgroundColor: APPBAR_COLOR,
        title: Builder(
          builder: (BuildContext context) {

            // String dayText = 'DAY ${appState.firstConnectedDate}'; // 'DAY' 뒤에 일(day) 정보를 가져와서 텍스트 생성
            String dayText = 'DAY 1'; // 'DAY' 뒤에 일(day) 정보를 가져와서 텍스트 생성
            double screenWidth = MediaQuery.of(context).size.width;
            return Row(
              children: [
                const Text("Holmes AI Note"),
                SizedBox(width: screenWidth/6,),
                Text(dayText),
              ],
            );
          }
        ),
        // actions: [
        //   IconButton(onPressed: (){},
        //     icon: const Icon(Icons.search),
        //   ),
        //   IconButton(onPressed: (){},
        //       icon: const Icon(Icons.person))
        // ],

      );
    }
  }
}