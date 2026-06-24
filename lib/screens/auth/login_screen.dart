import 'package:flutter/material.dart';
import '../../utils/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RapidServe Login"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.customerHome,
            );
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}