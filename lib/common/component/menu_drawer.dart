// 2024-02-02 15:09 Setting 의 Light, Dark, System 모드 설정 추가
// 2024-02-05 10:42 테스트
// 2024-05-28 15:55 Serialnumber 디바이스명 적용

import 'package:ecg_app/common/component/custom_button.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/view/about_info.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:ecg_app/ecg/component/ecg_card.dart';
import 'package:ecg_app/ecg/view/ecg_monitoring.dart';
import 'package:ecg_app/main.dart';
import 'package:ecg_app/model/transfer_to_server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecg_app/common/view/patch_info.dart';
import 'package:ecg_app/global_variables.dart';


class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeProvider? _themeProvider;
  String deviceName = globalDeviceName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeProvider = Provider.of<ThemeProvider>(context);
  }

  void _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeIndex = prefs.getInt('themeMode') ?? 2; // Default to Dark Mode
    print('Theme index: $themeIndex'); // Add this line
    setState(() {
      _themeMode = ThemeMode.values[themeIndex];
    });
  }

  @override
  void initState() {
    super.initState();
    deviceName = globalDeviceName;
    print("deviceName: $deviceName");
    if (_themeProvider != null) {
      _themeMode = _themeProvider!.themeMode;
      _themeProvider!.addListener(_updateThemeMode);
    }
  }
  void _updateThemeMode() {
    if (_themeProvider != null) {
      setState(() {
        _themeMode = _themeProvider!.themeMode;
      });
    }
  }

  @override
  void dispose() {
    if (_themeProvider != null) {
      _themeProvider!.removeListener(_updateThemeMode);
    }
    super.dispose();
  }


  void _showThemeDialog(BuildContext context) {
    // Get the current theme mode from the ThemeProvider
    _themeMode = Provider.of<ThemeProvider>(context, listen: false).themeMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<ThemeMode>(
                    title: const Text('Light Mode'),
                    value: ThemeMode.light,
                    groupValue: _themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        setState(() {
                          _themeMode = value;
                        });
                        Provider.of<ThemeProvider>(context, listen: false)
                            .themeMode = value;
                        Navigator.pop(context);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark Mode'),
                    value: ThemeMode.dark,
                    groupValue: _themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        setState(() {
                          _themeMode = value;
                        });
                        Provider.of<ThemeProvider>(context, listen: false)
                            .themeMode = value;
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // 현재 시간을 가져오기
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(now); // 날짜/시간 형식 설정
    String calculateFinishDate(String inputDate) {
      DateTime parsedDate = DateFormat('yyyy-MM-dd HH:mm').parse(inputDate);
      DateTime finishDate = parsedDate.add(Duration(days: 7));
      return DateFormat('yyyy-MM-dd HH:mm').format(finishDate);
    }

    void nextVersionInfo(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("서비스 준비중"),
            content: Text("업데이트 예정인 서비스 입니다."),
            actions: <Widget>[
              CustomButton(
                text: "확인",
                onPressed: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: SAVE_COLOR2,
              ),
            ],
          );
        },
      );
    }

