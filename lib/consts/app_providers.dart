import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/camera_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/utils/app_permissions.dart';

import '../providers/dashboard_provider.dart';

class AppProviders {
  static MultiProvider providers({required Widget child}) {
    //Provider.value(value: ObserverList());
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) {
        //   log('🟡 [PROVIDERS] Creating InternetChecker');
        //   return InternetChecker();
        // }),
        ChangeNotifierProvider(create: (context) {
          return DashboardProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return ApiProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return PreferencesProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return CameraProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return AppPermissions();
        }),
      ],
      child: child,
    );
  }
}
