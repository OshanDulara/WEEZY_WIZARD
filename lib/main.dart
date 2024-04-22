import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weezywizard/mainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'noti.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();
  await notificationService.initNotification();
  await Firebase.initializeApp();
  [
    Permission.bluetoothAdvertise,
    Permission.location,
    Permission.storage,
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan
  ].request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: mainPage(),
    );
  }
}
