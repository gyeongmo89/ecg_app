//앱 빌드(Release) 명령어: flutter build apk --release --target-platform=android-arm64
//앱 빌드(Debug) 명령어: flutter build apk --debug --target-platform=android-arm64
//Flutter Cache 삭제 명령어: flutter pub cache repair

import 'dart:async';
import 'dart:io';
import 'package:ecg_app/bluetooth/utils/bluetooth_manager.dart';
import 'package:ecg_app/push_msg/local_push_notifications.dart';
import 'package:flutter/material.dart';
import 'package:ecg_app/database/drift_database.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'common/view/start_loading.dart';
import 'ecg/component/ecg_card.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ecg_app/common/component/date_util.dart' as myDateUtils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 로컬 푸시 알림 초기화
  await LocalPushNotifications.initialize(); //로컬 푸시 알림 초기화

  await Workmanager().initialize(
    callbackDispatcher, //백그라운드에서 실행할 함수(종료시 push 알림)
    // isInDebugMode: false,
    isInDebugMode: true, // 2024-07-17 true로 변경
  );
  // // 주기적인 백그라운드 작업 등록
  // Workmanager().registerPeriodicTask(
  //   '1',  // unique name, 작업을 취소하거나 확인하는 용도
  //   'simplePeriodicTask',
  //   frequency: Duration(minutes: 15), // 15분마다 실행(최소)
  // );

  // 1회성 백그라운드 작업 등록
  // Workmanager().registerOneOffTask("oneoff-task-identifier", "simpleTask");
  await registerTasks;  // 1회성 백그라운드 작업 등록

  // 화면 회전 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
          // 관련 위젯을 자동으로 다시 빌드하기위해 ChangeNotifierProvider를 사용함
          create: (context) => ThemeProvider(),
        ),
        // ChangeNotifierProvider( //
        //   create: (context) => BleConnectionState(),
        // ),
        Provider<TimerService>(
          // 앱 사용시간(최대 1시간)을 위한 provider
          create: (_) => timerService,
        ),
        ChangeNotifierProvider(
          // ECG 데이터를 위한 provider
          create: (context) => HeartRateProvider(), // bpm값을 위한 provider
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

// class _AppState extends State<_App> {
class _AppState extends State<_App> with WidgetsBindingObserver {
  late Timer _timer;
  int timer = 0;
  final StreamController<int> _streamController = StreamController<int>(); //타이머
  bool _isDialogShown = false; // Add this line

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this); //앱이 백그라운드로 변경되었을때 감지하기 위함
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      // 타이머 시작
      int newTimer = await TimeLimit().checkTimeLimit();
      setState(() {
        timer = newTimer;
        _streamController.add(timer);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance?.removeObserver(this);
    _streamController.close();
    super.dispose();
  }

  // Home 버튼을 눌러서 앱이 백그라운드로 실행될때 BLE 통신을 종료하기 위해 앱을 백그라운드 까지 종료함
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print("홈버튼 눌러서 종료");
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    //전역에서 사용하기위해서 추가
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
      builder: (context, child) {
        return Provider<TimerService>.value(
          value: timerService,
          child: child,
        );
      },
      home: StreamBuilder<int>(
        //전역에서 사용하기위해서 추가
        stream: timerService.timerStream, // Use timerService stream
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          //제한시간 설정
          if (snapshot.hasData &&
              snapshot.data! >= 3600000 &&
              !_isDialogShown) {
            // if (snapshot.hasData && snapshot.data! >= 3600 && !_isDialogShown) {
            Future.delayed(Duration.zero, () {
              setState(() {
                _isDialogShown = true; // Set the flag to true
              });
            });
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
            // print("StartLoading 실행");

            return const StartLoading(); // Start Loading 페이지
            // return const NotificationView();  //Push 메시지 test 하기 위한 페이지
          }
          return SizedBox
              .shrink(); // Return an empty widget when dialog is shown
        },
      ),
      // routes: {
      //   // '/': (context) => const HomePage(),
      //   // '/message': (context) => MessagePage(),
      //   '/menu_drawer': (context) => const MenuDrawer(device: null,),
      // },
    );
  }
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // SharedPreferences에서 saveStartDate를 로드
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String saveStartDate =
        prefs.getString(BluetoothManager.START_DATE_KEY) ?? '';

    // saveStartDate가 현재 시간 이후인지 확인
    print("callbackDispatcher saveStartDate: $saveStartDate");

    if (saveStartDate.isNotEmpty) {
      String finishDate =
          myDateUtils.DateUtils.calculateFinishDate(saveStartDate);
      DateTime finishDateTime =
          DateFormat('yyyy-MM-dd HH:mm').parse(finishDate);
      print("callbackDispatcher finishDateTime: $finishDateTime");
      if (DateTime.now().isAfter(finishDateTime)) {
        // if (DateTime.now().isBefore(finishDateTime)) {  // push메시지 테스트 하고싶으면 주석 해제하면됨
        // finishDateTime이 현재 시간 이후라면 푸시 알림을 보냅니다.
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
            '심전도 측정 종료 알림', '심전도 측정 종료 알림',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true); //showWhen true로 해야지 시간까지 출력됨
        // var iOSPlatformChannelSpecifics = IOSInitializationSettings(
        //   // 여기에 필요한 설정을 추가
        //
        // );
        // var platformChannelSpecifics = NotificationDetails(
        //     android: androidPlatformChannelSpecifics,
        //     iOS: iOSPlatformChannelSpecifics);

        var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
        );

        await flutterLocalNotificationsPlugin.show(0, '심전도 측정 검사 종료 알림',
            '검사가 종료 되었습니다. 데이터를 업로드해주세요.', platformChannelSpecifics,
            payload: '일반 푸시 알림 데이터 Payload');
      } else {
        print("saveStartDate가 없거나 현재 시간 이전입니다.");
      }
    }
    return Future.value(true);
  });
}

// mac 에서 추 가 작업
void registerTasks() async {
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Cancel all existing tasks to avoid hitting the iOS limit
  await Workmanager().cancelAll();

  // Schedule a new one-off task
  await Workmanager().registerOneOffTask(
    "come.youurcompany.yourapp.uniqueTaskName", "simpleTask",
    inputData: <String, dynamic>{
      'key': 'value'
    }, // Optional: Data to pass to the task
  );
}

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

class TimeLimit {
  //앱 사용시간 설정
  static const String LAST_DATE_KEY = "last_date";
  static const String TIMER_KEY = "timer";

  Future<int> checkTimeLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastDate = DateTime.parse(
        prefs.getString(LAST_DATE_KEY) ?? DateTime.now().toString());
    int timer = prefs.getInt(TIMER_KEY) ?? 0;
    // print("TimeLimit 클래스 진입");
    if (!isSameDay(DateTime.now(), lastDate)) {
      print("앱 실행이 다른날일 경우 사용시간 0으로 리셋");
      prefs.setString(LAST_DATE_KEY, DateTime.now().toString());
      prefs.setInt(TIMER_KEY, 0);
      timer = 0;
    }
    // print("Timer 시작");
    // print("TimeLimit 클래스의 Timer 값: $timer");
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
  final StreamController<int> _streamController =
      StreamController<int>.broadcast(); //

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
