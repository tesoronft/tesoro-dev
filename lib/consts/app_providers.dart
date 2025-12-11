import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';

import '../providers/dashboard_provider.dart';

class AppProviders {
  static MultiProvider providers({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => ApiProvider()),
        ChangeNotifierProvider(create: (context) => PreferencesProvider()),
      ],
      child: child,
    );
  }
}
