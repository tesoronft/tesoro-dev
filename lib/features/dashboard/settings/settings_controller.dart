import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/app_share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController {
  static Future<void> performNavigation(
      int index, String contentId, BuildContext context) async {
    switch (index) {
      case 0:
        context.push(Routes.userAccount);
        break;
      case 1:
        context.push(Routes.subscriptionViewOne);
        break;
      case 2:
        context.push(Routes.webView, extra: contentId);
        break;
      case 3:
        await launchUrl(Uri.parse(''));
        break;
      case 6:
        AppShare.shareApp();
        break;
      default:
    }
  }
}
