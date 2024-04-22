import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataEntryScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController severityController = TextEditingController();
  final TextEditingController allergyController = TextEditingController();
  final TextEditingController emergencyController1 = TextEditingController();
  final TextEditingController emergencyController2 = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  void uploadData(BuildContext context) {
    Map<String, dynamic> data = {
      "name": nameController.text,
      "address": addressController.text,
      "age": ageController.text,
      "gender": genderController.text,
      "severity": severityController.text,
      "allergy": allergyController.text,
      "emergencyPhoneNo1": emergencyController1.text,
      "emergencyPhoneNo2": emergencyController2.text,
      "notesController": notesController.text
    };
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .set(data)
        .then((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Data uploaded successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Error uploading data: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: severityController,
                decoration: InputDecoration(
                    labelText: 'Severity of Asthma(Mild/Moderate/Severe)'),
              ),
              TextField(
                controller: allergyController,
                decoration: InputDecoration(labelText: 'Any known allergies'),
              ),
              TextField(
                controller: emergencyController1,
                decoration: InputDecoration(labelText: 'EmergencyContacts'),
              ),
              TextField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'Additional Notes'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => uploadData(context),
                child: Text('Upload Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
