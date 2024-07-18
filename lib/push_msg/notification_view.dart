// notification_view.dart: 푸시 메시지 테스트를 위한 페이지며, 실제 수행되는 앱에서 적용되지 않음

// import 'package:ecg_app/model/transfer_to_server.dart';
// import 'package:ecg_app/push_msg/local_push_notifications.dart';
// import 'package:flutter/material.dart';
//
// class NotificationView extends StatefulWidget {
//   const NotificationView({super.key});
//
//   @override
//   State<NotificationView> createState() => _NotificationViewState();
// }
//
// class _NotificationViewState extends State<NotificationView> {
//   @override
//   void initState() {
//    listenNotifications();
//     super.initState();
//   }
//   //푸시 알림 스트림에 데이터를 리슨
//   void listenNotifications(){
//     LocalPushNotifications.notificationStream.stream.listen((String? payload) {
//       if(payload != null){
//         print("Recived payload: $payload");
//         // Navigator.pushNamed(context, '/message', arguments: payload);
//         // Navigator.pushNamed(context, '/menu_drawer', arguments: payload);
//         postDataToServer(context);  // 푸시알림 누르면 데이터를 서버에 업로드
//       }
//     });
//   }
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('로컬 푸시 알림'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             LocalPushNotifications.showSimpleNotification(
//               title: '심전도 측정 검사 종료 알림',
//               body: '검사가 종료 되었습니다. 데이터를 업로드해주세요.',
//               payload: '일반 푸시 알림 데이터 Payload',
//             );
//           },
//           child: Text('검사종료 후 푸시 알림'),
//         ),
//       ),
//     );
//   }
// }
