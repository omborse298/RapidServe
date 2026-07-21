import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'utils/app_routes.dart';

void main() {
  runApp(
    const ProviderScope(
      child: RapidServeApp(),
    ),
  );
}

class RapidServeApp extends StatelessWidget {
  const RapidServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rapid Serve',

      initialRoute: AppRoutes.activeJobs,

      routes: AppRoutes.routes,
    );
  }
}