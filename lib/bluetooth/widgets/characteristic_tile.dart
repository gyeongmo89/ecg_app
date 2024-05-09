// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import "../utils/snackbar.dart";
// import "descriptor_tile.dart";
//
// // 데이터 출력 소스코드 시작 : 2023-12-06 19:12
// // 특정 서비스UUID, 케릭터리스틱UUID 정하는 기능 추가 시작 : 2023-12-06 23:26
// // 일단 데이터가 한개만 프린트되서 일단 킵하는것으로..
//
// class CharacteristicTile extends StatefulWidget {
//   final BluetoothCharacteristic characteristic;
//   final List<DescriptorTile> descriptorTiles;
//
//   const CharacteristicTile({Key? key, required this.characteristic, required this.descriptorTiles}) : super(key: key);
//
//   @override
//   State<CharacteristicTile> createState() => _CharacteristicTileState();
// }
//
// class _CharacteristicTileState extends State<CharacteristicTile> {
//   List<int> _value = [];
//
//   late StreamSubscription<List<int>> _lastValueSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     // Service UUID와 Characteristic UUID
//     final serviceUUID = Guid('6E400001-B5A3-F393-E0A9-E50E24DCCA9E');
//     final characteristicUUID = Guid('6E400003-B5A3-F393-E0A9-E50E24DCCA9E');
//
//     _lastValueSubscription = widget.characteristic.value.listen((value) {
//       // _value = value;
//       // _value.addAll(value); // 이 부분을 수정하여 리스트에 데이터를 추가합니다.
//
//       setState(() {});
//       setState(() {
//         _value = value; // 데이터를 새로운 값으로 업데이트합니다.
//       });
//       // setState(() {
//       //   // _value.clear(); // 리스트를 초기화합니다.
//       //   _value.addAll(value); // 새로운 데이터로 리스트를 업데이트합니다.
//       // });
//       // Remove line breaks (10) from the received data
//       _value.removeWhere((element) => element == 10);
//
//       print("Received data: $_value");
//     });
//
//     _scanDeviceServices(widget.characteristic.device, serviceUUID, characteristicUUID);
//   }
//
//   // 특정 Service와 Characteristic의 데이터를 지속적으로 수신하는 함수
//   void _scanDeviceServices(BluetoothDevice device, Guid serviceUUID, Guid characteristicUUID) async {
//     List<BluetoothService> services = await device.discoverServices();
//     for (BluetoothService service in services) {
//       if (service.uuid == serviceUUID) {
//         for (BluetoothCharacteristic c in service.characteristics) {
//           if (c.uuid == characteristicUUID) {
//             try {
//               await c.setNotifyValue(true);
//             } catch (e) {
//               print('Error setting notify value: $e');
//             }
//           }
//         }
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _lastValueSubscription.cancel();
//
//     super.dispose();
//   }
//
//   BluetoothCharacteristic get c => widget.characteristic;
//
//   List<int> _getRandomBytes() {
//     final math = Random();
//     return [math.nextInt(255), math.nextInt(255), math.nextInt(255), math.nextInt(255)];
//   }
//
//   Future onReadPressed() async {
//     try {
//       // Read 버튼을 누르면 데이터를 읽습니다.
//       final value = await c.read();
//       Snackbar.show(ABC.c, "Read: Success", success: true);
//
//       if (c.properties.read) {
//         setState(() {
//           _value = value;
//         });
//       }
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
//     }
//   }
//
//   Future onWritePressed() async {
//     try {
//       await c.write(_getRandomBytes(), withoutResponse: c.properties.writeWithoutResponse);
//       Snackbar.show(ABC.c, "Write: Success", success: true);
//       if (c.properties.read) {
//         await c.read();
//       }
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
//     }
//   }
//
//   Future onSubscribePressed() async {
//     try {
//       String op = c.isNotifying == false ? "Subscribe" : "Unsubscribe";
//       await c.setNotifyValue(c.isNotifying == false);
//       Snackbar.show(ABC.c, "$op : Success", success: true);
//       if (c.properties.read) {
//         // await c.read();
//         final value = await c.read();
//         await c.read();
//         // 읽은 데이터를 출력합니다.
//         print("Received data onReadPressed: $value");
//       }
//       setState(() {});
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Subscribe Error:", e), success: false);
//     }
//   }
//
//   Widget buildUuid(BuildContext context) {
//     String uuid = '0x${widget.characteristic.uuid.str.toUpperCase()}';
//     return Text(uuid, style: TextStyle(fontSize: 13));
//   }
//
//   Widget buildValue(BuildContext context) {
//
//     String data = _value.toString();
//
//     return Text(data, style: TextStyle(fontSize: 13, color: Colors.grey));
//   }
//
//   Widget buildReadButton(BuildContext context) {
//     return TextButton(
//         child: Text("Read"),
//         onPressed: () async {
//           await onReadPressed();
//           setState(() {});
//         });
//   }
//
//   Widget buildWriteButton(BuildContext context) {
//     bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
//     return TextButton(
//         child: Text(withoutResp ? "WriteNoResp" : "Write"),
//         onPressed: () async {
//           await onWritePressed();
//           setState(() {});
//         });
//   }
//
//   Widget buildSubscribeButton(BuildContext context) {
//     bool isNotifying = widget.characteristic.isNotifying;
//     return TextButton(
//         child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
//         onPressed: () async {
//           await onSubscribePressed();
//           setState(() {});
//         });
//   }
//
//   Widget buildButtonRow(BuildContext context) {
//     bool read = widget.characteristic.properties.read;
//     bool write = widget.characteristic.properties.write;
//     bool notify = widget.characteristic.properties.notify;
//     bool indicate = widget.characteristic.properties.indicate;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (read) buildReadButton(context),
//         if (write) buildWriteButton(context),
//         if (notify || indicate) buildSubscribeButton(context),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: ListTile(
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const Text('Characteristic'),
//             buildUuid(context),
//             buildValue(context),
//           ],
//         ),
//         subtitle: buildButtonRow(context),
//         contentPadding: const EdgeInsets.all(0.0),
//       ),
//       children: widget.descriptorTiles,
//     );
//   }
// }
