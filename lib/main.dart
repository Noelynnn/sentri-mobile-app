import 'package:flutter/material.dart';

import 'package:sentri/screens/splash_screen.dart';
import 'package:sentri/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sentri',
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
