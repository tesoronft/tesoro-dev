import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/services/analytics_service.dart';

import '../utils/app_permissions.dart';

class SplashNavigation {
  Future<void> appNavigation(BuildContext context, String accessToken,
      String refreshToken, ApiProvider apis) async {
    // await RemoteConfigService.initialize();
    if (accessToken != '') {
      await context.read<AppPermissions>().checkLocationPermission();
      await apis.getUserData(accessToken);
      await AnalyticsService.logEvent('dashboard_view');
      context.go(Routes.dashboard);
    } else {
      await AnalyticsService.logEvent('onboarding_view');
      context.go(Routes.onboarding1);
    }
  }
}
