import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/camera_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/utils/app_permissions.dart';
import 'package:tesoro_nft_app/utils/internet_checker.dart';

import '../providers/dashboard_provider.dart';

class AppProviders {
  static MultiProvider providers({required Widget child}) {
    //Provider.value(value: ObserverList());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return InternetChecker();
        }),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => ApiProvider()),
        ChangeNotifierProvider(create: (context) => PreferencesProvider()),
        ChangeNotifierProvider(create: (context) => CameraProvider()),
        ChangeNotifierProvider(create: (context) => AppPermissions()),
      ],
      child: child,
    );
  }
}
