// 테마색상 추가 2024-01-29 19:33
// 2024-02-02 15:09 Setting 의 Light, Dark, System 모드 설정 추가
// 2024-04-12 16:06 BLE 상태관리를 위해 코드 수정
// 2024-05-07 18:08 하루 최대 1시간 연결 후 앱 종료 시작 1
// 2024-05-08 11:43 하루 최대 1시간 연결 후 앱 종료 시작 2(알림추가)
// 2024-05-08 13:18 하루 최대 1시간 연결 후 앱 종료 시작 3(알림추가)
// 2024-05-09 09:19 하루 최대 1시간 연결 후 앱 종료 시작 4(전역변수 설정)
// 2024-05-28 11:43 local notification 추가

//flutter build apk --release --target-platform=android-arm64
//flutter build apk --debug --target-platform=android-arm64
// flutter pub cache repair

import 'dart:async';
import 'dart:io';
import 'package:ecg_app/bluetooth/ble_connection_state.dart';
import 'package:ecg_app/common/component/menu_drawer.dart';
import 'package:ecg_app/common/view/start_loading.dart';
import 'package:ecg_app/test_noti/home_page.dart';
import 'package:ecg_app/test_noti/message_page.dart';
import 'package:flutter/material.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ecg/component/ecg_card.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ecg_app/test_noti/message_page.dart';
import 'package:ecg_app/test_noti/local_push_notifications.dart';


final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();// 로컬 푸시 알림 초기화
  await LocalPushNotifications.initialize();

  //앱이 종료된 상태에서 푸시 알림을 탭할 때
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    print('앱이 종료된 상태에서 푸시 알림을 탭했습니다.');
    Future.delayed(const Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed('/message',arguments:
      notificationAppLaunchDetails?.notificationResponse?.payload);
    });
  }

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(

      database); // I 는 인스턴스라는 뜻임, 어디에서든 데이터베이스 값을 가져올 수 있다.
  //전역에서 사용하기 위해서 추가
  final timerService = TimerService(); // Create TimerService instance
  // GetIt.I.registerSingleton<TimerService>(timerService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BleConnectionState(),
        ),
        Provider<TimerService>( // Use Provider to manage TimerService instance
          // create: (_) => TimerService(),
          // dispose: (_, timerService) => timerService.dispose(), //지워야하나?
          create: (_) => timerService,
        ),
        ChangeNotifierProvider(   //검사 종료되면 푸시메시지
          create: (context) => HeartRateProvider(),
        ),

      ],
      child: const _App(),
    ),
  );
}

class _App extends StatefulWidget {
  const _App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {
  late Timer _timer;
  int timer = 0;
  final StreamController<int> _streamController = StreamController<int>();
  bool _isDialogShown = false; // Add this line

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      int newTimer = await TimeLimit().checkTimeLimit();
      setState(() {
        timer = newTimer;
        _streamController.add(timer);
      });
      // _streamController.add(timer);  임시
      // if (newTimer >= 940) {
      //   print("neTimer가 940보다 크다 init state");
      //   _streamController.add(newTimer);
      // }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    //전역에서 사용하기위해서 추가
    // final timerService = GetIt.I<TimerService>();
    final timerService = Provider.of<TimerService>(context);

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
      //전역에서 사용하기위해서 추가----------
      builder: (context, child) {
        return Provider<TimerService>.value(
          value: timerService,
          child: child,
        );
      },
      //전역에서 사용하기위해서 추가----------
      home: StreamBuilder<int>(
        //전역에서 사용하기위해서 추가
        stream: timerService.timerStream, // Use timerService stream
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          //제한시간 설정
          if (snapshot.hasData && snapshot.data! >= 3600000 && !_isDialogShown) {
          // if (snapshot.hasData && snapshot.data! >= 3600 && !_isDialogShown) {
            print("제한시간1");
            Future.delayed(Duration.zero, () {
              print("제한시간2");
              setState(() {
                _isDialogShown = true; // Set the flag to true
              });
            });
            print("제한시간3");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('앱 최대 사용시간 알림'),
                    content: Text('앱은 최대 1시간만 사용할 수 있습니다.\n앱을 종료합니다.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          exit(0);
                        },
                        child: Text('확인'),
                      ),
                    ],
                  );
                },

              ).then((_) {
                _isDialogShown =
                true; // Reset the flag when the dialog is dismissed
              });
            });
          } else if (!_isDialogShown) {
            print("StartLoading 실행");

            return const StartLoading();
            // return const HomePage();  //local notification test 하기 위한 페이지
          }
          return SizedBox
              .shrink(); // Return an empty widget when dialog is shown
        },
      ),
      // routes: {
      //   // '/': (context) => const HomePage(),
      //   '/message': (context) => MessagePage(),
      //   '/menu_drawer': (context) => MenuDrawer(),
      // },
    );

  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

