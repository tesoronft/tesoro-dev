import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader(
      {super.key,
      required this.earning,
      required this.location,
      required this.name});
  final String name, earning, location;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: AppTextStyles.headingMedium.copyWith(color: AppColors.dark),
        ),
        Text(
          earning,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
        ),
        Text(
          location,
          style: AppTextStyles.bodyMedium
              .copyWith(color: Color(0xff666666), fontWeight: FontWeight.w400),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                AppStrings.paymentAndDeposit,
                style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.dialogBtn,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.dialogBtn),
              ),
            ),
            Image.asset(
              AppImages.bankCard,
              height: 30,
            ),
          ],
        )
      ],
    );
  }
}
