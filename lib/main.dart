import 'package:flutter/material.dart';
import 'screens/report_crime_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sentri',
      home: ReportCrimeScreen(), // Change this to the desired initial screen
    );
  }
}
