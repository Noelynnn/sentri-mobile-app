import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sentri/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              'SENTRI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Your Digital Safety Companion',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
