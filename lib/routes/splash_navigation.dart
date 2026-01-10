import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class SplashNavigation {
  Future<void> appNavigation(BuildContext context, String accessToken,
      String refreshToken, ApiProvider apis) async {
    if (accessToken != '') {
      // await apis.getRefreshToken(refreshToken);
      final result = await apis.getUserData(accessToken);
      context.go(Routes.dashboard);
    } else {
      context.go(Routes.onboarding1);
    }
  }
}