class TimeLimit {
  static const String LAST_DATE_KEY = "last_date";
  static const String TIMER_KEY = "timer";

  Future<int> checkTimeLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastDate = DateTime.parse(
        prefs.getString(LAST_DATE_KEY) ?? DateTime.now().toString());
    int timer = prefs.getInt(TIMER_KEY) ?? 0;
    print("TimeLimit 클래스 진입");
    if (!isSameDay(DateTime.now(), lastDate)) {
      print("앱 실행이 다른날일 경우 사용시간 0으로 리셋");
      prefs.setString(LAST_DATE_KEY, DateTime.now().toString());
      prefs.setInt(TIMER_KEY, 0);
      timer = 0;
    }
    print("Timer 시작");
    print("TimeLimit 클래스의 Timer 값: $timer");
    timer++;
    prefs.setInt(TIMER_KEY, timer);
    return timer;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

// 전역에서 사용하기위해서 추가
class TimerService {
  late Timer _timer;
  int timer = 0;
  // final StreamController<int> _streamController = StreamController<int>();
  final StreamController<int> _streamController = StreamController<int>.broadcast();

  TimerService() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      int newTimer = await TimeLimit().checkTimeLimit();
      timer = newTimer;
      _streamController.add(timer);
    });
  }

  Stream<int> get timerStream => _streamController.stream;

  void dispose() {
    _timer.cancel();
    _streamController.close();
  }
}

// 전역에서 사용하기위해서 추가2
// class TimerServiceProvider extends Provider<TimerService> {
//   TimerServiceProvider({
//     required Create<TimerService> create,
//     Widget? child,
//   }) : super(
//             create: create,
//             dispose: (_, timerService) => timerService.dispose(),
//             child: child);
// }

