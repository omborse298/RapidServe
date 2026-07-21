import 'package:flutter/material.dart';

import '../screens/provider/active_jobs_screen.dart';

class AppRoutes {
  static const String activeJobs = '/active-jobs';

  static final Map<String, WidgetBuilder> routes = {
    activeJobs: (context) => const ActiveJobsScreen(),
  };
}