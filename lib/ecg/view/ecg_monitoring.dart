import 'package:dio/dio.dart';
import 'package:ecg_app/ecg/component/ecg_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EcgMonitoringScreen extends StatelessWidget {
  const EcgMonitoringScreen({super.key});

//09:03
  @override
  Widget build(BuildContext context) {

    return EcgCard(
      bleImage: Image.asset(
        "asset/img/icon/ble.png",
        width: MediaQuery.of(context).size.width / 10,
        fit: BoxFit.cover,
      ),
      // name : "ECG",

      hrImage: Image.asset(
        // "asset/img/icon/hrHeart.png",
        "asset/img/icon/heartGGG.gif",
        width: MediaQuery.of(context).size.width / 6,
        fit: BoxFit.cover,
      ),

      ecgImage: Image.asset(
        "asset/img/icon/ecgHeart.png",
        width: MediaQuery.of(context).size.width / 10,
        fit: BoxFit.cover,
      ),
      bleStatus: "Connected",

      calenderImage: Image.asset(
        "asset/img/icon/calender.png",
        width: MediaQuery.of(context).size.width / 10,
        fit: BoxFit.cover,
      ),
      cardioImage: Image.asset(
        // "asset/img/icon/Cardio1.png",
        "asset/img/misc/HolmesCardio_2.png",
        width: MediaQuery.of(context).size.width / 6,
        fit: BoxFit.cover,
      ),

      // heartRate : 75,
      // average : 77,
      // minimum : 66,
      // maximum : 85,
    ); //이미 bottom, appbar가 있어서 scafold 할필요 없음
  }
}