// //원래코드
// import 'dart:async';
// import 'package:ecg_app/bluetooth/ble_connection_state.dart';
// import 'package:ecg_app/common/view/start_loading.dart';
// import 'package:flutter/material.dart';
// import 'package:ecg_app/database/drift_database.dart';
// import 'package:flutter/services.dart';
// import 'package:get_it/get_it.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await initializeDateFormatting();
//
//   final database = LocalDatabase();
//
//   GetIt.I.registerSingleton<LocalDatabase>(
//       database); // I 는 인스턴스라는 뜻임, 어디에서든 데이터베이스 값을 가져올 수 있다.
//   // Timer.periodic(Duration(seconds: 1), (Timer t) async {
//   //   await TimeLimit().checkTimeLimit(context);
//   // });
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => ThemeProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => BleConnectionState(),
//         ),
//       ],
//       child: const _App(),
//
//     ),
//   );
// }
//
// class _App extends StatelessWidget {
//   const _App({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     // Timer.periodic(Duration(seconds: 1), (Timer t) async {
//     //   await TimeLimit().checkTimeLimit(context);
//     // });
//     Timer.periodic(Duration(seconds: 1), (Timer t) async {
//       int timer = await TimeLimit().checkTimeLimit();
//       if (timer >= 140) {
//         t.cancel();
//         print("t.cancel 1시간 이상 사용으로 인한 앱 종료");
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('앱 종료'),
//                 content: Text('앱 사용은 하루 최대 1시간 입니다. 앱을 종료합니다.'),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(false),
//                     child: Text('확인'),
//                   ),
//                 ],
//               );
//             },
//           );
//         });
//       }
//     });
//
//     return MaterialApp(
//       theme: ThemeData(
//         brightness: Brightness.light,
//         fontFamily: "NotoSans",
//         appBarTheme: const AppBarTheme(
//           elevation: 3,
//           iconTheme: IconThemeData(color: Colors.black),
//         ),
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         fontFamily: "NotoSans",
//         appBarTheme: const AppBarTheme(
//           elevation: 3,
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//       ),
//       themeMode: themeProvider.themeMode,
//       debugShowCheckedModeBanner: false,
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
//
// class ThemeProvider with ChangeNotifier {
//   // ThemeMode _themeMode = ThemeMode.system;
//   ThemeMode _themeMode = ThemeMode.dark;
//
//   ThemeMode get themeMode => _themeMode;
//
//   set themeMode(ThemeMode themeMode) {
//     _themeMode = themeMode;
//     notifyListeners();
//   }
// }
//
// class TimeLimit {
//   static const String LAST_DATE_KEY = "last_date";
//   static const String TIMER_KEY = "timer";
//
//   Future<int> checkTimeLimit() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     DateTime lastDate = DateTime.parse(prefs.getString(LAST_DATE_KEY) ?? DateTime.now().toString());
//     int timer = prefs.getInt(TIMER_KEY) ?? 0;
//     print("TimeLimit 클래스 진입");
//     if (!isSameDay(DateTime.now(), lastDate)) {
//       print("앱 실행이 다른날일 경우 사용시간 0으로 리셋");
//       prefs.setString(LAST_DATE_KEY, DateTime.now().toString());
//       prefs.setInt(TIMER_KEY, 0);
//       timer = 0;
//     }
//     print("Timer 시작");
//     print("Timer 값: $timer");
//     timer++;
//     prefs.setInt(TIMER_KEY, timer);
//     return timer;
//   }
//
// // // 앱 사용시간 설정
// // class TimeLimit {
// //   static const String LAST_DATE_KEY = "last_date";
// //   static const String TIMER_KEY = "timer";
// //   Future<void> checkTimeLimit(BuildContext context) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     // prefs.setInt(TimeLimit.TIMER_KEY, 0); // 테스트를 위해 0으로 초기화 하는 코드, 실제때는 주석처리해야함
// //     DateTime lastDate = DateTime.parse(prefs.getString(LAST_DATE_KEY) ?? DateTime.now().toString());
// //     int timer = prefs.getInt(TIMER_KEY) ?? 0;
// //     print("TimeLimit 클래스 진입");
// //     if (!isSameDay(DateTime.now(), lastDate)) {
// //       print("앱 실행이 다른날일 경우 사용시간 0으로 리셋");
// //       // A new day has started
// //       prefs.setString(LAST_DATE_KEY, DateTime.now().toString());
// //       prefs.setInt(TIMER_KEY, 0);
// //       timer = 0;
// //     }
// //       print("Timer 시작");
// //       print("Timer 값: $timer");
// //       // Allow the app to run and update the timer every second
// //       Timer.periodic(Duration(seconds: 1), (Timer t) async {
// //         timer++;
// //         prefs.setInt(TIMER_KEY, timer);
// //         if (timer >= 110) {
// //           t.cancel();
// //           print("t.cancel 1시간 이상 사용으로 인한 앱 종료");
// //
// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             showDialog(
// //               context: Navigator.of(context).context,
// //               builder: (BuildContext context) {
// //                 return AlertDialog(
// //                   title: Text('앱 종료'),
// //                   content: Text('앱 사용은 하루 최대 1시간 입니다. 앱을 종료합니다.'),
// //                   actions: <Widget>[
// //                     TextButton(
// //                       onPressed: () => Navigator.of(context).pop(false),
// //                       child: Text('확인'),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             );
// //           });
// //         }
// //         else{
// //           print("아직 시간이 않되서 종료 않됨");
// //         }
// //       });
// //   }
//   }
//   bool isSameDay(DateTime date1, DateTime date2) {
//     return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
//   }
