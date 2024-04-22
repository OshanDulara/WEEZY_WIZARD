import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weezywizard/bluetooth.dart';
import 'dart:async';
import 'tiptile.dart';
import 'dataEntry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          Bluetooth(),
          AirQualityPage(),
          TipPage(),
          ThirdPage()
        ],
        index: _selectedIndex,
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          color: Colors.cyan,
          backgroundColor: Colors.black,
          animationCurve: Curves.easeInSine,
          onTap: _onPageChanged,
          animationDuration: Duration(milliseconds: 200),
          items: [
            Icon(Icons.verified_user),
            Icon(Icons.analytics),
            Icon(Icons.tips_and_updates),
            Icon(Icons.manage_accounts),
          ]),
    );
  }
}

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final user = FirebaseAuth.instance.currentUser!;
  String? name;
  String? age;
  String? gender;
  String? severity;
  String? emergency1;

  Future<void> fetchData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      QuerySnapshot querySnapshot = await users.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        // Access the data for each document
        name = data['name'];
        age = data['age'];
        gender = data['gender'];
        severity = data['severity'];
        emergency1 = data['emergencyPhoneNo1'];
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the function in initState
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 80,
        ),
        CircleAvatar(
          radius: 50.0,
          child: Image.asset(
            "assets/images/user.png",
          ), // Adjust the radius as needed for the desired size
          // or use AssetImage for local images
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            '$name',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            'Age: $age',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            'Gender: $gender',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            'Severity of Asthma: $severity',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            'Emergency Phone Numbers: $emergency1',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataEntryScreen()),
            );
          },
          child: Text('Update Details'),
        ),
        ElevatedButton(
          onPressed: () {
            fetchData();
            setState(() {});
          },
          child: Text('Refresh'),
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          'signed in as ' + user.email!,
          style: TextStyle(color: Colors.green),
        ),
        MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          color: Colors.lightBlue,
          child: Text("sign out"),
        ),
      ],
    ));
  }
}

class TipPage extends StatelessWidget {
  final List<Tip> tips = [
    Tip(
        title: 'Proper Inhaler Use:',
        description:
            'After using your inhaler, rinse your mouth to reduce the risk of oral thrush'),
    Tip(
        title: 'Breathing Techniques:',
        description:
            'Practice deep breathing exercises to help strengthen your lungs and improve breathing control'),
    Tip(
        title: 'Allergen Management',
        description:
            'Regularly clean and vacuum your home to minimize exposure to dust mites and pet dander'),
    Tip(
        title: 'Weather Awareness',
        description:
            'On high pollen days, try to stay indoors during peak pollen times (usually in the morning'),
    Tip(
        title: 'Exercise Tips',
        description:
            'Engage in asthma-friendly exercises like swimming or walking to improve your cardiovascular fitness without overexertion'),
    Tip(
        title: 'Diet and Nutrition',
        description:
            'Include anti-inflammatory foods like fruits, vegetables, and omega-3 fatty acids in your diet to support asthma management'),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Daily Tips'),
        ),
        body: ListView.builder(
          itemCount: tips.length,
          itemBuilder: (context, index) {
            return TipTile(
              title: tips[index].title,
              description: tips[index].description,
            );
          },
        ),
      ),
    );
  }
}

class Tip {
  final String title;
  final String description;

  Tip({required this.title, required this.description});
}

class AirQualityPainter extends CustomPainter {
  final double averageTemperature;
  final double averageHumidity;
  final double averagePM25;
  final double co;

  AirQualityPainter({
    required this.averageTemperature,
    required this.averageHumidity,
    required this.averagePM25,
    required this.co,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.transparent;

    // Draw circles (bubbles) for temperature, humidity, and PM2.5
    drawCircle(canvas, size, paint, Colors.red, averageTemperature, 0.2, 0.7,
        'Temperature');
    drawCircle(canvas, size, paint, Colors.blue, averageHumidity, 0.5, 0.2,
        'Humidity');
    drawCircle(
        canvas, size, paint, Colors.green, averagePM25, 0.3, 1.05, 'PM 2.5');
    drawCircle(canvas, size, paint, Color.fromARGB(255, 228, 33, 166), co, 0.7,
        0.8, 'CO');
  }

  void drawCircle(Canvas canvas, Size size, Paint paint, Color color,
      double value, double centerX, double centerY, String word) {
    final radius = value * size.width / 200;
    final center = Offset(size.width * centerX, size.height * centerY);
    paint.color = color.withOpacity(0.9);

    canvas.drawCircle(center, radius, paint);

    // Draw the text inside the circle
    final textPainter = TextPainter(
      text: TextSpan(
        text: ('$word\n $value'), // Format the value as needed
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class AirQualityPage extends StatefulWidget {
  @override
  _AirQualityPageState createState() => _AirQualityPageState();
}

class _AirQualityPageState extends State<AirQualityPage> {
  double averageTemperature = 30.5; // Replace with your actual data
  double averageHumidity = 70.0; // Replace with your actual data
  double averagePM25 = 23.2;
  double averageCo = 34; // Replace with your actual data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Last 24 Hour Data'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(400, 400), // Adjust the size as needed
          painter: AirQualityPainter(
              averageTemperature: averageTemperature,
              averageHumidity: averageHumidity,
              averagePM25: averagePM25,
              co: averageCo),
        ),
      ),
    );
  }
}
