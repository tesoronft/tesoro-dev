import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/app_share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController {
  static Future<void> performNavigation(int index, String privacyPolicyId,
      String termsAndConditionsId, BuildContext context) async {
    switch (index) {
      case 0:
        context.push(Routes.updateProfile);
        break;
      case 1:
        await launchUrl(Uri.parse('https://tesoroapp.io/about'));
        break;
      case 2:
        context.push(Routes.webView, extra: privacyPolicyId);
        break;
      case 3:
        context.push(Routes.webView, extra: termsAndConditionsId);
        break;
      case 4:
        await launchUrl(Uri.parse(''));
        break;
      case 5:
        await launchUrl(Uri.parse(
            'mailto:x@tesoroapp.io?subject=Feedback for Tesoro App&body=Hi, I would like to share the following feedback...'));
        break;
      case 6:
        await launchUrl(Uri.parse('https://tesoroapp.io/contact-us'));
        break;
      case 7:
        AppShare.shareApp();
        break;
      default:
    }
  }
}
