// 햄버거 버튼 클릭시 나타나는 Drawer 화면
import 'package:ecg_app/bluetooth/utils/bluetooth_manager.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/view/about_info.dart';
import 'package:ecg_app/global_variables.dart';
import 'package:ecg_app/main.dart';
import 'package:ecg_app/model/transfer_to_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ecg_app/common/view/patch_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecg_app/common/component/date_util.dart' as myDateUtils;

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
  String saveStartDate = '';
  bool uploadComplete = globalIsUploadComplete;

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
    loadStartDate();  // 시작날짜 로드
    getSavedDeviceName();   // 저장된 디바이스 이름 로드
    if (_themeProvider != null) {
      _themeMode = _themeProvider!.themeMode;
      _themeProvider!.addListener(_updateThemeMode);
    }
  }
  // 시작날짜 로드
  Future<void> loadStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveStartDate = prefs.getString(BluetoothManager.START_DATE_KEY) ?? '';
    if (saveStartDate.isNotEmpty && DateTime.tryParse(saveStartDate) == null) {
      saveStartDate = '';
    }
  }
  // 저장된 디바이스 이름 로드
  Future<String?> getSavedDeviceName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceName = prefs.getString(BluetoothManager.DEVICE_NAME_KEY) ?? 'Disconnected';
    if (deviceName.isEmpty && widget.device != null) {
      deviceName = widget.device?.name ?? '';
      await prefs.setString(BluetoothManager.DEVICE_NAME_KEY, deviceName);
    }
  }
  // 테마 업데이트
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
                        saveStartDate,
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
                        // calculateFinishDate(saveStartDate),
                        myDateUtils.DateUtils.calculateFinishDate(saveStartDate),
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
          ListTile(
            leading: Icon(Icons.cloud_upload_outlined),
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title: Text("Upload"),
            onTap: () {
              postDataToServer(context);
              print("업로드 버튼 클릭");
              setState(() {
                uploadComplete = true;
              });
              Navigator.of(context).pop();
            },
            trailing: Icon(Icons.upload_rounded),
            enabled: !uploadComplete && myDateUtils.DateUtils.calculateFinishDate(saveStartDate).isNotEmpty &&
                DateTime.now().isAfter(DateFormat('yyyy-MM-dd HH:mm')
                    .parse(myDateUtils.DateUtils.calculateFinishDate(saveStartDate))),
          ),

          // Home 버튼은 불필요하여 주석 처리함
          // ListTile(
          //   leading: Icon(Icons.home),
          //   iconColor: PRIMARY_COLOR2,
          //   focusColor: Colors.purple,
          //   title: Text("Home"),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     if (widget.device != null){
          //       print("device is not null");
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (_) => RootTab(device: widget.device),
          //         ),
          //       );}
          //     else {
          //       print("device is null");
          //       Navigator.of(context).pop();
          //     }
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
        ],
      ),
    );
  }
}
