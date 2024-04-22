import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:weezywizard/noti.dart';

class Bluetooth extends StatefulWidget {
  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final humidityNotifier = ValueNotifier<double>(10);
  final temperatureNotifier = ValueNotifier<double>(10);
  final dustNotifier = ValueNotifier<double>(10);
  final mq2Notifier = ValueNotifier<double>(10);
  final mq7Notifier = ValueNotifier<double>(10);
  final mq135Notifier = ValueNotifier<double>(10);

  final humiditykey = GlobalKey<KdGaugeViewState>();
  final temperaturekey = GlobalKey<KdGaugeViewState>();
  final dustkey = GlobalKey<KdGaugeViewState>();
  final mq2key = GlobalKey<KdGaugeViewState>();
  final mq7key = GlobalKey<KdGaugeViewState>();
  final mq135key = GlobalKey<KdGaugeViewState>();

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  late BluetoothConnection connection;
  late BluetoothDevice mydevice;
  String op = "Press Connect Button";
  Color status = Color.fromARGB(255, 109, 233, 119);
  bool isConnectButtonEnabled = true;
  bool isDisConnectButtonEnabled = false;
  double temperature = 50;
  double humidity = 100;
  double dust = 500;
  double mq2 = 100;

  void _connect() async {
    List<BluetoothDevice> devices = [];
    setState(() {
      isConnectButtonEnabled = false;
      isDisConnectButtonEnabled = true;
    });
    devices = await _bluetooth.getBondedDevices();
    // ignore: unnecessary_statements
    devices.forEach((device) {
      print(device);
      if (device.name == "HC-05") {
        mydevice = device;
      }
    });

    await BluetoothConnection.toAddress(mydevice.address).then((_connection) {
      print('Connected to the device' + mydevice.toString());

      connection = _connection;
    });

    connection.input!.listen((Uint8List data) {
      extractParameters(data);
      //   print('Arduino Data : ${ascii.decode(data)}');
      setState(() {
        op = "Data recieving";
      });
    });

    connection.input!.listen(null).onDone(() {
      print('Disconnected remotely!');
    });
  }

//disconnecting
  void _disconnect() {
    setState(() {
      op = "Disconnected";
      isConnectButtonEnabled = true;
      isDisConnectButtonEnabled = false;
    });
    connection.close();
    connection.dispose();
  }

