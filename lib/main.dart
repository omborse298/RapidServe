import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RapidServeApp());
}

class RapidServeApp extends StatelessWidget {
  const RapidServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}