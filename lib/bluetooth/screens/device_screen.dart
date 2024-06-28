import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/service_tile.dart';
import '../widgets/characteristic_tile.dart';
import '../widgets/descriptor_tile.dart';
import '../utils/snackbar.dart';
import '../utils/extra.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  int? _rssi;
  int? _mtuSize;
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  List<BluetoothService> _services = [];
  bool _isDiscoveringServices = false;
  bool _isConnecting = false;
  bool _isDisconnecting = false;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;

  @override
  void initState() {
    super.initState();

    // 여기서 이미 페어링된 장치를 찾고 연결을 시도합니다.
    _connectToPairedDevice();

    _connectionStateSubscription = widget.device.connectionState.listen((state) async {
      _connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        _services = []; // must rediscover services
      }
      if (state == BluetoothConnectionState.connected && _rssi == null) {
        _rssi = await widget.device.readRssi();
      }
      setState(() {});
    });

    _mtuSubscription = widget.device.mtu.listen((value) {
      _mtuSize = value;
      setState(() {});
    });

    _isConnectingSubscription = widget.device.isConnecting.listen((value) {
      _isConnecting = value;
      setState(() {});
    });

    _isDisconnectingSubscription = widget.device.isDisconnecting.listen((value) {
      _isDisconnecting = value;
      setState(() {});
    });
  }

  // 이미 페어링된 장치를 찾고 연결을 시도하는 함수
  void _connectToPairedDevice() async {
    try {
      // 여기서 이미 페어링된 장치 목록을 가져옵니다.
      List<BluetoothDevice> pairedDevices = FlutterBluePlus.connectedDevices;
      // List<BluetoothDevice> pairedDevices = await FlutterBlue.instance.connectedDevices;

      // 이미 페어링된 장치들 중에서 선택 가능한 로직을 추가합니다.
      for (BluetoothDevice pairedDevice in pairedDevices) {
        // 여기서 원하는 장치를 선택할 수 있는 조건을 추가합니다.
        if (pairedDevice.id == widget.device.id) {
          // 원하는 장치를 찾았으면 바로 연결 시도합니다.
          await widget.device.connectAndUpdateStream();
          // 연결이 성공하면 상태를 업데이트하고 UI를 갱신합니다.
          setState(() {
            _connectionState = BluetoothConnectionState.connected;
          });
          // 연결 성공 메시지를 보여줍니다.
          Snackbar.show(ABC.c, "Connect: Success", success: true);
          return; // 연결을 시도했으므로 함수 종료
        }
      }
      // 만약 원하는 장치를 찾지 못했다면 여기에 대한 처리를 추가할 수 있습니다.
    } catch (e) {
      // 에러 발생 시 처리
      print("Error while connecting to paired device: $e");
      Snackbar.show(ABC.c, "Connect Error: $e", success: false);
    }
  }


  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Future onConnectPressed() async {
    try {
      await widget.device.connectAndUpdateStream();
      Snackbar.show(ABC.c, "Connect: Success", success: true);
    } catch (e) {
      if (e is FlutterBluePlusException && e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
      }
    }
  }

  Future onCancelPressed() async {
    try {
      await widget.device.disconnectAndUpdateStream(queue: false);
      Snackbar.show(ABC.c, "Cancel: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Cancel Error:", e), success: false);
    }
  }

  Future onDisconnectPressed() async {
    try {
      await widget.device.disconnectAndUpdateStream();
      Snackbar.show(ABC.c, "Disconnect: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Disconnect Error:", e), success: false);
    }
  }

  Future onDiscoverServicesPressed() async {
    setState(() {
      _isDiscoveringServices = true;
    });
    try {
      _services = await widget.device.discoverServices();
      Snackbar.show(ABC.c, "Discover Services: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Discover Services Error:", e), success: false);
    }
    setState(() {
      _isDiscoveringServices = false;
    });
  }

  Future onRequestMtuPressed() async {
    try {
      await widget.device.requestMtu(223);
      Snackbar.show(ABC.c, "Request Mtu: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Change Mtu Error:", e), success: false);
    }
  }

  List<Widget> _buildServiceTiles(BuildContext context, BluetoothDevice d) {
    return _services
        .map(
          (s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics.map((c) => _buildCharacteristicTile(c)).toList(),
      ),
    )
        .toList();
  }

  CharacteristicTile _buildCharacteristicTile(BluetoothCharacteristic c) {
    return CharacteristicTile(
      characteristic: c,
      descriptorTiles: c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
    );
  }

  Widget buildSpinner(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.black12,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget buildRemoteId(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${widget.device.remoteId}'),
    );
  }

  Widget buildRssiTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected ? const Icon(Icons.bluetooth_connected) : const Icon(Icons.bluetooth_disabled),
        Text(((isConnected && _rssi != null) ? '${_rssi!} dBm' : ''), style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  Widget buildGetServices(BuildContext context) {
    return IndexedStack(
      index: (_isDiscoveringServices) ? 1 : 0,
      children: <Widget>[
        TextButton(
          onPressed: onDiscoverServicesPressed,
          child: const Text("Get Services"),
        ),
        const IconButton(
          icon: SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
            ),
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget buildMtuTile(BuildContext context) {
    return ListTile(
        title: const Text('MTU Size'),
        subtitle: Text('$_mtuSize bytes'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onRequestMtuPressed,
        ));
  }

  Widget buildConnectButton(BuildContext context) {
    return Row(children: [
      if (_isConnecting || _isDisconnecting) buildSpinner(context),
      TextButton(
          onPressed: _isConnecting ? onCancelPressed : (isConnected ? onDisconnectPressed : onConnectPressed),
          child: Text(
            _isConnecting ? "CANCEL" : (isConnected ? "DISCONNECT" : "CONNECT"),
            style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: Colors.white),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.device.platformName),
          actions: [buildConnectButton(context)],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildRemoteId(context),
              ListTile(
                leading: buildRssiTile(context),
                title: Text('Device is ${_connectionState.toString().split('.')[1]}.'),
                trailing: buildGetServices(context),
              ),
              buildMtuTile(context),
              ..._buildServiceTiles(context, widget.device),
            ],
          ),
        ),
      ),
    );
  }
}
//------------------------------------------------------------------------------------------------------------------

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class DeviceScreen extends StatefulWidget {
//   DeviceScreen({Key? key, required this.device}) : super(key: key);
//   // 장치 정보 전달 받기
//   final BluetoothDevice device;
//
//   @override
//   _DeviceScreenState createState() => _DeviceScreenState();
// }
//
// class _DeviceScreenState extends State<DeviceScreen> {
//   // flutterBlue
//   FlutterBluePlus flutterBlue = FlutterBluePlus();
//
//   // 연결 상태 표시 문자열
//   String stateText = 'Connecting';
//
//   // 연결 버튼 문자열
//   String connectButtonText = 'Disconnect';
//
//   // 현재 연결 상태 저장용
//   BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
//
//   // 연결 상태 리스너 핸들 화면 종료시 리스너 해제를 위함
//   StreamSubscription<BluetoothDeviceState>? _stateListener;
//
//   List<BluetoothService> bluetoothService = [];
//
//   //
//   Map<String, List<int>> notifyDatas = {};
//
//   @override
//   void initState() {
//     super.initState();
//     // 상태 연결 리스너 등록
//     // _stateListener = widget.device.state.listen((event) {
//     _stateListener = widget.device.state.listen((event) {
//       debugPrint('event :  $event');
//       if (deviceState == event) {
//         // 상태가 동일하다면 무시
//         return;
//       }
//       // 연결 상태 정보 변경
//       setBleConnectionState(event as BluetoothDeviceState);
//
//     }) as StreamSubscription<BluetoothDeviceState>?
//
//     ;
//     // 연결 시작
//     connect();
//   }
//
//   @override
//   void dispose() {
//     // 상태 리스터 해제
//     _stateListener?.cancel();
//     // 연결 해제
//     disconnect();
//     super.dispose();
//   }
//
//   @override
//   void setState(VoidCallback fn) {
//     if (mounted) {
//       // 화면이 mounted 되었을때만 업데이트 되게 함
//       super.setState(fn);
//     }
//   }
//
//   /* 연결 상태 갱신 */
//   setBleConnectionState(BluetoothDeviceState event) {
//     switch (event) {
//       case BluetoothDeviceState.disconnected:
//         stateText = 'Disconnected';
//         // 버튼 상태 변경
//         connectButtonText = 'Connect';
//         break;
//       case BluetoothDeviceState.disconnecting:
//         stateText = 'Disconnecting';
//         break;
//       case BluetoothDeviceState.connected:
//         stateText = 'Connected';
//         // 버튼 상태 변경
//         connectButtonText = 'Disconnect';
//         break;
//       case BluetoothDeviceState.connecting:
//         stateText = 'Connecting';
//         break;
//     }
//     //이전 상태 이벤트 저장
//     deviceState = event;
//     setState(() {});
//   }
//
//   /* 연결 시작 */
//   Future<bool> connect() async {
//     Future<bool>? returnValue;
//     setState(() {
//       /* 상태 표시를 Connecting으로 변경 */
//       stateText = 'Connecting';
//     });
//
//     /*
//       타임아웃을 15초(15000ms)로 설정 및 autoconnect 해제
//        참고로 autoconnect가 true되어있으면 연결이 지연되는 경우가 있음.
//      */
//     await widget.device
//         .connect(autoConnect: false)
//         .timeout(Duration(milliseconds: 15000), onTimeout: () {
//       //타임아웃 발생
//       //returnValue를 false로 설정
//       returnValue = Future.value(false);
//       debugPrint('timeout failed');
//
//       //연결 상태 disconnected로 변경
//       setBleConnectionState(BluetoothDeviceState.disconnected);
//     }).then((data) async {
//       bluetoothService.clear();
//       if (returnValue == null) {
//         //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
//         debugPrint('connection successful');
//         print('start discover service');
//         List<BluetoothService> bleServices =
//         await widget.device.discoverServices();
//         setState(() {
//           bluetoothService = bleServices;
//         });
//         // 각 속성을 디버그에 출력
//         for (BluetoothService service in bleServices) {
//           print('============================================');
//           print('Service UUID: ${service.uuid}');
//           for (BluetoothCharacteristic c in service.characteristics) {
//             print('\tcharacteristic UUID: ${c.uuid.toString()}');
//             print('\t\twrite: ${c.properties.write}');
//             print('\t\tread: ${c.properties.read}');
//             print('\t\tnotify: ${c.properties.notify}');
//             print('\t\tisNotifying: ${c.isNotifying}');
//             print(
//                 '\t\twriteWithoutResponse: ${c.properties.writeWithoutResponse}');
//             print('\t\tindicate: ${c.properties.indicate}');
//
//             // notify나 indicate가 true면 디바이스에서 데이터를 보낼 수 있는 캐릭터리스틱이니 활성화 한다.
//             // 단, descriptors가 비었다면 notify를 할 수 없으므로 패스!
//             if (c.properties.notify && c.descriptors.isNotEmpty) {
//               // 진짜 0x2902 가 있는지 단순 체크용!
//               // for (BluetoothDescriptor d in c.descriptors) {
//               //   print('BluetoothDescriptor uuid ${d.uuid}');
//               //   if (d.uuid == BluetoothDescriptor.cccd) {
//               //     print('d.lastValue: ${d.lastValue}');
//               //   }
//               // }
//
//               // notify가 설정 안되었다면...
//               if (!c.isNotifying) {
//                 try {
//                   await c.setNotifyValue(true);
//                   // 받을 데이터 변수 Map 형식으로 키 생성
//                   notifyDatas[c.uuid.toString()] = List.empty();
//                   c.value.listen((value) {
//                     // 데이터 읽기 처리!
//                     print('${c.uuid}: $value');
//                     setState(() {
//                       // 받은 데이터 저장 화면 표시용
//                       notifyDatas[c.uuid.toString()] = value;
//                     });
//                   });
//
//                   // 설정 후 일정시간 지연
//                   await Future.delayed(const Duration(milliseconds: 500));
//                 } catch (e) {
//                   print('error ${c.uuid} $e');
//                 }
//               }
//             }
//           }
//         }
//         returnValue = Future.value(true);
//       }
//     });
//
//     return returnValue ?? Future.value(false);
//   }
//
//   /* 연결 해제 */
//   void disconnect() {
//     try {
//       setState(() {
//         stateText = 'Disconnecting';
//       });
//       widget.device.disconnect();
//     } catch (e) {}
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         /* 장치명 */
//         title: Text(widget.device.name),
//       ),
//       body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   /* 연결 상태 */
//                   Text('$stateText'),
//                   /* 연결 및 해제 버튼 */
//                   OutlinedButton(
//                       onPressed: () {
//                         if (deviceState == BluetoothDeviceState.connected) {
//                           /* 연결된 상태라면 연결 해제 */
//                           disconnect();
//                         } else if (deviceState ==
//                             BluetoothDeviceState.disconnected) {
//                           /* 연결 해재된 상태라면 연결 */
//                           connect();
//                         }
//                       },
//                       child: Text(connectButtonText)),
//                 ],
//               ),
//
//               /* 연결된 BLE의 서비스 정보 출력 */
//               Expanded(
//                 child: ListView.separated(
//                   itemCount: bluetoothService.length,
//                   itemBuilder: (context, index) {
//                     return listItem(bluetoothService[index]);
//                   },
//                   separatorBuilder: (BuildContext context, int index) {
//                     return Divider();
//                   },
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
//
//   /* 각 캐릭터리스틱 정보 표시 위젯 */
//   Widget characteristicInfo(BluetoothService r) {
//     String name = '';
//     String properties = '';
//     String data = '';
//     // 캐릭터리스틱을 한개씩 꺼내서 표시
//     for (BluetoothCharacteristic c in r.characteristics) {
//       properties = '';
//       data = '';
//       name += '\t\t${c.uuid}\n';
//       if (c.properties.write) {
//         properties += 'Write ';
//       }
//       if (c.properties.read) {
//         properties += 'Read ';
//       }
//       if (c.properties.notify) {
//         properties += 'Notify ';
//         if (notifyDatas.containsKey(c.uuid.toString())) {
//           // notify 데이터가 존재한다면
//           if (notifyDatas[c.uuid.toString()]!.isNotEmpty) {
//             data = notifyDatas[c.uuid.toString()].toString();
//           }
//         }
//       }
//       if (c.properties.writeWithoutResponse) {
//         properties += 'WriteWR ';
//       }
//       if (c.properties.indicate) {
//         properties += 'Indicate ';
//       }
//       name += '\t\t\tProperties: $properties\n';
//       if (data.isNotEmpty) {
//         // 받은 데이터 화면에 출력!
//         name += '\t\t\t\t$data\n';
//       }
//     }
//     return Text(name);
//   }
//
//   /* Service UUID 위젯  */
//   Widget serviceUUID(BluetoothService r) {
//     String name = '';
//     name = r.uuid.toString();
//     return Text(name);
//   }
//
//   /* Service 정보 아이템 위젯 */
//   Widget listItem(BluetoothService r) {
//     return ListTile(
//       onTap: null,
//       title: serviceUUID(r),
//       subtitle: characteristicInfo(r),
//     );
//   }
// }


// 패치 받기전 해당코드로 예시할 것
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final title = 'Flutter BLE Scan Demo';
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: title,
//       home: MyHomePage(title: title),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   // 장치명을 지정해 해당 장치만 표시되게함
//   final String targetDeviceName = 'HolmesAI-Cardio 3';
//
//   FlutterBluePlus flutterBlue = FlutterBluePlus();
//   List<ScanResult> scanResultList = [];
//   bool _isScanning = false;
//
//   @override
//   initState() {
//     super.initState();
//     // 블루투스 초기화
//     initBle();
//
//     // generateDummyData();
//   }
//
//
//   // 가짜 데이터 생성
//   void generateDummyData() {
//     for (int i = 0; i < 5; i++) {
//       ScanResult dummyResult = ScanResult(
//         device: BluetoothDevice(
//           remoteId: DeviceIdentifier("D$i:6E:D4:3$i:CA:BE"),
//         ),
//         advertisementData: AdvertisementData(
//           advName: "HolmesAI-Cardio $i",
//           txPowerLevel: 0, // 여기서 적절한 값으로 변경해주세요
//           connectable: false, // 여기서 적절한 값으로 변경해주세요
//           manufacturerData: {},
//           serviceData: {},
//           serviceUuids: [],
//         ),
//         rssi: -50 + i * 2,
//         timeStamp: DateTime.now(), // 시간 정보 추가
//       );
//       scanResultList.add(dummyResult);
//     }
//   }
//
//   void initBle() {
//     // BLE 스캔 상태 얻기 위한 리스너
//     FlutterBluePlus.isScanning.listen((isScanning) {
//       _isScanning = isScanning;
//       setState(() {});
//     });
//   }
//
//   /*
//   스캔 시작/정지 함수
//   */
//   scan() async {
//     if (!_isScanning) {
//       // 스캔 중이 아니라면
//       // 기존에 스캔된 리스트 삭제
//       scanResultList.clear();
//       // 스캔 시작, 제한 시간 2초
//       FlutterBluePlus.startScan(timeout: Duration(seconds: 8));
//       // 스캔 결과 리스너
//       FlutterBluePlus.scanResults.listen((results) {
//         // List<ScanResult> 형태의 results 값을 scanResultList에 복사
//         print("스캔 시작함수");
//         generateDummyData(); // 내가 임의로 넣음
//         results.forEach((element) {
//           if (element.device.name == targetDeviceName) {
//             if (scanResultList
//                     .indexWhere((e) => e.device.id == element.device.id) <
//                 0) {
//               // 찾는 장치명이고 scanResultList에 등록된적이 없는 장치라면 리스트에 추가
//               scanResultList.add(element);
//             }
//           }
//         });
//         scanResultList = results;
//         // UI 갱신
//         setState(() {});
//       });
//     } else {
//       // 스캔 중이라면 스캔 정지
//       print("스캔 정지함수");
//
//       FlutterBluePlus.stopScan();
//       scanResultList.clear();
//     }
//   }
//
//   /*
//    여기서부터는 장치별 출력용 함수들
//   */
//   /*  장치의 신호값 위젯  */
//   Widget deviceSignal(ScanResult r) {
//     return Text(r.rssi.toString());
//   }
//
//   /* 장치의 MAC 주소 위젯  */
//   Widget deviceMacAddress(ScanResult r) {
//     return Text(r.device.id.id);
//   }
//
//   /* 장치의 명 위젯  */
//   Widget deviceName(ScanResult r) {
//     String name = '';
//
//     if (r.device.name.isNotEmpty) {
//       // device.name에 값이 있다면
//       name = r.device.name;
//     } else if (r.advertisementData.localName.isNotEmpty) {
//       // advertisementData.localName에 값이 있다면
//       name = r.advertisementData.localName;
//     } else {
//       // 둘다 없다면 이름 알 수 없음...
//       name = 'N/A';
//     }
//     return Text(name);
//   }
//
//   /* BLE 아이콘 위젯 */
//   Widget leading(ScanResult r) {
//     return CircleAvatar(
//       child: Icon(
//         Icons.bluetooth,
//         color: Colors.white,
//       ),
//       backgroundColor: Colors.cyan,
//     );
//   }
//
//   /* 장치 아이템을 탭 했을때 호출 되는 함수 */
//   // void onTap(ScanResult r) {
//   //   // 단순히 이름만 출력
//   //   print('${r.device.name}');
//   //   Navigator.push(
//   //     context,
//   //    MaterialPageRoute(builder: (context) => DeviceScreen(device: r.device)),
//   //   );
//   // }
//
//
//
//   /* 장치 아이템 위젯 */
//   Widget listItem(ScanResult r) {
//     return ListTile(
//       // onTap: () => onTap(r),
//       leading: leading(r),
//       title: deviceName(r),
//       subtitle: deviceMacAddress(r),
//       trailing: deviceSignal(r),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         /* 장치 리스트 출력 */
//         child: ListView.separated(
//           itemCount: scanResultList.length,
//           itemBuilder: (context, index) {
//             return listItem(scanResultList[index]);
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider();
//           },
//         ),
//       ),
//       /* 장치 검색 or 검색 중지  */
//       floatingActionButton: FloatingActionButton(
//         onPressed: scan,
//         // 스캔 중이라면 stop 아이콘을, 정지상태라면 search 아이콘으로 표시
//         child: Icon(_isScanning ? Icons.stop : Icons.search),
//       ),
//     );
//   }
// }

