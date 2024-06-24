// 2024-04-03 11:44 40~50사이의 수가 차트를 벗어나서 그려져서 차트영역 수정시작
// 2024-04-03 13:44 수신 데이터를 차트로 바로 적용되도록 시작1
// 2024-04-03 17:22 수신 데이터를 차트로 바로 적용되도록 완료
// 2024-04-03 18:41 차트 출력 완료
// 2024-04-03 18:42 차트가 시간이 갈수록 모여져서 넓게 보이도록 수정시작
// 2024-04-09 15:21 변경된 HW 적용 시작 1
// 2024-04-09 17:36 변경된 HW 적용 완료
// 2024-04-11 10:35 HW가 이동되어 Disconnect 후 가까이오면 다시 Connect 되도록 추가 시작 1
// 2024-04-11 16:26 차트 추가 삭제 갯수 동일하게 해서 x축 찌거리지는 문제 해결
// 2024-04-11 16:27 차트가 그리드 위에 그려지도록 수정시작 1
// 2024-04-12 17:03 ecg_card 코드 병합
// 2024-04-18 10:28 차트 배경색 추가 시작 1
// 2024-05-07 15:26 Event 버튼 클릭시 팝업창 뜨도록 하는 함수 추가 시작1
// 2024-06-19 16:55 flutter_blue_plus library 업데이트 시작

import 'dart:async';
import 'package:ecg_app/common/const/colors2.dart';
import 'package:ecg_app/symptom_note/component/schedule_bottom_sheet.dart';
import 'package:ecg_app/symptom_note/view/symptom_note2_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;

class DeviceScreen extends StatefulWidget {
  DeviceScreen({Key? key, required this.device}) : super(key: key);
  // 장치 정보 전달 받기
  final BluetoothDevice device;

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<double> ecgData = []; // 수신된 데이터 저장용
  List<double> dividedValue = []; // 클래스 멤버 변수로 선언
  Timer? timer;
  int dataIndex = 0;
  // AES-128, 암호화 로 추가
  // String decryptAES128(Uint8List encryptedData, String key) {
  //   final keyForAES = encrypt.Key.fromUtf8(key);
  //   final ivForAES = encrypt.IV.fromLength(16);
  //
  //   final encrypter = encrypt.Encrypter(encrypt.AES(keyForAES));
  //
  //   final decryptedData = encrypter.decrypt64(base64UrlEncode(encryptedData), iv: ivForAES);
  //
  //   return decryptedData;
  // }

  // flutterBlue
  // FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  FlutterBluePlus flutterBlue = FlutterBluePlus();

  // 연결 상태 표시 문자열
  String stateText = 'Connecting';

  // 연결 버튼 문자열
  String connectButtonText = 'Disconnect';

  // 현재 연결 상태 저장용
  BluetoothConnectionState deviceState = BluetoothConnectionState.disconnected;

  // 연결 상태 리스너 핸들 화면 종료시 리스너 해제를 위함
  StreamSubscription<BluetoothConnectionState>? _stateListener;

  List<BluetoothService> bluetoothService = [];

  //
  // Map<String, List<int>> notifyDatas = {};
  Map<String, List<double>> notifyDatas = {};

  @override
  initState() {
    super.initState();
    // startTimer();

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
    // 상태 리스터 해제
    _stateListener?.cancel();
    // 연결 해제
    disconnect();

    // 위젯이 파괴되는 시점에 ecgData 배열을 비웁니다.
    ecgData.clear();
    print("Disopose에서 clear 함수 실행");
    super.dispose();
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
    final connectionState = Provider.of<ConnectionState>(context, listen: false); // 상태관리를 위해 추가(2024-04-12 15:48)
    switch (event) {
      case BluetoothConnectionState.disconnected:
        connectionState.stateText = 'Disconnected';
        stateText = 'Disconnected';
        // 버튼 상태 변경
        connectButtonText = 'Connect';
        ecgData.clear();
        connect(); // 연결이 다시 활성화되면 서비스를 다시 발견하고 특성에 대한 알림을 다시 설정 //04-11 추가(자동 연결시 데이터 다시 자동으로 불러와야하기 때문)
        break;
      case BluetoothConnectionState.disconnecting:
        connectionState.stateText = 'Disconnecting';
        stateText = 'Disconnecting';
        break;
      case BluetoothConnectionState.connected:
        connectionState.stateText = 'Connected';
        stateText = 'Connected';
        // 버튼 상태 변경
        connectButtonText = 'Disconnect';

        // connect(); // 연결이 다시 활성화되면 서비스를 다시 발견하고 특성에 대한 알림을 다시 설정 //04-11 추가(자동 연결시 데이터 다시 자동으로 불러와야하기 때문)
        // discoverServices();
        break;
      case BluetoothConnectionState.connecting:
        connectionState.stateText = 'Connecting...';
        stateText = 'Connecting..';
        break;
    }
    //이전 상태 이벤트 저장
    deviceState = event;
    setState(() {});
  }

