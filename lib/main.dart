import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';

import 'screens/customer/home_screen.dart';
import 'screens/provider/provider_dashboard_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

import 'utils/app_routes.dart';

void main() {
  runApp(const RapidServe());
}

class RapidServe extends StatelessWidget {
  const RapidServe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.splash,

      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),

        AppRoutes.login: (context) => const LoginScreen(),

        AppRoutes.register: (context) => RegisterScreen(),

        AppRoutes.forgotPassword: (context) =>
            ForgotPasswordScreen(),

        AppRoutes.customerHome: (context) =>
            HomeScreen(),

        AppRoutes.providerDashboard: (context) =>
            ProviderDashboardScreen(),

        AppRoutes.adminDashboard: (context) =>
            AdminDashboardScreen(),
      },
    );
  }
}