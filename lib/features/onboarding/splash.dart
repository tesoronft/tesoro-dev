import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/splash_navigation.dart';

import '../../providers/api_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = Provider.of<PreferencesProvider>(context, listen: false);
      final apis = Provider.of<ApiProvider>(context, listen: false);
      if (!await GoogleMapsNavigator.areTermsAccepted()) {
        GoogleMapsNavigator.showTermsAndConditionsDialog(
            'Please accept terms and conditions', 'Tesoro NFT');
      }
      Future.delayed(
          Duration(seconds: 2),
          () async => await SplashNavigation().appNavigation(context,
              prefs.accessToken ?? '', prefs.refreshToken ?? '', apis));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        defaultPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              AppImages.splashBackground,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Image.asset(
                    AppImages.world,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    AppStrings.tesoroTheTreasureHunt,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headingLarge,
                  ),
                  Divider(
                    height: 14.0,
                    color: AppColors.lightPrimary,
                  ),
                  Text(
                    AppStrings.oneMansTrashIsAnotherTreasure,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium,
                  ),
                  SpinKitCircle(
                    color: AppColors.light,
                  )
                ],
              ),
            )
          ],
        ));
  }
}
