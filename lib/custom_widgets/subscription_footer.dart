import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../consts/app_colors.dart';
import '../consts/app_strings.dart';
import '../consts/app_text_styles.dart';

class SubscriptionFooter extends StatelessWidget {
  const SubscriptionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, apis, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            style:
                ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
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
            onPressed: () {
              final termsAndConditions = apis.contentInfoModel?.items
                  ?.where((data) => data.name == 'Terms and Conditions')
                  .first;
              context.push(Routes.webView, extra: termsAndConditions?.id);
            },
            style:
                ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
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
            onPressed: () {
              final privacyPolicy = apis.contentInfoModel?.items
                  ?.where((data) => data.name == 'Privacy Policy')
                  .first;
              context.push(Routes.webView, extra: privacyPolicy?.id);
            },
            style:
                ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
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
      ),
    );
  }
}
