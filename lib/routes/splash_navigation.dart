import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class SplashNavigation {
  void nonPremiumLoggedInUser() {}
  void nonPremiumLoggedOutUser(BuildContext context) {
    context.go(Routes.onboarding1);
  }

  void premiumLoggedInUser() {}
  void premiumLoggedOutUser() {}
}
