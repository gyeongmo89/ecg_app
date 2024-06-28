// // 지문인식 (향후 고도화 기능으로 하려고 구현했던 것임, 현재는 불필요하여 주석처리)
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:local_auth_android/local_auth_android.dart';// for AndroidAuthMessages
// import 'package:local_auth_ios/local_auth_ios.dart';// for IOSAuthMessages
//
// class LocalAuthApi {
//   static final _auth = LocalAuthentication();
//
//   static Future<bool> hasBiometrics() async {
//     try {
//       return await _auth.canCheckBiometrics ?? false;
//     } on PlatformException catch (e) {
//       print(e);
//     }
//     return false;
//   }
//
//   static Future<List<BiometricType>> getBiometrics() async {
//     try {
//       return await _auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       print(e);
//     }
//     return <BiometricType>[];
//   }
//
//   static Future<bool> authenticate() async {
//     final isAvailable = await hasBiometrics();
//     if (!isAvailable) return false;
//
//     try {
//       return await _auth.authenticate(
//           localizedReason: '생체정보를 인식해주세요.',
//           options: const AuthenticationOptions(
//             biometricOnly: true,
//             useErrorDialogs: true,
//             stickyAuth: true,
//           ),
//           authMessages: [
//             IOSAuthMessages(
//               lockOut: '생체인식 활성화',
//               goToSettingsButton: '설정',
//               goToSettingsDescription: '기기 설정으로 이동하여 생체 인식을 등록하세요.',
//               cancelButton: '취소',
//               localizedFallbackTitle: '다른 방법으로 인증',
//             ),
//             AndroidAuthMessages(
//               biometricHint: '생체 정보를 스캔하세요.',
//               biometricNotRecognized: '생체정보가 일치하지 않습니다.',
//               biometricRequiredTitle: '생체',
//               biometricSuccess: '로그인',
//               cancelButton: '취소',
//               deviceCredentialsRequiredTitle: '생체인식이 필요합니다.',
//               deviceCredentialsSetupDescription: '기기 설정으로 이동하여 생체 인식을 등록하세요.',
//               goToSettingsButton: '설정',
//               goToSettingsDescription: '기기 설정으로 이동하여 생체 인식을 등록하세요.',
//               signInTitle: '계속하려면 생체 인식을 스캔',
//             )
//           ]
//       );
//     } on PlatformException catch (e) {
//       print(e);
//     }
//     return false;
//   }
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     LocalAuthApi.authenticate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Local Auth Example'),
//         ),
//         body: Center(
//           child: Text('Please authenticate'),
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MyApp());
// }