// ECG 필요없는 부분 삭제 2023-12-05 16:01
// 2024-04-12 18:29 device_screen.dart 코드 병합중 Connect Disconnected 상태관리 완료
// 2024-04-12 18:45 화면에 Connected Disconnected 여부 적용 완료
// 2024-04-15 13:44 ECG 차트 연계 시작 1
// 2024-04-15 17:56 ECG 차트 연계 완료(다른 탭 이동 후 상태관리 완료, 하지만 Disconnect 후 다시 Connect 시 데이터가 빠르게 나오는 현상 해결해야함)
// 2024-04-15 18:15 심박수 계산 코드 추가 시작 1, bpm 계산속도 너무빠름..
// 2024-04-16 16:00 심박수 계산 코드 추가 시작 1, bpm 계산속도 너무빠른 것 수정 시작1
// 2024-04-16 16:12 심박수 계산 코드 추가 완료 bpm 계산속도 너무빠른 것 수정 완료(MAX bpm 250 제한 추가)
// 2024-04-16 16:13 수집 데이터 AVG, MIN, MAX bpm 출력 시작 1
// 2024-04-16 18:45 수집 데이터 AVG, MIN, MAX bpm 출력 완료
// 2024-04-16 18:46 avg 출력은 모두 완료했으나 정지후 AVG가 점점 줄어드는것을 막고, AVG 3자리수 일때 화면 넘어가므로 글씨크기 줄일것
// 2024-05-02 12:54 HR 차트 적용 시작1
// 2024-05-09 18:14 HR bpm hr_chart로 데이터 전달 시작1
// 2024-05-09 20:10 HR bpm hr_chart로 데이터 전달하려고 Provider 적용했지만 아직 avgBpm 값이 전달되지 않음(빈배열)
// 2024-05-10 14:45 avgBpm 전달완료
// 2024-05-10 14:46 실시간 Bpm 전달시작
// 2024-06-19 17:02 flutter_blue_plus library 업데이트 시작

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:ecg_app/bluetooth/screens/device_screen.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/ecg/component/hr_chart.dart';
import 'package:ecg_app/symptom_note/component/schedule_bottom_sheet.dart';
import 'package:ecg_app/symptom_note/view/symptom_note2_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

// HeartRateProvider 클래스를 정의합니다.
// class HeartRateProvider with ChangeNotifier {
//   double _avgBpm = 0.0;
//
//   double get avgBpm => _avgBpm;
//
//   set avgBpm(double value) {
//     _avgBpm = value;
//     notifyListeners();
//   }
// }
class HeartRateProvider with ChangeNotifier {
  double _bpm = 0.0;

  double get bpm => _bpm;

  set bpm(double value) {
    _bpm = value;
    notifyListeners();
  }
}



class DeviceScreen extends StatefulWidget {
  final Widget cardioImage;
  final BluetoothDevice device;
  DeviceScreen({required this.cardioImage, required this.device, super.key});

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<double> dividedValue = []; // 클래스 멤버 변수로 선언
  List<double> ecgData = [];
  List<double> bpmValues = []; // 심박수를 저장하는 리스트
  DateTime now = DateTime.now();
  Timer? recordingTimer;
  int dataIndex = 0;
  // List<FlSpot> avgBpm = []; // avgBpm을 상태로 관리
  //
  // // avgBpm 값을 업데이트하는 메소드
  // void updateAvgBpm(List<FlSpot> newAvgBpm) {
  //   setState(() {
  //     avgBpm = newAvgBpm;
  //   });
  // }

  final Paint backgroundPaint = Paint()
    // // 배경색을 회색으로 설정
    // ..color = Colors.grey
    // 배경색을 검정색으로 설정
    ..color = Colors.black
    ..strokeWidth = 0.5;

  // flutterBlue
  FlutterBluePlus flutterBlue = FlutterBluePlus();

  // 연결 상태 표시 문자열
  String stateText = 'Connecting..';

  // 연결 버튼 문자열
  String connectButtonText = 'Disconnect';

  // 현재 연결 상태 저장용
  BluetoothConnectionState deviceState = BluetoothConnectionState.disconnected;

  // 연결 상태 리스너 핸들 화면 종료시 리스너 해제를 위함
  // StreamSubscription<BluetoothDeviceState>? _stateListener;
  StreamSubscription<BluetoothConnectionState>? _stateListener;

  List<BluetoothService> bluetoothService = [];

  Map<String, List<double>> notifyDatas = {};

  double bpm = 0.0; // 심박수를 저장하는 상태 변수
  double avgBpm = 0.0; // 평균 심박수를 저장하는 상태 변수
  double minBpm = 0.0; // 최소 심박수를 저장하는 상태 변수
  double maxBpm = 0.0; // 최대 심박수를 저장하는 상태 변수

