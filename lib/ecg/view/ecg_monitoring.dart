import 'package:dio/dio.dart';
import 'package:ecg_app/ecg/component/ecg_card.dart';
import 'package:flutter/material.dart';

class EcgMonitoringScreen extends StatelessWidget {
  const EcgMonitoringScreen({super.key});

  // ignore: non_constant_identifier_names
  // Future<List> Paginate()async{
  //   const String ip = "192.168.0.1";
  //   final dio = Dio();
  //
  //   final resp = await dio.get(
  //       'http://$ip/test'
  //   );
  //   return resp.data['data'];
  //
  // }



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
        "asset/img/icon/hrHeart.png",
        width: MediaQuery.of(context).size.width / 10,
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

      // heartRate : 75,
      // average : 77,
      // minimum : 66,
      // maximum : 85,
    ); //이미 bottom, appbar가 있어서 scafold 할필요 없음
  }
}
