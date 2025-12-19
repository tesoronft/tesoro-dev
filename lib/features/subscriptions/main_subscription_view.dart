import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/subscription_card.dart';

import '../../custom_widgets/subscription_footer.dart';

class MainSubscriptionView extends StatefulWidget {
  const MainSubscriptionView({super.key});

  @override
  State<MainSubscriptionView> createState() => _MainSubscriptionViewState();
}

class _MainSubscriptionViewState extends State<MainSubscriptionView> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SafeArea(
        child: Column(
          spacing: 10,
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.close_rounded,
              ),
            ),
            Image.asset(AppImages.subscriptionImage),
            Text(
              AppStrings.specialOfferForEarly,
              style: AppTextStyles.headingMedium,
            ),
            Text(
              AppStrings.unclockTheFullVersion,
              style: AppTextStyles.bodySmall.copyWith(color: Color(0xff666666)),
            ),
            SubscriptionCard(
                description: 'Billed Monthly',
                price: '\$4.99',
                title: 'Start a Monthly Subscription'),
            CustomBtn(text: AppStrings.tryFreeAndSubscribe, onBtnTap: () {}),
            Text(
              AppStrings.recuringBill,
              style: AppTextStyles.bodySmall,
            ),
            Text(
              AppStrings.unclockTheFullVersion,
              style: AppTextStyles.bodySmall.copyWith(color: Color(0xff666666)),
            ),
            SubscriptionFooter(),
            Text(
              AppStrings.subscriptionsAutomaticalyRenew,
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
