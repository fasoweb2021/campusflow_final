import 'package:flutter/material.dart';

void main() {
  runApp(const CampusFlowApp());
}

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CampusFlow',
      home: Scaffold(
        body: Center(
          child: Text('CampusFlow'),
        ),
      ),
    );
  }
}
