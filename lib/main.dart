import 'package:ecg_app/common/component/custom_text_form_field.dart';
import 'package:ecg_app/common/view/connect_info.dart';
import 'package:ecg_app/common/view/first_loading.dart';
import 'package:ecg_app/symptom_note/view/date_time.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    const _App(),
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "NotoSans",
      ),
      debugShowCheckedModeBanner: false,
      // home: FirstLoading(),
      home: const ConnectionInfo(),
        // home: const DatePickerScreen(),

      // home: const DatePickerScreen(),


    );
  }
}
