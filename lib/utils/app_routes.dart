import 'package:flutter/material.dart';

import '../screens/customer/splash_screen.dart';
import '../screens/customer/login_screen.dart';
// Change this import inside lib/utils/app_routes.dart to point to the correct file:
import 'package:rapidserve/screens/customer/register_screen.dart'; // <-- Point this to where your form code is!
import '../screens/customer/home_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const customerHome = "/customerHome";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    customerHome: (context) => const HomeScreen(),
  };
}