// void _showThemeDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Select Theme'),
//         content: StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 RadioListTile<ThemeMode>(
//                   title: const Text('Light Mode'),
//                   value: ThemeMode.light,
//                   groupValue: _themeMode,
//                   onChanged: (ThemeMode? value) {
//                     if (value != null) {
//                       setState(() {
//                         _themeMode = value;
//                       });
//                       Provider.of<ThemeProvider>(context, listen: false).themeMode = value;
//                       Navigator.pop(context);
//                     }
//                   },
//                 ),
//                 RadioListTile<ThemeMode>(
//                   title: const Text('Dark Mode'),
//                   value: ThemeMode.dark,
//                   groupValue: _themeMode,
//                   onChanged: (ThemeMode? value) {
//                     if (value != null) {
//                       setState(() {
//                         _themeMode = value;
//                       });
//                       Provider.of<ThemeProvider>(context, listen: false).themeMode = value;
//                       Navigator.pop(context);
//                     }
//                   },
//                 ),
//
//               ],
//             );
//           },
//         ),
//       );
//     },
//   );
// }
    return Drawer(
      child: ListView(
        children: <Widget>[
          // const UserAccountsDrawerHeader(
          //   accountName: Text("gyeongmo"),
          //   accountEmail: Text("asdf@mediv.kr"),
          // ),
          Container(
            color: PRIMARY_COLOR2,
            // color: Color(0xffCBD5E0),
            height: MediaQuery.of(context).size.height / 5,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Information",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Serial No.",
                        style: TextStyle(
                          color: Colors.white,
                          // color: BODY_TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 15,
                      ),
                      Text(
                        // "HCL_C101-0001",
                        // globalDeviceName,
                        deviceName,
                        style: TextStyle(
                          color: Colors.white,
                          // color: SUB_TEXT_COLOR,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Start Date",
                        style: TextStyle(
                          color: Colors.white,
                          // color: BODY_TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 16,
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.white,
                          // color: SUB_TEXT_COLOR,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Finish Date",
                        style: TextStyle(
                          color: Colors.white,
                          // color: BODY_TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 21,
                      ),
                      Text(
                        calculateFinishDate(formattedDate),
                        style: TextStyle(
                          color: Colors.white,
                          // color: SUB_TEXT_COLOR,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.cloud_upload_outlined),
            // iconColor: Colors.blueAccent,
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title: Text("Upload"),
            onTap: () {
              postDataToServer(context);
              // Fluttertoast.showToast(
              //   msg: "데이터 전송이 완료 되었습니다.",
              //   toastLength: Toast.LENGTH_SHORT,
              //   gravity: ToastGravity.BOTTOM,
              //
              //   timeInSecForIosWeb: 1,
              //   // backgroundColor: Colors.green,
              //   // textColor: Colors.white,
              //   fontSize: 16.0,
              // );

              Navigator.of(context).pop();
            },
            trailing: Icon(Icons.upload_rounded),
          ),

          // ---------- 2차 또는 향후 기능 ----------
          ListTile(
            leading: Icon(Icons.home),
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RootTab(device: null),
                ),
              );
            },
            trailing: Icon(Icons.navigate_next),
          ),
          // ListTile(
          //   leading:  Icon(Icons.edit_calendar_outlined),
          //   iconColor: Colors.black,
          //   focusColor: Colors.purple,
          //   title:  Text("Symptom Note"),
          //   onTap: () {},
          //   trailing:  Icon(Icons.navigate_next),
          // ),

          // ListTile(
          //   leading: Icon(Icons.notes),
          //   iconColor: Colors.grey,
          //   focusColor: Colors.purple,
          //   title: Text(
          //     "History",
          //     style: TextStyle(color: Colors.grey),
          //   ),
          //   onTap: () {
          //     nextVersionInfo(context);
          //   },
          //   trailing: Icon(Icons.navigate_next),
          // ),
          //
          // ListTile(
          //   leading: Icon(Icons.bar_chart),
          //   iconColor: Colors.grey,
          //   focusColor: Colors.purple,
          //   title: Text(
          //     "Statistics",
          //     style: TextStyle(color: Colors.grey),
          //   ),
          //   onTap: () {
          //     nextVersionInfo(context);
          //   },
          //   trailing: Icon(Icons.navigate_next),
          // ),

          ListTile(
            leading: Icon(Icons.info_outline),
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title: Text(
              "Patch Info",
            ),
            onTap: () {
              // nextVersionInfo(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PatchInfo(),
                ),
              );
            },
            trailing: Icon(Icons.navigate_next),
          ),

          ListTile(
            // leading: Icon(Icons.settings_outlined),
            // leading: Icon(Icons.light_mode),
            leading: Icon(_themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title: Text(
              "Theme Mode",
            ),
            onTap: () {
              _showThemeDialog(context);
            },
            trailing: Icon(Icons.navigate_next),
          ),

          ListTile(
            leading: Icon(Icons.info),
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title: Text(
              "About",
            ),
            onTap: () {
              // nextVersionInfo(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AboutInfo(),
                ),
              );
            },
            trailing: Icon(Icons.navigate_next),
          ),
          // -----------------------------------------
        ],
      ),
    );
  }
}
