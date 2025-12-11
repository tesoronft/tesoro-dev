import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/auth_card.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';

import '../../../consts/app_text_styles.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, apis, child) => CustomScaffold(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AppImages.splashBackground, fit: BoxFit.fill),
          AbsorbPointer(
            absorbing: apis.isLoading ? true : false,
            child: SafeArea(
              minimum: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  AuthCard(issSignin: false, onBtnTap: () async {}),
                  CustomBtn(
                    text: AppStrings.continueWithGoogle,
                    textStyle: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.dark),
                    onBtnTap: () {},
                    btnColor: AppColors.light,
                    leadingIcon: SvgPicture.asset(AppImages.google),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
