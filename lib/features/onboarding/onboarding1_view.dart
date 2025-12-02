import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/onboarding_tiles.dart';
import 'package:tesoro_nft_app/data/onboarding/onboarding1_data.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../../consts/app_images.dart';

class Onboarding1View extends StatelessWidget {
  const Onboarding1View({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          AppImages.splashBackground,
          fit: BoxFit.fill,
        ),
        SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                AppImages.transparantLogo,
                height: 75,
              ),
              ListView.builder(
                itemCount: Onboarding1Data.icons.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: OnboardingTiles(
                          imagePath: Onboarding1Data.icons[index],
                          title: Onboarding1Data.titles[index]));
                },
              ),
              CustomBtn(
                text: AppStrings.next,
                onBtnTap: () => context.push(Routes.onboarding2),
                trailingIcon: Icon(
                  Icons.arrow_forward,
                  color: AppColors.light,
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
