import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class SplashNavigation {
  void appNavigation(BuildContext context, String token) {
    if (token != '') {
      context.go(Routes.dashboard);
    } else {
      context.go(Routes.onboarding1);
    }
  }
}
