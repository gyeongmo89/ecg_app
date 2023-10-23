import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class RootTabTest extends StatelessWidget {
  const RootTabTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Center(
        child: Text("Root Tab"),
      ),
    );
  }
}
