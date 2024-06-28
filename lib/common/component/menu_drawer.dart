import 'package:ecg_app/common/component/custom_button.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/view/root_tab.dart';
import 'package:ecg_app/model/transfer_to_server.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // 현재 시간을 가져오기
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now); // 날짜/시간 형식 설정
    String calculateFinishDate(String inputDate) {
      DateTime parsedDate = DateFormat('yyyy-MM-dd HH:mm').parse(inputDate);
      DateTime finishDate = parsedDate.add(const Duration(days: 7));
      return DateFormat('yyyy-MM-dd HH:mm').format(finishDate);
    }

    void nextVersionInfo(BuildContext context){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("서비스 준비중"),
            content: const Text("업데이트 예정인 서비스 입니다."),
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
            height: MediaQuery.of(context).size.height/5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Information",
                        style: TextStyle(
                            color: Colors.white,fontSize: 22, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Serial No.",
                        style: TextStyle(
                          color: Colors.white,
                          // color: BODY_TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/15,
                      ),
                      const Text(
                        "Holmes-Cardio-001",
                        style: TextStyle(
                          color: Colors.white,
                          // color: SUB_TEXT_COLOR,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Start Date",
                        style: TextStyle(
                          color: Colors.white,
                          // color: BODY_TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/16,
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.white,
                          // color: SUB_TEXT_COLOR,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Finish Date",
                        style: TextStyle(
                          color: Colors.white,
                          // color: BODY_TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/21,
                      ),
                      Text(
                        calculateFinishDate(formattedDate),
                        style: const TextStyle(
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
            leading:  const Icon(Icons.cloud_upload_outlined),
            // iconColor: Colors.blueAccent,
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title:  const Text("Upload"),
            onTap: () {
              postDataToServer(context);
              Navigator.of(context).pop();
            },
            trailing:  const Icon(Icons.upload_rounded),
          ),

          // ---------- 2차 또는 향후 기능 ----------
          ListTile(
            leading:  const Icon(Icons.home),
            iconColor: PRIMARY_COLOR2,
            focusColor: Colors.purple,
            title:  const Text("Home"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RootTab(),),
              );
            },
            trailing:  const Icon(Icons.navigate_next),
          ),
          // ListTile(
          //   leading:  Icon(Icons.edit_calendar_outlined),
          //   iconColor: Colors.black,
          //   focusColor: Colors.purple,
          //   title:  Text("Symptom Note"),
          //   onTap: () {},
          //   trailing:  Icon(Icons.navigate_next),
          // ),

          ListTile(
            leading:  const Icon(Icons.notes),
            iconColor: Colors.grey,
            focusColor: Colors.purple,
            title:  const Text("History", style: TextStyle(color: Colors.grey),),
            onTap: () {nextVersionInfo(context);},
            trailing:  const Icon(Icons.navigate_next),
          ),

          ListTile(
            leading: const Icon(Icons.bar_chart),
            iconColor: Colors.grey,
            focusColor: Colors.purple,
            title:  const Text("Statistics", style: TextStyle(color: Colors.grey),),
            onTap: () {nextVersionInfo(context);},
            trailing:  const Icon(Icons.navigate_next),
          ),

          ListTile(
            leading:  const Icon(Icons.info_outline),
            iconColor: Colors.grey,
            focusColor: Colors.purple,
            title:  const Text("Patch Info", style: TextStyle(color: Colors.grey),),
            onTap: () {nextVersionInfo(context);},
            trailing:  const Icon(Icons.navigate_next),
          ),

          ListTile(
            leading:  const Icon(Icons.settings_outlined),
            iconColor: Colors.grey,
            focusColor: Colors.purple,
            title:  const Text("Setting", style: TextStyle(color: Colors.grey),),
            onTap: () {nextVersionInfo(context);},
            trailing:  const Icon(Icons.navigate_next),
          ),

          ListTile(
            leading:  const Icon(Icons.info),
            iconColor: Colors.grey,
            focusColor: Colors.purple,
            title:  const Text("About", style: TextStyle(color: Colors.grey),),
            onTap: () {nextVersionInfo(context);},
            trailing:  const Icon(Icons.navigate_next),
          ),
          // -----------------------------------------
        ],
      ),
    );
  }
}

