import 'package:flutter/material.dart';

void main() {
  runApp(const RapidServeApp());
}

class RapidServeApp extends StatelessWidget {
  const RapidServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("RapidServe"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            "Welcome to RapidServe",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}