  Future<bool> connect() async {  //여기 실행않됨 ecgCard에서 실행됨
    Future<bool>? returnValue;

    // Check if the device is already connected
    if (widget.device.state == BluetoothConnectionState.connected) {
      debugPrint('Device is already connected');
      return Future.value(true);
    }

    await widget.device
        // .connect(autoConnect: false)
        // .connect(autoConnect: false, mtu: null)
        .connect(autoConnect: true, mtu: null)  //true로 하면 에러남
        .timeout(Duration(milliseconds: 15000), onTimeout: () {
      //타임아웃 발생
      //returnValue를 false로 설정
      returnValue = Future.value(false);
      debugPrint('timeout failed');

      //연결 상태 disconnected로 변경
      // setBleConnectionState(BluetoothDeviceState.disconnected);
    }).then((data) async {
      bluetoothService.clear();
      if (returnValue == null) {
        //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
        debugPrint('connection successful');
        print('start discover service');
        List<BluetoothService> bleServices =
            await widget.device.discoverServices();
        setState(() {
          bluetoothService = bleServices;
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


            // Check if the service is the Device Information service
            if (service.uuid == Guid('0000180a-0000-1000-8000-00805f9b34fb')) {
              print("??");
              // Check if the characteristic is the Manufacturer Name String
              if (c.uuid == Guid('00002a29-0000-1000-8000-00805f9b34fb')) {
                print("???");
                c.read().then((value) {
                  print("????");
                  print(
                      '\t\tManufacturer Name: ${String.fromCharCodes(value)}');
                });
              }
              // Check if the characteristic is the Firmware Revision String
              else if (c.uuid == Guid('00002a26-0000-1000-8000-00805f9b34fb')) {
                c.read().then((value) {
                  print(
                      '\t\tFirmware Revision: ${String.fromCharCodes(value)}');
                });
              }
            }

            // notify나 indicate가 true면 디바이스에서 데이터를 보낼 수 있는 캐릭터리스틱이니 활성화 한다.
            // 단, descriptors가 비었다면 notify를 할 수 없으므로 패스!
            if (c.properties.notify && c.descriptors.isNotEmpty) {
              // 진짜 0x2902 가 있는지 단순 체크용!
              for (BluetoothDescriptor d in c.descriptors) {
                print('BluetoothDescriptor uuid ${d.uuid}');
                // if (d.uuid == BluetoothDescriptor.cccd) {
                //   print('d.lastValue: ${d.lastValue}');
                // }
              }

              // notify가 설정 안되었다면...
              if (!c.isNotifying) {
                try {
                  await c.setNotifyValue(true);
                  // 받을 데이터 변수 Map 형식으로 키 생성
                  notifyDatas[c.uuid.toString()] = List.empty();
                  c.value.listen((value) {
                    // 수신받는 value 는 아스키코드로 인코딩된 문자열임
                    // Uint8List를 String으로 변환, 이렇게 하면 각 숫자가 해당하는 ASCII 문자로 변환 됨
                    // 변환된 문자열을 쉼표로 분할하여 각 부분을 별도의 문자열로 변환
                    // 각 문자열을 double로 변환
                    print(
                        "기기로 부터 수신된 데이터 값: $value, 데이터 타입: ${value.runtimeType}");
                    //AES-128, 암호화 KEY = 8439thRgeIo90j34Q

                    String key = '8439thRgeIo90j34Q'; //AES-128, 암호화 KEY

                    Uint8List originalData = Uint8List.fromList(value);
                    String asciiString = String.fromCharCodes(originalData);
                    List<String> stringParts = asciiString.split(',');
                    print(
                        "심전도 기기로부터 In setNotifyValue stringParts: $stringParts,Tyep: ${stringParts.runtimeType}");

                    // List<double> dividedValue = // 여기서 문제 발생
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
                      // _onDataReceived(value);  04-18 ecgData데이터 3번연속 출력 때문에 임시주석
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
      }
    });

    return returnValue ?? Future.value(false);
  }

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
      // // 연결이 해제되면 ecgData 배열을 비웁니다.
      // print("Disconnect에서 clear 함수 실행1");
      // ecgData.clear();
      // print("Disconnect에서 clear 함수 실행2");
      timer?.cancel(); // 타이머를 취소(안그러면 재연결시 속도가 빨라짐)
      print("FLAG3-2");
      setState(() {
        // print("Disconnect에서 clear 함수 실행3");
        stateText = 'Disconnect';
        ecgData.clear();
        print("Disconnect에서 clear 함수 실행_device_screen");
      });
      widget.device.disconnect();
    } catch (e) {
      print("Disconnect에서 catch문");
    }
  }

  // void onDataReceived(List<double> ecgData) {
  //   // Assuming ecgData is a list of double values received from BLE
  //   print("onDataReceived 함수 진입");
  //   if (ecgData.contains(19.0)) {
  //     print("이벤트 버튼 클릭(지금은 19.0)");
  //     _showEventPopup();
  //   }
  // }

  // void _showEventPopup() {
  //   // Assuming you are inside a stateful widget and have a context available
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
  //               // Add your code here to handle the "나중에" button press
  //             },
  //           ),
  //           TextButton(
  //             child: Text('증상작성'),
  //             onPressed: () {
  //               // ScheduleBottomSheet()로 이동
  //               showModalBottomSheet(
  //                 context: context,
  //                 isScrollControlled: true,
  //                 builder: (_) {
  //                   return ScheduleBottomSheet(
  //                     selectedDate: selectedDay, // 필요한 날짜를 전달하세요.
  //                     scheduleId: null,
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

  // Event 버튼 클릭시 팝업창 뜨도록 하는 함수 추가로 원래코드 임시주석
  // void _onDataReceived(List<int> value) {
  //   Uint8List originalData = Uint8List.fromList(value);
  //   String asciiString = String.fromCharCodes(originalData);
  //   List<String> stringParts = asciiString.split(',');
  //   print(
  //       "In _onDataReceived() stringParts: $stringParts,Tyep: ${stringParts.runtimeType}");
  //   // List<double> dividedValue =   // 여기서 문제 발생
  //   //     stringParts.map((s) => double.parse(s)).toList();
  //
  //   // List<double> dividedValue = stringParts.map((s) => double.parse(s.replaceAll('\n', ''))).toList();
  //
  //   List<String> lines = asciiString.split('\n');
  //   List<double?> dividedValue = [];
  //   for (var line in lines) {
  //     List<String> stringParts = line.split(',');
  //     dividedValue.addAll(stringParts.map((s) {
  //       try {
  //         return double.parse(s);
  //       } catch (e) {
  //         print('Unable to parse "$s" into a double.');
  //         return null;
  //       }
  //     }));
  //   }
  //
  //   print("dividedValue --------> $dividedValue");
  //
  //   // Remove 0.0 from dividedValue
  //   dividedValue = dividedValue.where((item) => item != 0.0).toList();
  //
  //   // Print the number of data points added in each update
  //   print('Number of data points added: ${dividedValue.length}');
  //
  //   setState(() {
  //     // ecgData = dividedValue; // dividedValue를 ecgData에 할당
  //     // ecgData.addAll(dividedValue); // dividedValue를 ecgData에 추가
  //     // ecgData.addAll(dividedValue
  //     //     .where((item) => item != null)
  //     //     .map((item) => item!)
  //     //     .toList());
  //     //
  //     // // Remove the same number of oldest data points from ecgData
  //     // // if (ecgData.length > 250) { // 데이터가 500개 이상일 때만 삭제(삭제속도)
  //     // if (ecgData.length > 200) {
  //     //   // 데이터가 500개 이상일 때만 삭제(삭제속도)
  //     //   // if (ecgData.length > 150) { // 데이터가 500개 이상일 때만 삭제(삭제속도)
  //     //
  //     //   ecgData.removeRange(0, dividedValue.length);
  //     // }
  //     // if (ecgData.length > 150) { // 데이터가 500개 이상일 때만 삭제(삭제속도)
  //     //   ecgData.removeRange(0, dividedValue.length);
  //     // }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /* 장치명 */
        title: Text(widget.device.name),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /* 연결 상태 */
              Text('$stateText'),
              /* 연결 및 해제 버튼 */
              // OutlinedButton(
              //     onPressed: () {
              //       if (deviceState == BluetoothDeviceState.connected) {
              //         /* 연결된 상태라면 연결 해제 */
              //         disconnect();
              //       } else if (deviceState ==
              //           BluetoothDeviceState.disconnected) {
              //         /* 연결 해재된 상태라면 연결 */
              //         connect();
              //       }
              //     },
              //     child: Text(connectButtonText)),
              /* Chart 버튼 */
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              // EcgChart2(dividedValue: dividedValue)),
                              EcgChart2(dividedValue: ecgData)),
                    );
                  },
                  child: Text('Chart')),
            ],
          ),

          /* 연결된 BLE의 서비스 정보 출력 */
          Expanded(
            child: ListView.separated(
              itemCount: bluetoothService.length,
              itemBuilder: (context, index) {
                return listItem(bluetoothService[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
          ),
        ],
      )),
    );
  }

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

  // void _EventPopup() {
  //   AlertDialog(
  //     title: Text('CLtime의 EVENT 버튼을 누르셨습니다.\n증상 노트를 작성하시겠습니까?'),
  //     actions: <Widget>[
  //       TextButton(
  //         child: Text('나중에'),
  //         onPressed: () {
  //           // Add your code here to handle the "나중에" button press
  //         },
  //       ),
  //       TextButton(
  //         child: Text('증상작성'),
  //         onPressed: () {
  //           TextButton(
  //             child: Text('증상작성'),
  //             onPressed: () {
  //               // ScheduleBottomSheet()로 이동
  //               showModalBottomSheet(
  //                 context: context,
  //                 isScrollControlled: true,
  //                 builder: (_) {
  //                   return ScheduleBottomSheet(
  //                     selectedDate: selectedDay, // 필요한 날짜를 전달하세요.
  //                     scheduleId: null,
  //                   );
  //                 },
  //               );
  //             },
  //           )
  //         },
  //       ),
  //     ],
  //   );
  // }
}

