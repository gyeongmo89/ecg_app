import 'package:ecg_app/model/transfer_to_server.dart';
import 'package:flutter/material.dart';
import 'package:ecg_app/test_noti/local_push_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
   listenNotifications();
    super.initState();
  }
  //푸시 알림 스트림에 데이터를 리슨
  void listenNotifications(){
    LocalPushNotifications.notificationStream.stream.listen((String? payload) {
      if(payload != null){
        print("Recived payload: $payload");
        // Navigator.pushNamed(context, '/message', arguments: payload);
        // Navigator.pushNamed(context, '/menu_drawer', arguments: payload);
        postDataToServer(context);
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로컬 푸시 알림 테스트'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            LocalPushNotifications.showSimpleNotification(
              title: '심전도 측정 검사 종료 알림',
              body: '검사가 종료 되었습니다. 데이터를 업로드해주세요.',
              payload: '일반 푸시 알림 데이터 Payload',
            );
          },
          child: Text('일반 푸시 알림'),
        ),
      ),
    );
  }
}
