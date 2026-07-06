import 'package:flutter/material.dart';

import '../screens/customer/splash_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/customer/home_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String register = "/register";
  static const customerHome = "/customerHome";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    register: (context) => const RegisterScreen(),
    customerHome: (context) => const HomeScreen(),
  };
}