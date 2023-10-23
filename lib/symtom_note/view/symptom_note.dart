import 'dart:math';

import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class SymptomNoteScreen extends StatelessWidget {
  const SymptomNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Column(
        children: [
          Container(
            color: APPBAR_COLOR,
            child: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.white70,
              labelStyle: TextStyle(
                  // color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              indicatorWeight: 3,
              tabs: [
                Tab(
                  text: 'Registration',
                  height: 50,
                ),
                Tab(
                  text: 'History',
                  height: 50,
                ),
              ],
            ),
          ),
          const Expanded(
              child: TabBarView(children: [
                Center(
                  child: Text("등록창"),
                ),
                Center(
                  child: Text("히스토리 창"),
                )




          ],),),
        ],
      ),),
    );
  }
}
