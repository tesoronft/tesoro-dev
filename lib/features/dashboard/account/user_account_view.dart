import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_notched_appbar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/oro_rate_card.dart';
import 'package:tesoro_nft_app/custom_widgets/settings_central.dart';
import 'package:tesoro_nft_app/custom_widgets/settings_header.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class UserAccountView extends StatelessWidget {
  const UserAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.light,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CustomNotchedAppbar(child: SizedBox()),
              Positioned(
                top: 60,
                left: 160,
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  maxRadius: 45,
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 20,
          ),
          SettingsHeader(
              earning: '\$250.00',
              location: 'Los Angeles, CA',
              name: 'John Doe'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              AppStrings.tipsHistory,
              style:
                  AppTextStyles.headingMedium.copyWith(color: AppColors.dark),
            ),
          ),
          Center(
            child: SettingsCentral(
              givenAmount: '\$15',
              receivedAmount: '\$10',
              firstTitle: AppStrings.tipsReceived,
              secondTitle: AppStrings.tipsGiven,
              onFirstTap: () => context.push(Routes.tipsReceived),
              onSecondTap: () => context.push(Routes.tipsGiven),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              AppStrings.treasureHistory,
              style:
                  AppTextStyles.headingMedium.copyWith(color: AppColors.dark),
            ),
          ),
          Center(
            child: SettingsCentral(
              givenAmount: '13',
              receivedAmount: '10',
              firstTitle: AppStrings.collected,
              secondTitle: AppStrings.posted,
              onFirstTap: () => context.push(Routes.treasureCollected),
              onSecondTap: () => context.push(Routes.treasurePosted),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: OroRateCard(
                convertedRate: '\$2,388.93 ',
                usdAmount: '\$0.0119',
                difference: ' -21.6%',
                oroAvailable: '201M '),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomBtn(
              text: AppStrings.earnOroTokens,
              onBtnTap: () => context.push(Routes.oroPage),
              trailingIcon: Icon(
                Icons.arrow_forward,
                color: AppColors.light,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