  Timer? heartRateTimer; // 심박수 계산 타이머
  // 심박수 계산 코드
  // 심박수를 계산하는 함수
  double calculateHeartRate() {
    List<double> rrIntervals = [];

    // RR 간격 계산
    for (int i = 1; i < ecgData.length - 1; i++) {
      if (ecgData[i - 1] < ecgData[i] && ecgData[i] > ecgData[i + 1]) {
        // R peak를 찾은 경우
        // double rrInterval = (i * 1000 / 250); // 밀리초 단위로 변환, 값이 클수록 BPM이 커짐
        double rrInterval = (i * 1000 / 140); // 밀리초 단위로 변환
        rrIntervals.add(rrInterval);
      }
    }
    if (rrIntervals.isEmpty) {
      // rrIntervals is empty, return a default heart rate
      return 0.0;
    }
    // RR 간격의 평균 계산
    double meanRRInterval =
        rrIntervals.reduce((a, b) => a + b) / rrIntervals.length;

    // 분당 심박수(bpm) 계산
    double heartRate = 60000 / meanRRInterval;
    // 심박수가 250을 넘지 않도록 제한
    heartRate = min(heartRate, 250.0);
    return heartRate;
  }
  // -------------------

  @override
  initState() {
    super.initState();
    // startTimer();
    // Recording Time 타이머 시작
    recordingTimer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());

