import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/data/onboarding/onboarding2_data.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../../consts/app_images.dart';
import '../../custom_widgets/onboarding_tiles.dart';

class Onboarding2View extends StatelessWidget {
  const Onboarding2View({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          AppImages.splashBackground,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupButton(),
                  Image.asset(AppImages.transparantLogo,
                      fit: BoxFit.contain, height: 75),
                  SizedBox.shrink(),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: Onboarding2Data.icons.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: OnboardingTiles(
                          imagePath: Onboarding2Data.icons[index],
                          title: Onboarding2Data.titles[index]));
                },
              ),
              CustomBtn(
                text: AppStrings.getStarted,
                onBtnTap: () {
                  context.push(Routes.signin);
                },
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
