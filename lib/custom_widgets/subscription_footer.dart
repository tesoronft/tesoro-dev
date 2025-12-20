import 'package:flutter/material.dart';

import '../consts/app_colors.dart';
import '../consts/app_strings.dart';
import '../consts/app_text_styles.dart';

class SubscriptionFooter extends StatelessWidget {
  const SubscriptionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
          onPressed: () {},
          child: Text(
            AppStrings.restorePurchase,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.error,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
          child: Text(
            AppStrings.termsAndConditions,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.error,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
          child: Text(
            AppStrings.privacyPolicy,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.error,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}
