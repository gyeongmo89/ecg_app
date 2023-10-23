import 'package:ecg_app/common/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          // const UserAccountsDrawerHeader(
          //   accountName: Text("gyeongmo"),
          //   accountEmail: Text("asdf@mediv.kr"),
          // ),
          Container(
            color: const Color(0xffCBD5E0),
            height: 140,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Information",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 60.0,
                      ),
                      Text(
                        "Kim gyeong mo",
                        style: TextStyle(
                          color: SUB_TEXT_COLOR,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Start Date",
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 33.0,
                      ),
                      Text(
                        "2023-10-06",
                        style: TextStyle(
                          color: SUB_TEXT_COLOR,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Finish Date",
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 26.0,
                      ),
                      Text(
                        "2023-10-20",
                        style: TextStyle(
                          color: SUB_TEXT_COLOR,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            iconColor: Colors.black,
            focusColor: Colors.purple,
            title: const Text("ECG Monitoring"),
            onTap: () {},
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: const Icon(Icons.edit_calendar_outlined),
            iconColor: Colors.black,
            focusColor: Colors.purple,
            title: const Text("Symptom Note"),
            onTap: () {},
            trailing: const Icon(Icons.navigate_next),
          ),

          ListTile(
            leading: const Icon(Icons.notes),
            iconColor: Colors.black,
            focusColor: Colors.purple,
            title: const Text("History"),
            onTap: () {},
            trailing: const Icon(Icons.navigate_next),
          ),

          ListTile(
            leading: const Icon(Icons.bar_chart),
            iconColor: Colors.black,
            focusColor: Colors.purple,
            title: const Text("Statistics"),
            onTap: () {},
            trailing: const Icon(Icons.navigate_next),
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            iconColor: Colors.black,
            focusColor: Colors.purple,
            title: const Text("Patch Info"),
            onTap: () {},
            trailing: const Icon(Icons.navigate_next),
          ),

          ListTile(
            leading: const Icon(Icons.settings_outlined),
            iconColor: Colors.black,
            focusColor: Colors.purple,
            title: const Text("Setting"),
            onTap: () {},
            trailing: const Icon(Icons.navigate_next),
          ),

          ListTile(
            leading: const Icon(Icons.info),
            iconColor: Colors.black,
            focusColor: Colors.purple,
            title: const Text("About"),
            onTap: () {},
            trailing: const Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}
