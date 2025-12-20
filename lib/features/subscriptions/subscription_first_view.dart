import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/data/dashboard/settings_data.dart';
import 'package:tesoro_nft_app/data/subscription/subscription_data.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class SubscriptionFirstView extends StatelessWidget {
  const SubscriptionFirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.light,
      child: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 10,
          children: [
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                      leading: Image.asset(
                        SubscriptionData.images[index],
                        height: 30,
                      ),
                      title: Text(
                        SubscriptionData.labels[index],
                        style: AppTextStyles.bodyMedium,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: SubscriptionData.images.length),
            CustomBtn(
              text: AppStrings.goPremium,
              onBtnTap: () => context.go(
                Routes.subscriptionViewTwo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
