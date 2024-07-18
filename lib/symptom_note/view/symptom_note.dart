import 'package:ecg_app/database/drift_database.dart';
import 'package:ecg_app/symptom_note/view/symptom_note_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 초기화하는 이유는 runApp 하기전에 initializeDateFormatting을 하기 위해(KR로)
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);     // I 는 인스턴스라는 뜻임, 어디에서든 데이터베이스 값을 가져올 수 있다.


  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: SymptomNote(),
    )
  );
}