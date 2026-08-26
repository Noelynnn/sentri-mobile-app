import 'package:flutter/material.dart';
import 'package:sentri/screens/check_scam_screen.dart';
import 'package:sentri/screens/login_screen.dart';
import 'package:sentri/screens/onboarding_flow.dart';
import 'package:sentri/screens/register_screen.dart';
import 'package:sentri/screens/welcome_screen.dart';
import 'package:sentri/screens/splash_screen.dart';
import 'package:sentri/screens/forgot_password_screen.dart';

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
      home: CheckScamScreen(),
    );
  }
}
