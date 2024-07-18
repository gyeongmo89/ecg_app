// ecg_card.dart: BLE 통신으로 부터 받은 값을 처리하며, 산출된 값을 ECG 화면으로 출력함(bpm, avg, min, max, ECG, HR)

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:ecg_app/ecg/component/ecg_chart_calibration.dart';
import 'package:ecg_app/bluetooth/utils/bluetooth_manager.dart';
import 'package:ecg_app/common/const/colors.dart';
import 'package:ecg_app/ecg/component/hr_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

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

  final Paint backgroundPaint = Paint()
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

  // 심박수를 계산하는 함수
  double calculateHeartRate() {
    List<double> rrIntervals = [];

    // RR 간격 계산
    for (int i = 1; i < ecgData.length - 1; i++) {
      if (ecgData[i - 1] < ecgData[i] && ecgData[i] > ecgData[i + 1]) {
        // R peak를 찾은 경우
        double rrInterval = (i * 1000 / 140); // 밀리초 단위로 변환
        // double rrInterval = (i * 1000 / 250); // 밀리초 단위로 변환, 값이 클수록 BPM이 커짐
        rrIntervals.add(rrInterval);
      }
    }
    if (rrIntervals.isEmpty) {
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

  @override
  initState() {
    super.initState();
    // Recording Time 타이머 시작
    recordingTimer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());

    // 심박수 계산 타이머 시작
    heartRateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    _stateListener?.cancel();
    disconnect();
    heartRateTimer?.cancel();
    ecgData.clear();
    super.dispose();
  }

  // 현재 시간을 가져오는 함수
  void _getCurrentTime() {
    setState(() {
      now = DateTime.now();
    });
  }

  // 심박수를 계산하고 bpm 상태 변수를 업데이트하는 함수
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

      // avgBpm 값을 HeartRateProvider에 업데이트(ECG 차트 아래 HR차트를 위한 Provider)
      Provider.of<HeartRateProvider>(context, listen: false).bpm = bpm;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      // 화면이 mounted 되었을때만 업데이트 되게 함
      super.setState(fn);
    }
  }

  // 연결 상태 갱신
  void setBleConnectionState(BluetoothConnectionState event) {
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
          print("타이머가 null 이거나 이미 취소됨");
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
        recordingTimer = Timer.periodic(Duration(seconds: 5),
            (Timer t) => _getCurrentTime()); // 연결이 되면 다시 타이머를 시작
        break;
      case BluetoothConnectionState.connecting:
        stateText = 'Connecting..';
        break;
    }
    //이전 상태 이벤트 저장
    deviceState = event;
    setState(() {});
  }

  Future<bool> connect() async {
    Future<bool>? returnValue;
    if (widget.device.state == BluetoothConnectionState.connected) {
      debugPrint('Device is already connected');
      return Future.value(true);
    }

    try {
      // 자동연결 설정(Default 는 false이기 떄문에 true로 설정함, 라이브러리 업데이트로 mtu 설정이 필요해짐)
      await widget.device.connect(autoConnect: true, mtu: null);
      // 연결될 때까지 대기
      await widget.device.connectionState
          .where((val) => val == BluetoothConnectionState.connected)
          .first;
      // 연결 성공 후 검색 진행
      debugPrint('연결 성공');
      BluetoothManager bluetoothManager = BluetoothManager();
      await bluetoothManager.connectAndSaveDevice(widget.device);
      List<BluetoothService> bleServices =
          await widget.device.discoverServices();
      setState(() {
        bluetoothService = bleServices;
        ecgData.clear();
      });
      // 각 속성을 디버그에 출력
      for (BluetoothService service in bleServices) {
        // print('============================================');
        // print('Service UUID: ${service.uuid}');
        for (BluetoothCharacteristic c in service.characteristics) {
          // print('\tcharacteristic UUID: ${c.uuid.toString()}');
          // print('\t\twrite: ${c.properties.write}');
          // print('\t\tread: ${c.properties.read}');
          // print('\t\tnotify: ${c.properties.notify}');
          // print('\t\tisNotifying: ${c.isNotifying}');
          // print(
          //     '\t\twriteWithoutResponse: ${c.properties.writeWithoutResponse}');
          // print('\t\tindicate: ${c.properties.indicate}');

          // notify나 indicate가 true면 디바이스에서 데이터를 보낼 수 있는 캐릭터리스틱이니 활성화 한다.
          // 단, descriptors가 비었다면 notify를 할 수 없으므로 패스
          if (c.properties.notify && c.descriptors.isNotEmpty) {
            // 아래 for문 코드는 0x2902 가 있는지 단순 체크용이며, 실제로는 필요없음
            // `0x2902`는 Bluetooth GATT(Generic Attribute Profile)에서 정의한 특성 디스크립터의 UUID입니다.
            // 이 디스크립터는 클라이언트 구성 디스크립터(Client Characteristic Configuration Descriptor, CCCD)로
            // 특성의 알림(notifications) 및 표시(indications)를 활성화하거나 비활성화하는 데 사용합니다.
            // 따라서 아래 코드로 각 특성의 디스크립터를 순회하면서 CCCD(즉, UUID가 `0x2902`인 디스크립터)가 있는지 확인하는 것을 의미하며,
            // 이것은 특성이 알림을 지원하는지(즉, 데이터 변경 시 클라이언트에 자동으로 알려주는 기능) 확인하는 방법입니다.

            for (BluetoothDescriptor d in c.descriptors) {
              print('BluetoothDescriptor uuid ${d.uuid}');
              // 홈즈HW 에서는 0x2902와 0x2901이 정상 출력됨
              // 0x2902: 0x2902는 Bluetooth Low Energy (BLE) 통신에서 중요한 역할을 하는 Client Characteristic Configuration Descriptor (CCCD)의 UUID입니다.
              // 0x2901: 0x2901은 Bluetooth Low Energy (BLE) 통신에서 사용되는 Characteristic User Description Descriptor의 UUID 입니다.
            }
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
                  // print(
                  //     "ecg_card_심전도 기기로부터 받는 value1: $value, Type: ${value.runtimeType}");
                  String asciiString = String.fromCharCodes(value);
                  // print(
                  //     "ecg_card_심전도 기기로부터 받는 값을 asciiString로 변환한 값: $asciiString, Type: ${asciiString.runtimeType}");
                  List<String> stringParts = asciiString.split(',');
                  print(
                      ",로 Split한 값: $stringParts,Tyep: ${stringParts.runtimeType}");

                  List<String> lines = asciiString.split('\n');
                  List<double?> dividedValue = [];
                  for (var line in lines) {
                    List<String> stringParts = line.split(',');
                    dividedValue.addAll(stringParts.map((s) {
                      try {
                        return double.parse(s);
                      } catch (e) {
                        // print('Unable to parse "$s" into a double.');
                        return null;
                      }
                    }));
                  }
                  // print(
                  //     "dividedValue --------0> $dividedValue, Type: ${dividedValue.runtimeType}");
                  // HW 완료후 null 대신 EVENT 로 정의된 값을 넣으면 됨
                  // if (listEquals(dividedValue, [null])) {
                  // if (dividedValue.any((element) => element == null)) {
                  if (dividedValue.any((element) => element == 119)) {
                    print(" EVENT값이 119 라고 가정하고 프린트 출력");
                    // 2차 개발시 EVENT 값 받으면 아래 주석 해제 하면됨
                    // eventDialog(context, dividedValue);
                  } else {
                    // print("Event 버튼이 눌리지 않았을때");
                  }
                  // print('CLtime 으로 부터 수신되는 UUID와 Data 값 : ${c.uuid}: $dividedValue');

                  setState(() {
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
    } catch (e) {
      print('Connection failed: $e');
      setBleConnectionState(BluetoothConnectionState.disconnected);
      returnValue = Future.value(false);
    }

    return returnValue ?? Future.value(false);
  }

  // 연결 해제
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
    print("value: $value");
    print("변경1 value: $originalData");

    // String asciiString = String.fromCharCodes(originalData); // 원래코드
    // 데이터 추출 하기위해 변경
    String asciiString = String.fromCharCodes(
        originalData.map((code) => code == 10 ? 44 : code).toList()
    );
    //-------------
    print("변경2 value(asciiString): $asciiString");
    List<String> stringParts = asciiString.split(',');
    // print(
    //     "In _onDataReceived() stringParts: $stringParts,Type: ${stringParts.runtimeType}");
    List<String> lines = asciiString.split('\n');
    List<double?> dividedValue = [];
    for (var line in lines) {
      List<String> stringParts = line.split(',');
      dividedValue.addAll(stringParts.map((s) {
        try {
          return double.parse(s);
        } catch (e) {
          // print('Unable to parse "$s" into a double.');
          return null;
        }
      }));
    }
    // print("dividedValue --------> $dividedValue");
    dividedValue = dividedValue.where((item) => item != 0.0).toList();

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
  // 2차 개발시 HW에 Event 버튼이 생기면 EVENT 값 받으면 아래 주석 해제 하면됨(이벤트 버튼 클릭시 Dialog)
  // void eventDialog(BuildContext context, List<double?> dividedValue) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('EVENT 버튼 클릭 감지'),
  //         content: Text('CLtime의 EVENT 버튼을 누르셨습니다.\n증상 노트를 작성하시겠습니까?'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('나중에'),
  //             onPressed: () {
  //               //팝업종료
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('증상작성'),
  //             onPressed: () {
  //               // 증상노트 작성
  //               TextButton(
  //                 child: Text('증상작성'),
  //                 onPressed: () {
  //                   // ScheduleBottomSheet()로 이동
  //                   showModalBottomSheet(
  //                     context: context,
  //                     isScrollControlled: true,
  //                     builder: (_) {
  //                       return ScheduleBottomSheet(
  //                         selectedDate: selectedDay, // 필요한 날짜를 전달하세요.
  //                         scheduleId: null,
  //                       );
  //                     },
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // 아래는 ECG 화면
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final heartRateProvider = context.watch<HeartRateProvider>();
    HrChart(bpm: heartRateProvider.bpm);

    return WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                                color: Colors.purple,
                                size: 16,
                              ),
                              Text(
                                '$stateText',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ]),
                  ],
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        bpm.toStringAsFixed(0), // 실제 계산된 bpm 값으로 변경
                        style: const TextStyle(
                          fontSize: 34,
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
            SizedBox(height: deviceHeight / 180),
            // Recording Time 함수
            Row(
              children: [
                Text(
                    "Recording Time  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}"),
              ],
            ),
            SizedBox(height: deviceHeight / 100),
            // Average, Minimum, Maximum 심박수
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
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.white60),
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
                          minBpm.toStringAsFixed(0), // 실제 계산된 minBpm 값으로 변경
                          style: TextStyle(
                            fontSize: 40.0,
                          ),
                        ),
                        Text(
                          "bpm",
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.white60),
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
                          color: Colors.white),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          maxBpm.toStringAsFixed(0), // 실제 계산된 maxBpm 값으로 변경
                          style: TextStyle(
                            fontSize: 40.0,
                          ),
                        ),
                        Text(
                          "bpm",
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.white60),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: deviceHeight / 47),
            // BODY ECG
            Container(
              // height: deviceHeight / 3.9,
              height: deviceHeight / 4.1,
              width: deviceWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  )),
              child: Column(
                children: [
                  Container(
                    width: deviceWidth / 1.199,
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
                        CustomPaint(
                          painter: EcgChartPainter(ecgData,
                              backgroundPaint), // device_screen.dart 에서 EcgChartPainter(ecgData)를 호출
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
              // height: deviceHeight / 4.35,
              height: deviceHeight / 4.55,
              width: deviceWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  border: Border.all(
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
      ),
    );
  }
  // 아래의 위젯들은 필수 위젯은 아니나 디버깅 등의 용도로 활용 할 수 있어서 주석으로 남겨둠
  // // 각 캐릭터리스틱 정보 표시 위젯
  // Widget characteristicInfo(BluetoothService r) {
  //   String name = '';
  //   String properties = '';
  //   String data = '';
  //   // 캐릭터리스틱을 한개씩 꺼내서 표시
  //   for (BluetoothCharacteristic c in r.characteristics) {
  //     properties = '';
  //     data = '';
  //     name += '\t\t${c.uuid}\n';
  //     if (c.properties.write) {
  //       properties += 'Write ';
  //     }
  //     if (c.properties.read) {
  //       properties += 'Read ';
  //     }
  //     if (c.properties.notify) {
  //       properties += 'Notify ';
  //       if (notifyDatas.containsKey(c.uuid.toString())) {
  //         // notify 데이터가 존재한다면
  //         if (notifyDatas[c.uuid.toString()]!.isNotEmpty) {
  //           data = notifyDatas[c.uuid.toString()].toString();
  //         }
  //       }
  //     }
  //     if (c.properties.writeWithoutResponse) {
  //       properties += 'WriteWR ';
  //     }
  //     if (c.properties.indicate) {
  //       properties += 'Indicate ';
  //     }
  //     name += '\t\t\tProperties: $properties\n';
  //     if (data.isNotEmpty) {
  //       // 받은 데이터 화면에 출력!
  //       name += '\t\t\t\t$data\n';
  //     }
  //   }
  //   return Text(name);
  // }
  //
  // // Service UUID 위젯
  // Widget serviceUUID(BluetoothService r) {
  //   String name = '';
  //   name = r.uuid.toString();
  //   return Text(name);
  // }
  //
  // // Service 정보 아이템 위젯
  // Widget listItem(BluetoothService r) {
  //   return ListTile(
  //     onTap: null,
  //     title: serviceUUID(r),
  //     subtitle: characteristicInfo(r),
  //   );
  // }
}
