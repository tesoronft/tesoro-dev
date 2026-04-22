import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/platforms_signin_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/auth_card.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../../../custom_widgets/custom_snackbar.dart';
import '../../../enums/api_enums.dart';
import '../../../enums/snack_bar_enums.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(AppImages.splashBackground, fit: BoxFit.fill),
        SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              AuthCard(
                  issSignin: true,
                  onBtnTap: () {
                    context.push(Routes.signup);
                  }),
              Consumer2<ApiProvider, PreferencesProvider>(
                builder: (context, apiProvider, prefs, child) => CustomBtn(
                  text: AppStrings.continueWithGoogle,
                  textStyle:
                      AppTextStyles.bodyMedium.copyWith(color: AppColors.dark),
                  onBtnTap: () async {
                    final result =
                        await PlatformsSigninController.signinWithGoogle();
                    if (result != null) {
                      final response = await apiProvider.googleSignin(result);
                      if (!apiProvider.isLoading &&
                          response == ApiEnums.success) {
                        CustomSnackbar().showSnackbar(SnackBarEnums.success,
                            apiProvider.responseTxt, context);
                        await prefs.setUserId(
                            apiProvider.authModel?.user?.userId ?? '');
                        await prefs.setIsSSOUser(true);
                        await prefs.setAccessToken(
                            apiProvider.authModel?.accessToken ?? '');
                        await prefs.setRefreshToken(
                            apiProvider.authModel?.refreshToken ?? '');
                        context.go(Routes.dashboard);
                      } else {
                        CustomSnackbar().showSnackbar(SnackBarEnums.failed,
                            apiProvider.responseTxt, context);
                      }
                    }
                  },
                  btnColor: AppColors.light,
                  leadingIcon: SvgPicture.asset(AppImages.google),
                ),
              ),
              // Consumer2<ApiProvider, PreferencesProvider>(
              //   builder: (context, apiProvider, prefs, child) => CustomBtn(
              //     text: AppStrings.continueWithApple,
              //     textStyle:
              //         AppTextStyles.bodyMedium.copyWith(color: AppColors.dark),
              //     onBtnTap: () async {
              //       final result =
              //           await PlatformsSigninController.signinWithGoogle();
              //       if (result != null) {
              //         final response = await apiProvider.googleSignin(result);
              //         if (!apiProvider.isLoading &&
              //             response == ApiEnums.success) {
              //           CustomSnackbar().showSnackbar(SnackBarEnums.success,
              //               apiProvider.responseTxt, context);
              //           await prefs.setUserId(
              //               apiProvider.authModel?.user?.userId ?? '');
              //           await prefs.setIsSSOUser(true);
              //           await prefs.setAccessToken(
              //               apiProvider.authModel?.accessToken ?? '');
              //           await prefs.setRefreshToken(
              //               apiProvider.authModel?.refreshToken ?? '');
              //           context.go(Routes.dashboard);
              //         } else {
              //           CustomSnackbar().showSnackbar(SnackBarEnums.failed,
              //               apiProvider.responseTxt, context);
              //         }
              //       }
              //     },
              //     btnColor: AppColors.light,
              //     leadingIcon: SvgPicture.asset(AppImages.apple),
              //   ),
              // ),
            ],
          ),
        )
      ],
    ));
  }
}