// Status 상태관리를 위해 추가(2024-04-12 15:47)
class ConnectionState with ChangeNotifier {
  String _stateText = 'Disconnected';

  String get stateText => _stateText;

  set stateText(String value) {
    _stateText = value;
    notifyListeners();
  }
}

//---------------------------------------------------
class EcgChartPainter extends CustomPainter {
  final List<double> ecgData;
  final Paint backgroundPaint;

  EcgChartPainter(this.ecgData, this.backgroundPaint);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background using backgroundPaint
    canvas.drawRect(Offset.zero & size, backgroundPaint);
    final double chartWidth = size.width;
    final double chartHeight = size.height;
    final double dataSpacing =
        chartWidth / ecgData.length; // dataSpacing을 여기서 계산

    // final Paint backgroundPaint = Paint()
    //   // // 배경색을 회색으로 설정
    //   // ..color = Colors.grey
    //   // 배경색을 검정색으로 설정
    //   ..color = Colors.black
    //   ..strokeWidth = 0.5;

    final Paint thickGridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0; // 중앙 정사각형을 두껍게 그리기 위한 페인트

    final Paint thinGridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.3; // 작은 정사각형을 얇게 그리기 위한 페인트

    List<Color> gradientColors = [
      // AppColors.contentColorGreen,
      AppColors.contentColorCyan,
      AppColors.contentColorBlue,
      AppColors.contentColorPink,
      // AppColors.contentColorRed,
    ];

