// 2024-02-02 15:09 Setting 의 Light, Dark, System 모드 설정 추가
// 2024-02-05 10:42 테스트
// 2024-05-28 15:55 Serialnumber 디바이스명 적용
// 2024-06-25 09:48 Home 버튼 로직 수정
import 'package:ecg_app/common/component/custom_button.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/view/about_info.dart';
import 'package:ecg_app/main.dart';
import 'package:ecg_app/model/transfer_to_server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ecg_app/common/view/patch_info.dart';
import 'package:ecg_app/global_variables.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice? device;

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

  // 테마 설정
  void _showThemeDialog(BuildContext context) {
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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    // 종료시간 계산(시작시간 + 7일)
    String calculateFinishDate(String inputDate) {
      DateTime parsedDate = DateFormat('yyyy-MM-dd HH:mm').parse(inputDate);
      DateTime finishDate = parsedDate.add(Duration(days: 7));
      return DateFormat('yyyy-MM-dd HH:mm').format(finishDate);
    }

    // Drawer 화면
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            color: PRIMARY_COLOR2,
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 15,
                      ),
                      Text(
                        deviceName,
                        style: TextStyle(
                          color: Colors.white,
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
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Upload 버튼 추가
          ListTile(
            leading: Icon(Icons.cloud_upload_outlined),
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title: Text("Upload"),
            onTap: () {
              postDataToServer(context);
              print("업로드 버튼 클릭");
              Navigator.of(context).pop();
            },
            trailing: Icon(Icons.upload_rounded),
          ),
          // Home 버튼은 불필요하여 주석 처리함
          // ListTile(
          //   leading: Icon(Icons.home),
          //   iconColor: PRIMARY_COLOR2,
          //   focusColor: Colors.purple,
          //   title: Text("Home"),
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (_) => RootTab(device: widget.device),
          //       ),
          //     );
          //   },
          //   trailing: Icon(Icons.navigate_next),
          // ),

          // Patch Info 버튼 추가
          ListTile(
            leading: Icon(Icons.info_outline),
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title: Text(
              "Patch Info",
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PatchInfo(),
                ),
              );
            },
            trailing: Icon(Icons.navigate_next),
          ),

          ListTile(
            leading: Icon(_themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
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
