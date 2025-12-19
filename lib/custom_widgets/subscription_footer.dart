import 'package:flutter/material.dart';

import '../consts/app_colors.dart';
import '../consts/app_strings.dart';
import '../consts/app_text_styles.dart';

class SubscriptionFooter extends StatelessWidget {
  const SubscriptionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            AppStrings.restorePurchase,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.error,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            AppStrings.termsAndConditions,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.error,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            AppStrings.privacyPolicy,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.error,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}