    final Paint chartPaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
      ).createShader(
          Rect.fromPoints(Offset(0, 0), Offset(chartWidth, chartHeight)))
      // ..strokeWidth = 0.5
      // ..color = Colors.red // 차트를 빨간색으로 설정
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // final double dataSpacing = chartWidth / ecgData.length;

    // 배경을 그리는 부분
    for (double i = 0; i < chartWidth; i += 10) {
      if ((i / 10).round() % 5 == 0) {
        canvas.drawLine(Offset(i, 0), Offset(i, chartHeight), thickGridPaint);
      } else {
        canvas.drawLine(Offset(i, 0), Offset(i, chartHeight), thinGridPaint);
      }
    }

    for (double i = 0; i < chartHeight; i += 10) {
      if ((i / 10).round() % 5 == 0) {
        canvas.drawLine(Offset(0, i), Offset(chartWidth, i), thickGridPaint);
      } else {
        canvas.drawLine(Offset(0, i), Offset(chartWidth, i), thinGridPaint);
      }
    }

    final Path path = Path();
    if (ecgData.isNotEmpty) {
      //데이터 켈리브레이션
      // 데이터를 정규화합니다.
      print("ecgData-------------------------------> $ecgData");
      print("FLAG1");
      //here it is
      print("FLAG2");
      // final List<double> normalizedData =
      //     ecgData.map((v) => v / 700).toList(); //이게 베스트 프로토 타입 250Hz

      // here

      final List<double> normalizedData =
      ecgData.map((v) => v / 1100).toList(); //이게 베스트 프로토 타입 250Hz** 원래 아래꺼 였는데 이걸로 변경함
          // ecgData.map((v) => v / 700).toList(); //이게 베스트 프로토 타입 250Hz***
      // ecgData.map((v) => v / 300).toList(); //기기판 250Hz
      // ecgData.map((v) => v / 200).toList(); //기기판 250Hz
      // ecgData.map((v) => v / 150).toList(); //기기판 250Hz

      path.moveTo(
          0,
          chartHeight *
              (1 - ecgData.first / 600)+50); // 시작 위치를 아래로 조정함(이게 베스트 프로토 타입 250Hz)
              // (1 - ecgData.first / 600)); // 시작 위치를 아래로 조정함(이게 베스트 프로토 타입 250Hz) 원래이거였음
      // chartHeight * (1 - ecgData.first / 300) -50); // 시작 위치를 아래로 조정함(기기판 250Hz)

      for (int i = 1; i < normalizedData.length; i++) {
        final double x = i * dataSpacing;
        final double y = chartHeight *
            (1 - normalizedData[i]); //Y축 위치조정(이게 베스트 프로토 타입 250Hz)
        // final double y = chartHeight * (1 - normalizedData[i]) - 50; //Y축 위치조정(기기판 250Hz)
        path.lineTo(x, y);
      }
    } else {
      print("ecgData is empty!");
      ecgData.clear();
      print("ecgData is empty!~!");
    }
    canvas.drawPath(path, chartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class EcgChart2 extends StatefulWidget {
  final List<double> dividedValue;

  EcgChart2({required this.dividedValue});

  @override
  _EcgChartState createState() => _EcgChartState(dividedValue);
}

class _EcgChartState extends State<EcgChart2> {
  List<double> dividedValue;
  List<double> ecgData = [];
  Timer? timer;
  int dataIndex = 0;

  _EcgChartState(this.dividedValue);

  final Paint backgroundPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 0.5;

  @override
  void initState() {
    super.initState();
    ecgData = dividedValue; // dividedValue를 ecgData에 할당 16:43 주석
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    // 연결 해제
    ecgData.clear();
    print("Disopose에서 clear 함수 실행");

    super.dispose();
  }

  void startTimer() {
    const interval = Duration(milliseconds: 350); // 차트 속도(이게 베스트 프로토 타입 250Hz)

    // const interval = Duration(milliseconds: 30); // 차트 속도(**)//기판 여기까지

    timer = Timer.periodic(interval, (timer) {
      final double newValue =
          _generateEcgData(); // assuming _generateEcgData() returns a single new element
      setState(() {
        ecgData.removeAt(0);
      });
    });
  }

  double _generateEcgData() {
    if (ecgData.isEmpty) {
      print("ecgData is empty!");
      return 0.0;
    }

    // Check if dataIndex is within the range of ecgData
    if (dataIndex >= ecgData.length) {
      dataIndex = 0;
    }

    final double value = ecgData[dataIndex];
    dataIndex = (dataIndex + 1) % ecgData.length;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width, // 화면 너비의 80%
        height: 0.2, // 화면 높이의 50%

        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: Color(0xFF232628),
        ),
        child: CustomPaint(
          painter: EcgChartPainter(ecgData, backgroundPaint),
          size: Size(double.infinity, 100), //(*원래)
        ),
      ),
    );
  }
}

//원래 pubsepc.lock
// flutter_blue_plus:
// dependency: "direct main"
// description:
// name: flutter_blue_plus
// sha256: "35494cd7b303814a156a57e4ec00a29427c59a62f3d44079b772ef685ae4914f"
// url: "https://pub.dev"
// source: hosted
// version: "1.32.2"
