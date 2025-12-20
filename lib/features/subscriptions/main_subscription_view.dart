import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/subscription_card.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

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
      backgroundColor: AppColors.light,
      child: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          spacing: 15,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xffE4E4E4)),
                padding: EdgeInsets.zero,
                child: IconButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      context.pop();
                    } else {
                      context.go(Routes.dashboard);
                    }
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.close_rounded,
                  ),
                ),
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
            SubscriptionFooter(),
            Text(
              AppStrings.subscriptionsAutomaticalyRenew,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
