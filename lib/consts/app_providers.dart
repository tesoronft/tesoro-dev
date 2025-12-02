import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';

class AppProviders {
  static MultiProvider providers({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
      ],
      child: child,
    );
  }
}
