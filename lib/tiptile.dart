import 'package:flutter/material.dart';

class TipTile extends StatelessWidget {
  final String title;
  final String description;

  TipTile({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        color: Colors.grey,
        margin: EdgeInsets.all(10.0),
        elevation: 5.0,
        child: ListTile(
          contentPadding: EdgeInsets.all(15.0),
          title: Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(description),
        ),
      ),
    );
  }
}
