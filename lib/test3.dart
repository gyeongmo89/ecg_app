import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourWidget(),
    );
  }
}

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  @override
  void initState() {
    super.initState();
    getMyDeviceToken(); // 화면이 로드될 때 호출
  }

  void getMyDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    String? token = await messaging.getToken();
    print("내 디바이스 토큰: $token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Token Example'),
      ),
      body: Center(
        child: Text('디바이스 토큰 가져오기'),
      ),
    );
  }
}



// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("백그라운드 메시지 처리.. ${message.notification!.body!}");
// }
//
// void initializeNotification() async {
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(const AndroidNotificationChannel(
//           'high_importance_channel', 'high_importance_notification',
//           importance: Importance.max));
//
//   await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
//     android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//   ));
//
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
// }
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp();
//
//   initializeNotification();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   var messageString = "";
//
//   void getMyDeviceToken() async {
//     final token = await FirebaseMessaging.instance.getToken();
//
//     print("내 디바이스 토큰: $token");
//   }
//
//   @override
//   void initState() {
//     getMyDeviceToken();
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       RemoteNotification? notification = message.notification;
//
//       if (notification != null) {
//         FlutterLocalNotificationsPlugin().show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'high_importance_channel',
//               'high_importance_notification',
//               importance: Importance.max,
//             ),
//           ),
//         );
//
//         setState(() {
//           messageString = message.notification!.body!;
//
//           print("Foreground 메시지 수신: $messageString");
//         });
//       }
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("메시지 내용: $messageString"),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// class HeartRateChart extends StatefulWidget {
//   const HeartRateChart({Key? key}) : super(key: key);
//
//   @override
//   _HeartRateChartState createState() => _HeartRateChartState();
// }
//
// class _HeartRateChartState extends State<HeartRateChart> {
//   List<FlSpot> heartRateData = [];
//   Timer? heartRateTimer;
//   double maxX = 50; // X 축 최대값 설정
//
//   @override
//   void initState() {
//     super.initState();
//     startHeartRateSimulation();
//   }
//
//   void startHeartRateSimulation() {
//     const heartRateInterval = Duration(milliseconds: 500);
//     heartRateTimer = Timer.periodic(heartRateInterval, (timer) {
//       updateHeartRateData();
//     });
//   }
//
//   void updateHeartRateData() {
//     final random = Random();
//
//     final newData = List<FlSpot>.empty(growable: true);
//
//     for (double i = 0; i < maxX; i += 0.2) {
//       newData.add(FlSpot(i, 2 + Random().nextDouble()));
//     }
//
//     setState(() {
//       heartRateData = newData;
//       maxX += 0.2; // X 축 최대값 증가
//     });
//   }
//
//   @override
//   void dispose() {
//     heartRateTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.70,
//       child: LineChart(
//         LineChartData(
//           backgroundColor: Colors.white,
//           clipData: FlClipData.horizontal(),
//           gridData: FlGridData(
//             show: true,
//             drawVerticalLine: true,
//             horizontalInterval: 1,
//             verticalInterval: 1,
//             getDrawingHorizontalLine: (value) {
//               return const FlLine(
//                 color: Colors.grey,
//                 strokeWidth: 1,
//               );
//             },
//             getDrawingVerticalLine: (value) {
//               return const FlLine(
//                 color: Colors.grey,
//                 strokeWidth: 1,
//               );
//             },
//           ),
//           titlesData: const FlTitlesData(
//             show: false,
//           ),
//           borderData: FlBorderData(
//             show: true,
//             border: Border.all(color: Colors.black),
//           ),
//           minX: 0,
//           maxX: maxX, // 변경된 X 축 최대값
//           minY: 0,
//           maxY: 5,
//           lineBarsData: [
//             LineChartBarData(
//               spots: heartRateData,
//               isCurved: false,
//               color: Colors.red,
//               barWidth: 2,
//               isStrokeCapRound: true,
//               dotData: const FlDotData(show: false),
//               belowBarData: BarAreaData(
//                 show: false,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(title: const Text('Heart Rate Chart')),
//       body: Center(child: HeartRateChart()),
//     ),
//   ));
// }
