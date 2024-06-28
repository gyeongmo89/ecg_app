import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;


    return Scaffold(
      appBar: AppBar(
        title: Text('심전도 검사 종료 알림'),
      ),
      body: Center(
        child: Text(data.toString()),
      ),
    );
  }
}
