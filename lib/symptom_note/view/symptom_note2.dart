import 'package:drift/drift.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:ecg_app/symptom_note/view/symptom_note2_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  // 빨강
  "F44336",
  // 주황
  "FF9800",
  // 노랑
  "FFEB3B",
  // 초록
  "FCAF50",
  // 파랑
  "2196F3",
  // 남색
  "3F51B5",
  // 보라
  "9C27B0",
];

void main() async {
  // 초기화하는 이유는 runApp 하기전에 initializeDateFormatting을 하기 위해(KR로)
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);     // I 는 인스턴스라는 뜻임, 어디에서든 데이터베이스 값을 가져올 수 있다.

  // final colors = await database.getCategoryColors();

  // if(colors.isEmpty){   // rooping 하면서 색깔을 하나씩 넣어줌
  //   for(String hexCode in DEFAULT_COLORS){
  //     await database.createCategoryColor(
  //         CategoryColorsCompanion(
  //           // id 는 넣어줄 필요없음 autoincrement 해서,
  //           hexCode: Value(hexCode), // Value라는 값으로 감싸줘야 한다.
  //         ),
  //
  //     );
  //   }
  // }
  // print(await database.getCategoryColors());


  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: SymptomNote2(),
    )
  );
}