  void extractParameters(Uint8List data) {
    String dataString = String.fromCharCodes(data);
    List<String> parameters = dataString.split(';');
    if (dataString == 'Failed to read from sensors!') {
      setState(() {
        op = "sensor erorr";
      });
    }
    if (parameters.length >= 2) {
      String temperatureString = parameters[0];
      String humidityString = parameters[1];
      String dustString = parameters[2];
      String mq2String = parameters[3];

      try {
        temperature = double.parse(temperatureString);
        humidity = double.parse(humidityString);
        dust = double.parse(dustString);
        mq2 = double.parse(mq2String);

        print('Temperature: $temperature');
        print('Humidity: $humidity');
        print('Dust: $dust');
        print('co: $mq2');
        humiditykey.currentState!.updateSpeed(humidity);
        humidityNotifier.value = humidity;
        temperaturekey.currentState!.updateSpeed(temperature);
        temperatureNotifier.value = temperature;
        dustkey.currentState!.updateSpeed(dust);
        dustNotifier.value = dust;
        mq2key.currentState!.updateSpeed(mq2);
        mq2Notifier.value = mq2;

        if (dust > 35.5 && dust <= 55.5) {
          NotificationService().showNotification(
              title: 'Alert',
              body:
                  'The air quality around you has reached a concerning level. Take a deep breath, and stay indoors if possible. Your health matters.');
        }
        if (dust > 55.5) {
          NotificationService().showNotification(
              title: 'Danger !!!',
              body:
                  'The air you(\')re breathing is polluted. Guard your lungs, stay vigilant, and protect your well-being');
        }
      } catch (e) {
        print('Error parsing data: $e');
      }
    } else {
      print('Invalid data format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Column(children: [
        SizedBox(height: 20),
        Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white,
              elevation: 50,
              shadowColor: Colors.grey,
              child: Center(
                child: Text(
                  "Please make sure you paired your HC-05, its default password is 1234",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: isConnectButtonEnabled ? _connect : null,
                    child: Text(
                      "CONNECT",
                      style: TextStyle(color: Colors.amberAccent, fontSize: 10),
                    )),
                ElevatedButton(
                    onPressed: isDisConnectButtonEnabled ? _disconnect : null,
                    child: Text(
                      "DISCONNECT",
                      style: TextStyle(color: Colors.amberAccent, fontSize: 10),
                    )),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        color: Color.fromARGB(255, 0, 0, 0),
                        elevation: 100,
                        shadowColor: Colors.black,
                        child: Text(
                          "State: " + op,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 226, 111, 2)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        )),
        SizedBox(height: 25),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: 180,
              height: 180,
              padding: EdgeInsets.all(10),
              child: ValueListenableBuilder<double>(
                  valueListenable: humidityNotifier,
                  builder: (context, value, child) {
                    print(value);
                    return KdGaugeView(
                      key: humiditykey,
                      unitOfMeasurement: 'Relative humidity',
                      minSpeed: 0,
                      maxSpeed: 100,
                      speed: humidity,
                      animate: true,
                      minMaxTextStyle: TextStyle(fontSize: 0),
                      speedTextStyle: TextStyle(
                          fontSize: 25,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      unitOfMeasurementTextStyle: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      alertSpeedArray: [0, 30, 50],
                      alertColorArray: [
                        Colors.orange,
                        Colors.green,
                        Colors.orange
                      ],
                      duration: Duration(seconds: 5),
                    );
                  }),
            ),
            Container(
              width: 180,
              height: 180,
              padding: EdgeInsets.all(10),
              child: ValueListenableBuilder<double>(
                  valueListenable: temperatureNotifier,
                  builder: (context, value, child) {
                    print(value);
                    return KdGaugeView(
                      key: temperaturekey,
                      unitOfMeasurement: 'Temperature:°C',
                      minSpeed: 0,
                      maxSpeed: 50,
                      speed: temperature,
                      fractionDigits: 2,
                      animate: true,
                      minMaxTextStyle: TextStyle(fontSize: 0),
                      speedTextStyle: TextStyle(
                          fontSize: 25,
                          color: const Color.fromARGB(255, 248, 248, 248)),
                      unitOfMeasurementTextStyle: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      alertSpeedArray: [0, 20, 24],
                      alertColorArray: [
                        Colors.orange,
                        Colors.green,
                        Colors.orange
                      ],
                      duration: Duration(seconds: 5),
                    );
                  }),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: 180,
              height: 180,
              padding: EdgeInsets.all(10),
              child: ValueListenableBuilder<double>(
                  valueListenable: dustNotifier,
                  builder: (context, value, child) {
                    print(value);
                    return KdGaugeView(
                      key: dustkey,
                      unitOfMeasurement: 'PM2.5',
                      minSpeed: 0,
                      maxSpeed: 300,
                      speed: dust,
                      animate: true,
                      fractionDigits: 2,
                      minMaxTextStyle: TextStyle(fontSize: 0),
                      speedTextStyle: TextStyle(
                          fontSize: 25,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      unitOfMeasurementTextStyle: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      alertSpeedArray: [0, 12, 35.5, 55.5, 150.5, 250.5],
                      alertColorArray: [
                        Colors.green,
                        Colors.yellow,
                        Colors.orange,
                        Colors.red,
                        Color.fromARGB(255, 175, 74, 238),
                        Color.fromARGB(255, 118, 1, 144)
                      ],
                      duration: Duration(seconds: 5),
                    );
                  }),
            ),
            Container(
              width: 180,
              height: 180,
              padding: EdgeInsets.all(10),
              child: ValueListenableBuilder<double>(
                  valueListenable: mq2Notifier,
                  builder: (context, value, child) {
                    print(value);
                    return KdGaugeView(
                      key: mq2key,
                      unitOfMeasurement: 'CO',
                      minSpeed: 0,
                      maxSpeed: 100,
                      speed: mq2,
                      fractionDigits: 2,
                      animate: true,
                      divisionCircleColors: Colors.white54,
                      minMaxTextStyle: TextStyle(fontSize: 0),
                      speedTextStyle: TextStyle(
                          fontSize: 25,
                          color: const Color.fromARGB(255, 248, 248, 248)),
                      unitOfMeasurementTextStyle: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      alertSpeedArray: [40, 80, 90],
                      alertColorArray: [
                        Colors.orange,
                        Colors.indigo,
                        Colors.red
                      ],
                      duration: Duration(seconds: 5),
                    );
                  }),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: 180,
              height: 180,
              padding: EdgeInsets.all(10),
              child: KdGaugeView(
                unitOfMeasurement: 'Alcohol',
                minSpeed: 0,
                maxSpeed: 300,
                speed: dust,
                animate: true,
                fractionDigits: 2,
                minMaxTextStyle: TextStyle(fontSize: 0),
                speedTextStyle: TextStyle(
                    fontSize: 25,
                    color: const Color.fromARGB(255, 255, 255, 255)),
                unitOfMeasurementTextStyle: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 255, 255, 255)),
                alertSpeedArray: [0, 12, 35.5, 55.5, 150.5, 250.5],
                alertColorArray: [
                  Colors.green,
                  Colors.yellow,
                  Colors.orange,
                  Colors.red,
                  Color.fromARGB(255, 175, 74, 238),
                  Color.fromARGB(255, 118, 1, 144)
                ],
                duration: Duration(seconds: 5),
              ),
            ),
            Container(
              width: 180,
              height: 180,
              padding: EdgeInsets.all(10),
              child: KdGaugeView(
                unitOfMeasurement: 'Smoke',
                minSpeed: 0,
                maxSpeed: 100,
                speed: mq2,
                fractionDigits: 2,
                animate: true,
                divisionCircleColors: Colors.white54,
                minMaxTextStyle: TextStyle(fontSize: 0),
                speedTextStyle: TextStyle(
                    fontSize: 25,
                    color: const Color.fromARGB(255, 248, 248, 248)),
                unitOfMeasurementTextStyle: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 255, 255, 255)),
                alertSpeedArray: [40, 80, 90],
                alertColorArray: [Colors.orange, Colors.indigo, Colors.red],
                duration: Duration(seconds: 5),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
