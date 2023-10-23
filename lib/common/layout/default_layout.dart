// 반응형 적용
// test 1
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/menu_drawer.dart';
import 'package:flutter/material.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      // 입력을 받지 않으면 기본색깔인 흰색으로
      // appBar: renderAppBar(),
      appBar: renderAppBar(),
      drawer: const MenuDrawer(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: APPBAR_COLOR,
        title: const Text("ECG App"),
        actions: [
          IconButton(onPressed: (){},
            icon: const Icon(Icons.search),
          ),
          IconButton(onPressed: (){},
              icon: const Icon(Icons.person))
        ],
      );
    }
  }
}

// return Scaffold(
//   backgroundColor: backgroundColor ?? Colors.white, // 입력을 받지 않으면 기본색깔인 흰색으로
//   body: Container(
//     width: screenWidth,
//     height: screenHeight,
//     padding: EdgeInsets.symmetric(
//       // 여백을 화면 크기에 따라 동적으로 설정합니다.
//       horizontal: screenWidth * 0.05,
//       vertical: screenHeight * 0.05,
//     ),
//     child: child,
//   ),
// );

//-----------------------------------
// return Scaffold(
//   backgroundColor: Colors.white,
//   body: Container(
//     width: screenWidth,
//     height: screenHeight,
//     padding: EdgeInsets.symmetric(
//       // 여백을 화면 크기에 따라 동적으로 설정합니다.
//       horizontal: screenWidth * 0.05,
//       vertical: screenHeight * 0.05,
//     ),
//     child: child,
//   ),
// );
