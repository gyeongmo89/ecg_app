import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotifications{
  //플러그인 인스턴스 생성
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //푸시 알림 스트림 생성
  static final StreamController<String?> notificationStream = StreamController<String?>.broadcast();

  //푸시 알림을 탭했을 떄 호출되는 콜백 함수
  static void onNotificationTap(NotificationResponse notificationResponse) {
    notificationStream.add(notificationResponse.payload!);
  }

  //플러그인 초기화
  static Future<void> initialize() async {
    //안드로이드 설정
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    //iOS 설정
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    //안드로이드 푸시 알림 권한 요청
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    }
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: onNotificationTap,
    onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }
  //일반 푸시 알림 보내기
  static Future showSimpleNotification({
      required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel 1', 'channel 1 name',
    channelDescription: 'channel 1 description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
  }

  //채널 id에 해당하는 푸시 알림 취소
  static Future cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
  //푸시 알림 전체 취소
  static Future cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}