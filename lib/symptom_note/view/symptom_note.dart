// text1
import 'dart:math';

import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:ecg_app/symptom_note/view/symptom_registration.dart';
import 'package:flutter/material.dart';

class SymptomNoteScreen extends StatefulWidget {
  const SymptomNoteScreen({super.key});

  @override
  State<SymptomNoteScreen> createState() => _SymptomNoteScreenState();
}

class _SymptomNoteScreenState extends State<SymptomNoteScreen> {
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
              child: TabBarView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Date",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  "Symptom",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Divider(
                              thickness: 2,
                              height: 4,
                              color: PRIMARY_COLOR,
                            ),
                          ],

                        ),

                      ],

                    ),
                  ),
                  Center(
                    child: Text("히스토리 창"),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print(" + 버튼눌림");
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );

            if (selectedDate != null) {
              // ignore: use_build_context_synchronously
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (selectedTime != null) {
                final dateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                print("지정된 날짜와 시간 값: $dateTime");

                // 이제 선택한 날짜 및 시간을 처리할 수 있습니다.
                // 데이터 SQLite에 집어넣어야함
                // 등록페이지로 이동
                // ignore: use_build_context_synchronously
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SymptomRegistration(),),
                );

              }
            }
          },
          backgroundColor: const Color(0xff2A56C6),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
