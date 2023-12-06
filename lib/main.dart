import 'package:ecg_app/common/component/custom_text_form_field.dart';
import 'package:ecg_app/common/view/connect_info.dart';
import 'package:ecg_app/common/view/first_loading.dart';
import 'package:ecg_app/common/view/first_loading0.dart';
import 'package:ecg_app/screens/scan_screen.dart';
import 'package:ecg_app/symptom_note/view/date_time.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:ecg_app/symptom_note/view/symptom_note2_view.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// 뒤로눌렀을떄 종료 시작1 11:51
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
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(
      database); // I 는 인스턴스라는 뜻임, 어디에서든 데이터베이스 값을 가져올 수 있다.

  // final colors = await database.getCategoryColors();

  // if(colors.isEmpty){   // rooping 하면서 색깔을 하나씩 넣어줌
  //   for(String hexCode in DEFAULT_COLORS){
  //     await database.createCategoryColor(
  //       CategoryColorsCompanion(
  //         // id 는 넣어줄 필요없음 autoincrement 해서,
  //         hexCode: Value(hexCode), // Value라는 값으로 감싸줘야 한다.
  //       ),
  //
  //     );
  //   }
  // }
  runApp(const _App());
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => AppState(),
  //     child: const _App(),
  //   ),
  // );
}

// class CounterProvider with ChangeNotifier {
//   int _count = 0;
//
//   int get count => _count;
//
//   void setCount(int value) {
//     _count = value;
//     notifyListeners(); // 상태가 변경될 때 리스너에게 알림
//   }
// }

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "NotoSans",
        // fontFamily: "sunflower",
      ),
      debugShowCheckedModeBanner: false,
      // home: FirstLoading(),
      home: WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('앱 종료'),
              content: Text('앱을 종료하시겠습니까?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('확인'),
                ),
              ],
            ),
          );
        },
        child: const FirstLoading0(),
      ),

      // FirstLoading(),
      // const ConnectionInfo(),
      //   home: const DatePickerScreen(),
    );
  }
}
