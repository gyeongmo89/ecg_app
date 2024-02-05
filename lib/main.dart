// 테마색상 추가 2024-01-29 19:33
// 2024-02-02 15:09 Setting 의 Light, Dark, System 모드 설정 추가
import 'package:ecg_app/common/view/start_loading.dart';
import 'package:flutter/material.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(
      database); // I 는 인스턴스라는 뜻임, 어디에서든 데이터베이스 값을 가져올 수 있다.

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const _App(),
    ),
  );
}



class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: "NotoSans",
        appBarTheme: const AppBarTheme(
          elevation: 3,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "NotoSans",
        appBarTheme: const AppBarTheme(
          elevation: 3,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
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
        child: const StartLoading(),
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  // ThemeMode _themeMode = ThemeMode.system;
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

// class _App extends StatelessWidget {
//
//   const _App({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         fontFamily: "NotoSans",
//         appBarTheme: const AppBarTheme(
//           // backgroundColor: Colors.white,
//           elevation: 3,
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//       // home: FirstLoading(),
//       home: WillPopScope(
//         onWillPop: () async {
//           return await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('앱 종료'),
//               content: Text('앱을 종료하시겠습니까?'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child: Text('취소'),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(true),
//                   child: Text('확인'),
//                 ),
//               ],
//             ),
//           );
//         },
//         child: const StartLoading(),
//       ),
//     );
//   }
// }