    // 심박수 계산 타이머 시작
    heartRateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // bpm = calculateHeartRate();
      updateHeartRate();
    });

    // 상태 연결 리스너 등록
    _stateListener = widget.device.state.listen((event) {
      debugPrint('event :  $event');
      if (deviceState == event) {
        // 상태가 동일하다면 무시
        return;
      }
      // 연결 상태 정보 변경
      setBleConnectionState(event);
    });
    // 연결 시작
    connect();
  }

  @override
  void dispose() {
    // 타이머 취소
    recordingTimer?.cancel();
    // 상태 리스터 해제
    _stateListener?.cancel();
    // 연결 해제
    disconnect();
    // 심박수 계산 타이머 취소
    heartRateTimer?.cancel();
    // 위젯이 파괴되는 시점에 ecgData 배열을 비웁니다.
    ecgData.clear();
    print("Disopose에서 clear 함수 실행");
    super.dispose();
  }

  // 현재 시간을 가져오는 메서드
  void _getCurrentTime() {
    setState(() {
      now = DateTime.now();
    });
  }

  // 심박수를 계산하고 bpm 상태 변수를 업데이트하는 메서드
  void updateHeartRate() {
    double heartRate = calculateHeartRate();

    setState(() {
      bpm = heartRate;
      if (heartRate != 0.0) {
        // 심박수가 0이 아닌 경우에만 bpmValues 리스트에 추가
        bpmValues.add(heartRate);
      }
      avgBpm = bpmValues.isNotEmpty
          ? bpmValues.reduce((a, b) => a + b) / bpmValues.length
          : 0.0; // 리스트가 비어 있지 않은 경우에만 평균을 계산
      minBpm =
          bpmValues.isNotEmpty && bpmValues.where((bpm) => bpm > 0).isNotEmpty
              ? bpmValues.where((bpm) => bpm > 0).reduce(min)
              : 0.0; // 리스트가 비어 있지 않은 경우에만 최소값을 계산
      maxBpm =
          bpmValues.isNotEmpty && bpmValues.where((bpm) => bpm < 250).isNotEmpty
              ? bpmValues.where((bpm) => bpm < 250).reduce(max)
              : 0.0; // 리스트에서 250 미만의 값 중 최대값을 계산

      // avgBpm 값을 HeartRateProvider에 업데이트합니다.
      // Provider.of<HeartRateProvider>(context, listen: false).avgBpm = avgBpm;
      Provider.of<HeartRateProvider>(context, listen: false).bpm = bpm;
      // print("HeartRateProvider avgBpm: ${Provider.of<HeartRateProvider>(context, listen: false).avgBpm}");
      print("HeartRateProvider avgBpm: ${Provider.of<HeartRateProvider>(context, listen: false).bpm}");
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      // 화면이 mounted 되었을때만 업데이트 되게 함
      super.setState(fn);
    }
  }

  /* 연결 상태 갱신 */
  void setBleConnectionState(BluetoothConnectionState event) {
    // final connectionState = Provider.of<ConnectionState>(context, listen: false); // 상태관리를 위해 추가(2024-04-12 15:48)
    switch (event) {
      case BluetoothConnectionState.disconnected:
        disconnect();
        stateText = 'Disconnected';
        // 버튼 상태 변경
        connectButtonText = 'Connect';
        ecgData.clear();
        if (recordingTimer != null && recordingTimer!.isActive) {
          recordingTimer?.cancel();
        } else {
          print("Timer is null or already cancelled");
        }
        connect(); // 연결이 다시 활성화되면 서비스를 다시 발견하고 특성에 대한 알림을 다시 설정 //04-11 추가(자동 연결시 데이터 다시 자동으로 불러와야하기 때문)
        break;
      case BluetoothConnectionState.disconnecting:
        stateText = 'Disconnecting';
        break;
      case BluetoothConnectionState.connected:
        stateText = 'Connected';
        // 버튼 상태 변경
        connectButtonText = 'Disconnect';
        ecgData.clear();
        recordingTimer = Timer.periodic(Duration(seconds: 1),
            (Timer t) => _getCurrentTime()); // 연결이 되면 다시 타이머를 시작

        break;
      case BluetoothConnectionState.connecting:
        stateText = 'ecg_Card_Connecting...';
        break;
    }
    //이전 상태 이벤트 저장
    deviceState = event;
    setState(() {});
  }
// 18:46 수정시작
  Future<bool> connect() async {
    Future<bool>? returnValue;

    // Check if the device is already connected
    if (widget.device.state == BluetoothConnectionState.connected) {
      debugPrint('Device is already connected');
      return Future.value(true);
    }

    try {
      // Enable auto connect without mtu argument
      await widget.device.connect(autoConnect: true, mtu: null);

      // Wait until the connection state is connected
      await widget.device.connectionState
          .where((val) => val == BluetoothConnectionState.connected)
          .first;

      // Connection successful, proceed with discovering services
      debugPrint('connection successful');
      print('start discover service');

      // Check if the device is connected before discovering services
      // if (widget.device.state == BluetoothConnectionState.connected) {
      // print("widget.device.connectionState: ${widget.device.connectionState}");
      // print("BluetoothConnectionState.connected: ${BluetoothConnectionState.connected}");
      //
      // print("widget.device.state: ${widget.device.state}, $runtimeType{widget.device.state}");
      // print("BluetoothDeviceState.connected: ${BluetoothConnectionState.connected}, $runtimeType{BluetoothConnectionState.connected},");
      // print("디바이스상태${widget.device.state}");
      // widget.device.state.listen((BluetoothConnectionState state) {
      //   print('Connection state디바이스상태: $state, $runtimeType{state}');
      // });
      // if (widget.device.connectionState == BluetoothConnectionState.connected) {

      // if (widget.device.state == BluetoothConnectionState.connected) {
        print("진입!");
        List<BluetoothService> bleServices =
        await widget.device.discoverServices();
        setState(() {
          bluetoothService = bleServices;
          ecgData.clear();
          print("Connect에서 clear 함수 실행");
        });

        // 각 속성을 디버그에 출력
        for (BluetoothService service in bleServices) {
          print('============================================');
          print('Service UUID: ${service.uuid}');
          for (BluetoothCharacteristic c in service.characteristics) {
            print('\tcharacteristic UUID: ${c.uuid.toString()}');
            print('\t\twrite: ${c.properties.write}');
            print('\t\tread: ${c.properties.read}');
            print('\t\tnotify: ${c.properties.notify}');
            print('\t\tisNotifying: ${c.isNotifying}');
            print(
                '\t\twriteWithoutResponse: ${c.properties.writeWithoutResponse}');
            print('\t\tindicate: ${c.properties.indicate}');

            // notify나 indicate가 true면 디바이스에서 데이터를 보낼 수 있는 캐릭터리스틱이니 활성화 한다.
            // 단, descriptors가 비었다면 notify를 할 수 없으므로 패스!
            if (c.properties.notify && c.descriptors.isNotEmpty) {
              // 진짜 0x2902 가 있는지 단순 체크용!
              for (BluetoothDescriptor d in c.descriptors) {
                print('BluetoothDescriptor uuid ${d.uuid}');
              }

              // notify가 설정 안되었다면...
              if (!c.isNotifying) {
                try {
                  await c.setNotifyValue(true);
                  // 받을 데이터 변수 Map 형식으로 키 생성
                  notifyDatas[c.uuid.toString()] = List.empty();
                  c.value.listen((value) {
                    // 수신받는 value 는 아스키코드로 인코딩된 int임
                    // int를 아스키 문자의 문자(String)으로 변환
                    // 변환된 문자열을 쉼표로 분할하여 각 부분을 별도의 문자열로 변환
                    // 각 문자열을 double로 변환

                    print(
                        "ecg_card_심전도 기기로부터 받는 value1: $value, Type: ${value.runtimeType}");
                    String asciiString = String.fromCharCodes(value);
                    print(
                        "ecg_card_심전도 기기로부터 받는 value2: $asciiString, Type: ${asciiString.runtimeType}");
                    List<String> stringParts = asciiString.split(',');
                    print(
                        "ecg_card_In setNotifyValue stringParts: $stringParts,Tyep: ${stringParts.runtimeType}");

                    List<String> lines = asciiString.split('\n');
                    List<double?> dividedValue = [];
                    for (var line in lines) {
                      List<String> stringParts = line.split(',');
                      dividedValue.addAll(stringParts.map((s) {
                        try {
                          return double.parse(s);
                        } catch (e) {
                          print('Unable to parse "$s" into a double.');
                          return null;
                        }
                      }));
                    }
                    print(
                        "dividedValue --------0> $dividedValue, Type: ${dividedValue.runtimeType}");
                    // HW 완료후 null 대신 EVENT 로 정의된 값을 넣으면 됨
                    // if (listEquals(dividedValue, [null])) {
                    // if (dividedValue.any((element) => element == null)) {
                    if (dividedValue.any((element) => element == 119)) {
                      print(" EVENT값이 null이라고 가정하고 프린트 출력");
                      eventDialog(context, dividedValue);
                    } else {
                      print("Value 10이 아닐때");
                    }
                    // 데이터 읽기 처리!
                    print(
                        'CLtime 으로 부터 수신되는 UUID와 Data 값 : ${c.uuid}: $dividedValue');
                    // print('타입 : ${c.uuid}: ${dividedValue.runtimeType}');
                    // Uint8List : 8비트 부호 없는 정수의 리스트 로 타입이 찍힘
                    setState(() {
                      // 받은 데이터 저장 화면 표시용
                      // notifyDatas[c.uuid.toString()] = dividedValue;
                      notifyDatas[c.uuid.toString()] = dividedValue
                          .where((item) => item != null)
                          .map((item) => item!)
                          .toList();
                      _onDataReceived(value);
                    });
                  });

                  // 설정 후 일정시간 지연
                  await Future.delayed(const Duration(milliseconds: 500));
                } catch (e) {
                  print('error ${c.uuid} $e');
                }
              }
            }
          }
        }
        returnValue = Future.value(true);
      // } else {
      //   print('Else Device is not connected, cannot discover services');
      //   returnValue = Future.value(false);
      // }
    } catch (e) {
      // Handle connection errors here
      print('Connection failed: $e');
      setBleConnectionState(BluetoothConnectionState.disconnected);
      returnValue = Future.value(false);
    }

    return returnValue ?? Future.value(false);
  }

//   Future<bool> connect() async {
//     Future<bool>? returnValue;
//
//     // Check if the device is already connected
//     if (widget.device.state == BluetoothConnectionState.connected) {
//       debugPrint('Device is already connected');
//       return Future.value(true);
//     }
//
//     /*
//       타임아웃을 10초(15000ms)로 설정 및 autoconnect 해제
//        참고로 autoconnect가 true되어있으면 연결이 지연되는 경우가 있음.
//      */
//     // 18:44 수정시작
//
//     await widget.device
//         // .connect(autoConnect: false)
//         // .connect(autoConnect: false, mtu: null)
//         .connect(autoConnect: true, mtu: null)  //true로 하면 에러남
//         .timeout(Duration(milliseconds: 15000), onTimeout: () {
//
//
//       //타임아웃 발생
//       //returnValue를 false로 설정
//       returnValue = Future.value(false);
//       debugPrint('timeout failed');
//
//       //연결 상태 disconnected로 변경
//       setBleConnectionState(BluetoothConnectionState.disconnected);
//     }).then((data) async {
//       bluetoothService.clear();
//       if (returnValue == null) {
//         //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
//         debugPrint('connection successful');
//         print('start discover service');
//         List<BluetoothService> bleServices =
//             await widget.device.discoverServices();
//         setState(() {
//           bluetoothService = bleServices;
//           ecgData.clear();
//           print("Connect에서 clear 함수 실행");
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
//
//             // if (service.uuid == Guid('0000180a-0000-1000-8000-00805f9b34fb')) {
//             //   if (c.uuid == Guid('00002a24-0000-1000-8000-00805f9b34fb')) {
//             //     print("케릭터리스틱 확인 플래그");
//             //     c.read().then((value) {
//             //       print(
//             //           '\t\t홈즈 패치로 부터 받은 모델 넘버 : ${String.fromCharCodes(value)}');
//             //     });
//             //   }
//             //
//             //   // if (c.uuid == Guid('00002a26-0000-1000-8000-00805f9b34fb')) {
//             //   //   c.read().then((value) {
//             //   //
//             //   //     print(
//             //   //         '\t\t홈즈 패치로 부터 받은 Firmware Revision: ${String.fromCharCodes(value)}');
//             //   //   });
//             //   // }
//             // }
//
//             // notify나 indicate가 true면 디바이스에서 데이터를 보낼 수 있는 캐릭터리스틱이니 활성화 한다.
//             // 단, descriptors가 비었다면 notify를 할 수 없으므로 패스!
//             if (c.properties.notify && c.descriptors.isNotEmpty) {
//               // 진짜 0x2902 가 있는지 단순 체크용!
//               for (BluetoothDescriptor d in c.descriptors) {
//                 print('BluetoothDescriptor uuid ${d.uuid}');
//                 // if (d.uuid == BluetoothDescriptor.cccd) {
//                 //   print('d.lastValue: ${d.lastValue}');
//                 // }
//               }
//
//               // notify가 설정 안되었다면...
//               if (!c.isNotifying) {
//                 try {
//                   await c.setNotifyValue(true);
//                   // 받을 데이터 변수 Map 형식으로 키 생성
//                   notifyDatas[c.uuid.toString()] = List.empty();
//                   c.value.listen((value) {
//                     // 수신받는 value 는 아스키코드로 인코딩된 int임
//                     // int를 아스키 문자의 문자(String)으로 변환
//                     // 변환된 문자열을 쉼표로 분할하여 각 부분을 별도의 문자열로 변환
//                     // 각 문자열을 double로 변환
//
//                     print(
//                         "ecg_card_심전도 기기로부터 받는 value1: $value, Type: ${value.runtimeType}");
//                     String asciiString = String.fromCharCodes(value);
//                     print(
//                         "ecg_card_심전도 기기로부터 받는 value2: $asciiString, Type: ${asciiString.runtimeType}");
//                     List<String> stringParts = asciiString.split(',');
//                     print(
//                         "ecg_card_In setNotifyValue stringParts: $stringParts,Tyep: ${stringParts.runtimeType}");
//
//                     List<String> lines = asciiString.split('\n');
//                     List<double?> dividedValue = [];
//                     for (var line in lines) {
//                       List<String> stringParts = line.split(',');
//                       dividedValue.addAll(stringParts.map((s) {
//                         try {
//                           return double.parse(s);
//                         } catch (e) {
//                           print('Unable to parse "$s" into a double.');
//                           return null;
//                         }
//                       }));
//                     }
//                     print(
//                         "dividedValue --------0> $dividedValue, Type: ${dividedValue.runtimeType}");
//                     // HW 완료후 null 대신 EVENT 로 정의된 값을 넣으면 됨
//                     // if (listEquals(dividedValue, [null])) {
//                     // if (dividedValue.any((element) => element == null)) {
//                     if (dividedValue.any((element) => element == 119)) {
//                       print(" EVENT값이 null이라고 가정하고 프린트 출력");
//                       eventDialog(context, dividedValue);
//                     } else {
//                       print("Value 10이 아닐때");
//                     }
//                     // 데이터 읽기 처리!
//                     print(
//                         'CLtime 으로 부터 수신되는 UUID와 Data 값 : ${c.uuid}: $dividedValue');
//                     // print('타입 : ${c.uuid}: ${dividedValue.runtimeType}');
//                     // Uint8List : 8비트 부호 없는 정수의 리스트 로 타입이 찍힘
//                     setState(() {
//                       // 받은 데이터 저장 화면 표시용
//                       // notifyDatas[c.uuid.toString()] = dividedValue;
//                       notifyDatas[c.uuid.toString()] = dividedValue
//                           .where((item) => item != null)
//                           .map((item) => item!)
//                           .toList();
//                       _onDataReceived(value);
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
//
//
// // // disable auto connect
// //     await widget.device.disconnect();
//
//     return returnValue ?? Future.value(false);
//   }

  // /* 연결 해제 */
  // void disconnect() {
  //   try {
  //     setState(() {
  //       stateText = 'Disconnect';
  //       // 연결이 해제되면 ecgData 배열을 비웁니다.
  //       ecgData.clear();
  //       print("Disconnect에서 clear 함수 실행");
  //     });
  //     widget.device.disconnect();
  //   } catch (e) {}
  // }

  /* 연결 해제 */
  void disconnect() {
    try {
      ecgData.clear();
      setState(() {
        stateText = 'Disconnect';
        ecgData.clear();
      });
      widget.device.disconnect();
    } catch (e) {
      print("Disconnect에서 catch문");
    }
  }

  void _onDataReceived(List<int> value) {
    Uint8List originalData = Uint8List.fromList(value);
    String asciiString = String.fromCharCodes(originalData);
    List<String> stringParts = asciiString.split(',');
    print(
        "In _onDataReceived() stringParts: $stringParts,Type: ${stringParts.runtimeType}");
    // List<double> dividedValue =   // 여기서 문제 발생
    //     stringParts.map((s) => double.parse(s)).toList();

    // List<double> dividedValue = stringParts.map((s) => double.parse(s.replaceAll('\n', ''))).toList();

    List<String> lines = asciiString.split('\n');
    List<double?> dividedValue = [];
    for (var line in lines) {
      List<String> stringParts = line.split(',');
      dividedValue.addAll(stringParts.map((s) {
        try {
          return double.parse(s);
        } catch (e) {
          print('Unable to parse "$s" into a double.');
          return null;
        }
      }));
    }
    print("dividedValue --------> $dividedValue");
    // Remove 0.0 from dividedValue
    dividedValue = dividedValue.where((item) => item != 0.0).toList();

    // Print the number of data points added in each update
    print('Number of data points added: ${dividedValue.length}');

    setState(() {
      ecgData.addAll(dividedValue
          .where((item) => item != null)
          .map((item) => item!)
          .toList());

      // Remove the same number of oldest data points from ecgData
      // if (ecgData.length > 250) { // 데이터가 500개 이상일 때만 삭제(삭제속도)
      if (ecgData.length > 200) {
        // 이게 베스트 프로토타입 250Hz일때
        //   if (ecgData.length > 245) { // 기기판 250Hz일때
        // if (ecgData.length > 200) { // 기기판 250Hz일때
        // if (ecgData.length > 150) { // 기기판 250Hz일때

        ecgData.removeRange(0, dividedValue.length);
      }
    });
  }

  void eventDialog(BuildContext context, List<double?> dividedValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('EVENT 버튼 클릭 감지'),
          content: Text('CLtime의 EVENT 버튼을 누르셨습니다.\n증상 노트를 작성하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('나중에'),
              onPressed: () {
                //팝업종료
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('증상작성'),
              onPressed: () {
                // 증상노트 작성
                TextButton(
                  child: Text('증상작성'),
                  onPressed: () {
                    // ScheduleBottomSheet()로 이동
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) {
                        return ScheduleBottomSheet(
                          selectedDate: selectedDay, // 필요한 날짜를 전달하세요.
                          scheduleId: null,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  //---ECG 차트 추가
  // 아래는 ECG 화면
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final heartRateProvider = context.watch<HeartRateProvider>();
    // print("짠 avgBpm: ${heartRateProvider.avgBpm}");
    // HrChart(avgBpm: heartRateProvider.avgBpm);
    print("짠 avgBpm: ${heartRateProvider.bpm}");
    HrChart(bpm: heartRateProvider.bpm);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
// -------------------- 타이틀 --------------------
              // Cardio 이미지
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: widget.cardioImage,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("CLtime",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: BODY_TEXT_COLOR,
                            )),
                        Row(
                          children: [
                            Icon(
                              Icons.bluetooth_audio,
                              // Icons.circle,
                              // color: Colors.deepPurple,
                              color: Colors.purple,
                              size: 16,
                            ),

                            Text(
                              '$stateText',
                              style: TextStyle(color: Colors.white),
                            ),
                            // Text("Connected",
                            // Text(Provider.of<BleConnectionState>(context).stateText,
                            //     style: TextStyle(
                            //       fontSize: 14,
                            //       color: Colors.white,
                            //     )),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       // Icons.bluetooth_connected,
                        //       Icons.bluetooth_audio,
                        //       // Icons.circle,
                        //       color: Colors.redAccent,
                        //       size: 14,
                        //     ),
                        //     Text("Disconnected",
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           color: Colors.red,
                        //         )),
                        //   ],
                        // )
                      ]),
                ],
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    // Container(
                    //   height: 55,
                    //   // width: 40,
                    //   width: 10,
                    //
                    //   alignment: Alignment.center,
                    // ),
                    Text(
                      bpm.toStringAsFixed(0), // 실제 계산된 bpm 값으로 변경
                      style: const TextStyle(
                        fontSize: 34,
                        // fontSize: 14,
                        color: BODY_TEXT_COLOR,
                      ),
                    ),
                    Text(
                      " bpm",
                      style: TextStyle(fontSize: 16, color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ],
          ),
// --------------------------------------------------
          SizedBox(height: deviceHeight / 180),
          //Recording Time 함수
          Row(
            children: [
              Text(
                  "Recording Time  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}"),
            ],
          ),
          SizedBox(height: deviceHeight / 100),
// -------------------- Average, Minimum, Maximum --------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "AVG",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        // color: PRIMARY_COLOR2),
                        color: Colors.white),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Column(
                        children: [
                          Text(
                            avgBpm.toStringAsFixed(0), // 실제 계산된 avgBpm 값으로 변경
                            style: TextStyle(
                              fontSize: 40.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "bpm",
                        style: TextStyle(fontSize: 12.0, color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                  height: deviceHeight / 14,
                  child: VerticalDivider(
                    color: Colors.white,
                    thickness: 1.0,
                  )),
              Column(
                children: [
                  Text(
                    "MIN",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        // min.toString(), //
                        // "80", // HR 랜덤값
                        minBpm.toStringAsFixed(0), // 실제 계산된 minBpm 값으로 변경
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                      ),
                      Text(
                        "bpm",
                        style: TextStyle(fontSize: 12.0, color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                  height: deviceHeight / 14,
                  child: VerticalDivider(
                    color: Colors.white,
                    thickness: 1.0,
                  )),
              Column(
                children: [
                  Text(
                    "MAX",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        // color: PRIMARY_COLOR),
                        color: Colors.white),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        // max.toString(), //
                        // "80", // HR 랜덤값
                        maxBpm.toStringAsFixed(0), // 실제 계산된 maxBpm 값으로 변경
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                      ),
                      Text(
                        "bpm",
                        style: TextStyle(
                            // fontSize: 14.0, color: SUB_TEXT_COLOR),
                            fontSize: 12.0,
                            color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: deviceHeight / 47),
// --------------------------------------------------

// -------------------- BODY ECG --------------------
          Container(
            // height: deviceHeight / 3.8,
            height: deviceHeight / 3.9,
            width: deviceWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                border: Border.all(
                  // color: const Color(0xFFFFF5FF),
                  //   color: Colors.greenAccent,
                  color: Colors.black,
                  //   color: Colors.red,
                  width: 1.0,
                )),
            child: Column(
              children: [
                Container(
                  // height: deviceHeight,
                  // width: deviceWidth / 1.25,
                  width: deviceWidth / 1.199,
                  // height: 220.0,
                  // width: 320.0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("ECG",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: BODY_TEXT_COLOR,
                              )),
                        ],
                      ),
                      // EcgChart2(),  //여기에 EcgChartPainter(ecgData)를 넣어야함
                      CustomPaint(
                        painter: EcgChartPainter(ecgData,
                            backgroundPaint), // device_screen.dart 에서 EcgChartPainter(ecgData)를 호출
                        // size: Size(double.infinity, 101),
                        size: Size(double.infinity, 150.5),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
// --------------------------------------------------
          SizedBox(
            height: deviceHeight / 80 * 1,
          ),
// -------------------- BODY HR --------------------
          Container(
            // height: deviceHeight/3.2,
            // height: deviceHeight / 4.8,
            height: deviceHeight / 4.35,

            width: deviceWidth,

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                border: Border.all(
                  // color: const Color(0xFFFFF5FF),
                  color: Colors.black,

                  width: 1.0,
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("HR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: BODY_TEXT_COLOR,
                          )),
                    ],
                  ),
                  HrChart(bpm: heartRateProvider.bpm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------
  // 아래는 BLE 통신테스트 앱 화면
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // appBar: AppBar(
  //     //   /* 장치명 */
  //     //   title: Text(widget.device.name),
  //     // ),
  //     body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 /* 연결 상태 */
  //                 Text('$stateText'),
  //                 /* 연결 및 해제 버튼 */
  //                 // OutlinedButton(
  //                 //     onPressed: () {
  //                 //       if (deviceState == BluetoothDeviceState.connected) {
  //                 //         /* 연결된 상태라면 연결 해제 */
  //                 //         disconnect();
  //                 //       } else if (deviceState ==
  //                 //           BluetoothDeviceState.disconnected) {
  //                 //         /* 연결 해재된 상태라면 연결 */
  //                 //         connect();
  //                 //       }
  //                 //     },
  //                 //     child: Text(connectButtonText)),
  //                 /* Chart 버튼 */
  //                 ElevatedButton(
  //                     onPressed: () {
  //                       // Navigator.push(
  //                         // context,
  //                         // MaterialPageRoute(
  //                         //     builder: (context) =>
  //                         //     // EcgChart2(dividedValue: dividedValue)),
  //                         //     EcgChart2(dividedValue: ecgData)),
  //                       // );
  //                     },
  //                     child: Text('Chart')),
  //               ],
  //             ),
  //
  //             /* 연결된 BLE의 서비스 정보 출력 */
  //             Expanded(
  //               child: ListView.separated(
  //                 itemCount: bluetoothService.length,
  //                 itemBuilder: (context, index) {
  //                   return listItem(bluetoothService[index]);
  //                 },
  //                 separatorBuilder: (BuildContext context, int index) {
  //                   return Divider();
  //                 },
  //               ),
  //             ),
  //           ],
  //         )),
  //   );
  // }

  /* 각 캐릭터리스틱 정보 표시 위젯 */
  Widget characteristicInfo(BluetoothService r) {
    String name = '';
    String properties = '';
    String data = '';
    // 캐릭터리스틱을 한개씩 꺼내서 표시
    for (BluetoothCharacteristic c in r.characteristics) {
      properties = '';
      data = '';
      name += '\t\t${c.uuid}\n';
      if (c.properties.write) {
        properties += 'Write ';
      }
      if (c.properties.read) {
        properties += 'Read ';
      }
      if (c.properties.notify) {
        properties += 'Notify ';
        if (notifyDatas.containsKey(c.uuid.toString())) {
          // notify 데이터가 존재한다면
          if (notifyDatas[c.uuid.toString()]!.isNotEmpty) {
            data = notifyDatas[c.uuid.toString()].toString();
          }
        }
      }
      if (c.properties.writeWithoutResponse) {
        properties += 'WriteWR ';
      }
      if (c.properties.indicate) {
        properties += 'Indicate ';
      }
      name += '\t\t\tProperties: $properties\n';
      if (data.isNotEmpty) {
        // 받은 데이터 화면에 출력!
        name += '\t\t\t\t$data\n';
      }
    }
    return Text(name);
  }

  /* Service UUID 위젯  */
  Widget serviceUUID(BluetoothService r) {
    String name = '';
    name = r.uuid.toString();
    return Text(name);
  }

  /* Service 정보 아이템 위젯 */
  Widget listItem(BluetoothService r) {
    return ListTile(
      onTap: null,
      title: serviceUUID(r),
      subtitle: characteristicInfo(r),
    );
  }
}

// class _EcgCardState extends State<DeviceScreen> {
//   int heartRate = 75;
//   int avg = 75;
//   int min = 75;
//   int max = 75;
//
//   // heartRate, avg, min, max 랜덤 값으로 설정하는 함수
//   void startUpdatingHeartRate() {
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           // Generate a random number between 70 and 110.
//           final random = Random();
//           heartRate = 80 + random.nextInt(20);
//           avg = 70 + random.nextInt(20);
//           min = 65 + random.nextInt(20);
//           max = 75 + random.nextInt(20);
//         });
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     startUpdatingHeartRate(); // heartRate, avg, min, max 랜덤 값으로 설정하는 함수
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double deviceHeight = MediaQuery.of(context).size.height;
//     double deviceWidth = MediaQuery.of(context).size.width;
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
// // -------------------- 타이틀 --------------------
//               // Cardio 이미지
//               Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(4.0),
//                     child: widget.cardioImage,
//                   ),
//                   // SizedBox(
//                   //   width: deviceWidth / 9 / 4,
//                   // ),
//                   Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("CLtime",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: BODY_TEXT_COLOR,
//                             )),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.bluetooth_audio,
//                               // Icons.circle,
//                               // color: Colors.deepPurple,
//                               // color: Colors.purple,
//                               color: Colors.yellowAccent,
//                               size: 14,
//                             ),
//                             // Text('$stateText'),
//                             Text("가짜 Status 표시용", style: TextStyle(color: Colors.white)),
//                             // Text("Connected",
//                             // Text(Provider.of<BleConnectionState>(context).stateText,
//                             //     style: TextStyle(
//                             //       fontSize: 14,
//                             //       color: Colors.white,
//                             //     )),
//                           ],
//                         ),
//                         // Row(
//                         //   children: [
//                         //     Icon(
//                         //       // Icons.bluetooth_connected,
//                         //       Icons.bluetooth_audio,
//                         //       // Icons.circle,
//                         //       color: Colors.redAccent,
//                         //       size: 14,
//                         //     ),
//                         //     Text("Disconnected",
//                         //         style: TextStyle(
//                         //           fontSize: 14,
//                         //           color: Colors.red,
//                         //         )),
//                         //   ],
//                         // )
//                       ]),
//                 ],
//               ),
//               Container(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.baseline,
//                   textBaseline: TextBaseline.alphabetic,
//                   children: [
//                     Container(
//                       height: 55,
//                       // height: deviceHeight / 9,
//                       width: 40,
//                       alignment: Alignment.center,
//                     ),
//                     Text(
//                       heartRate.toString(), // HR 랜덤값
//                       style: const TextStyle(
//                         fontSize: 40,
//                         color: BODY_TEXT_COLOR,
//                       ),
//                     ),
//                     const Text(
//                       " bpm",//여기
//                       style: TextStyle(fontSize: 18, color: Colors.white60),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
// // --------------------------------------------------
// //           SizedBox(height: deviceHeight/67),
//           SizedBox(height: deviceHeight / 180),
//           Row(
//             children: [
//               Text("Recording Time  14:07"),
//             ],
//           ),
//           SizedBox(height: deviceHeight / 100),
// // -------------------- Average, Minimum, Maximum --------------------
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     "AVG",
//                     style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                         // color: PRIMARY_COLOR2),
//                         color: Colors.white),
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.baseline,
//                     textBaseline: TextBaseline.alphabetic,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             avg.toString(), //
//                             style: TextStyle(
//                               fontSize: 44.0,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         "bpm",
//                         style: TextStyle(
//                             fontSize: 14.0, color: Colors.white60),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: deviceHeight / 14,
//                   child: VerticalDivider(
//                     // color: PRIMARY_COLOR2,
//                     color: Colors.white,
//                     thickness: 1.0,
//                   )),
//               Column(
//                 children: [
//                   Text(
//                     "MIN",
//                     style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.baseline,
//                     textBaseline: TextBaseline.alphabetic,
//                     children: [
//                       Text(
//                         min.toString(), //
//                         style: TextStyle(
//                           fontSize: 44.0,
//                         ),
//                       ),
//                       Text(
//                         "bpm",
//                         style: TextStyle(
//                             fontSize: 14.0, color: Colors.white60),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(
//                   height: deviceHeight / 14,
//                   child: VerticalDivider(
//                     color: Colors.white,
//                     thickness: 1.0,
//                   )),
//               Column(
//                 children: [
//                   Text(
//                     "MAX",
//                     style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                         // color: PRIMARY_COLOR),
//                         color: Colors.white),
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.baseline,
//                     textBaseline: TextBaseline.alphabetic,
//                     children: [
//                       Text(
//                         max.toString(), //
//                         style: TextStyle(
//                           fontSize: 44.0,
//                         ),
//                       ),
//                       Text(
//                         "bpm",
//                         style: TextStyle(
//                             // fontSize: 14.0, color: SUB_TEXT_COLOR),
//                             fontSize: 14.0, color: Colors.white60),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: deviceHeight / 47),
// // --------------------------------------------------
//
// // -------------------- BODY ECG --------------------
//           Container(
//             // height: deviceHeight/3.2,
//             height: deviceHeight / 4.3,
//             width: deviceWidth,
//             // height: 230.0,
//             // width: 380.0,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 // color: const Color(0xFFE6EBF0),
//                 // color: const Color(0xFFFFF5FF),
//                 // color: const Color(0xFFFFF5FF),
//                 color: Colors.white,
//                 border: Border.all(
//                   color: const Color(0xFFFFF5FF),
//
//                   width: 2.0,
//                 )),
//             child: Column(
//               children: [
//                 Container(
//                   // height: deviceHeight,
//                   width: deviceWidth / 1.25,
//                   // height: 220.0,
//                   // width: 320.0,
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text("ECG",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 color: BODY_TEXT_COLOR,
//                               )),
//                         ],
//                       ),
//                       EcgChart2(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
// // --------------------------------------------------
//           SizedBox(
//             height: deviceHeight / 80 * 2,
//           ),
// // -------------------- BODY HR --------------------
//           Container(
//             // height: deviceHeight/3.2,
//             height: deviceHeight / 4.3,
//             width: deviceWidth,
//
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.white,
//                 border: Border.all(
//                   color: const Color(0xFFFFF5FF),
//                   width: 2.0,
//                 )),
//             child: Column(
//               children: [
//                 Container(
//                   // height: 220.0,
//                   width: deviceWidth / 1.25,
//                   child: const Column(
//                     children: [
//                       Row(
//                         children: [
//                           Text("HR",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 color: BODY_TEXT_COLOR,
//                               )),
//                         ],
//                       ),
//                       HrChart(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
// // --------------------------------------------------
//         ],
//       ),
//     );
//   }
// }
