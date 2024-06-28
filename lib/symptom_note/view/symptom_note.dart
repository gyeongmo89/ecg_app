// 2023-11-06 Registration, History 탭 주석처리

import 'package:ecg_app/common/const/colors.dart';
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
            ),
          ],
        ),
      ),
    );
  }
}
