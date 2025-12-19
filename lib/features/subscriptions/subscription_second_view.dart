import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/subscription_footer.dart';
import 'package:tesoro_nft_app/data/subscription/subscription_data.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../../consts/app_colors.dart';
import '../../consts/app_text_styles.dart';

class SubscriptionSecondView extends StatelessWidget {
  const SubscriptionSecondView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          spacing: 20,
          children: [
            Text(
              AppStrings.yourFreeTrial,
              style: AppTextStyles.headingMedium,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: SubscriptionData.tilesData.length,
                itemBuilder: (context, index) {
                  final data = SubscriptionData.tilesData[index];
                  return ListTile(
                    leading: Icon(
                      index == 0 ? Icons.check_box : Icons.square_outlined,
                      color: AppColors.dialogBtn,
                    ),
                    title: Text(
                      data['title'],
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: Color(0xff0D5C63)),
                    ),
                    subtitle: Text(
                      data['subtitle'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Color(0xff666666),
                      ),
                    ),
                  );
                },
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: AppStrings.sevenDayFreeTrial,
                      style: AppTextStyles.bodyLarge),
                  TextSpan(
                    text: ' \$4.99 per month',
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: AppColors.error),
                  ),
                ],
              ),
            ),
            CustomBtn(
              text: AppStrings.tryFreeAndSubscribe,
              trailingIcon: Icon(Icons.arrow_forward),
              onBtnTap: () => context.push(Routes.mainSubscriptionView),
            ),
            Text(
              AppStrings.theAppStoreWillOnlyChargeYouAfter,
              style: AppTextStyles.bodySmall,
            ),
            SubscriptionFooter(),
          ],
        ),
      ),
    );
  }
}
