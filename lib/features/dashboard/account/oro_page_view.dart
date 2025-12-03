import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/oro_rate_card.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/data/userProfile/user_profile_date.dart';

class OroPageView extends StatelessWidget {
  const OroPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupButton(),
                Text(
                  '\$ORO',
                  style: AppTextStyles.headingLarge.copyWith(
                      color: AppColors.dark, fontWeight: FontWeight.w300),
                ),
                SizedBox.shrink()
              ],
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'CA: ',
                      style: AppTextStyles.labelMedium
                          .copyWith(fontWeight: FontWeight.w900)),
                  TextSpan(
                      text: 'vqmhHCimduCN8eWnC4WjIg/',
                      onEnter: (event) {},
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                      )),
                ],
              ),
            ),
            OroRateCard(
                convertedRate: '\$2,388.93',
                usdAmount: '\$0.0119',
                difference: '-21.6%',
                oroAvailable: '201M'),
            Text(
              AppStrings.didYouKnowWeHaveAToekn,
              style: AppTextStyles.headingMedium,
            ),
            ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 10,
                color: AppColors.dark,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: UserProfileDate.images.length,
              itemBuilder: (context, index) => ListTile(
                leading: Image.asset(
                  UserProfileDate.images[index],
                  height: 40,
                ),
                title: Text(
                  UserProfileDate.titles[index],
                  style: AppTextStyles.bodySmall,
                ),
                subtitle: Text(
                  UserProfileDate.subtitles[index],
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ),
            Center(
              child: Text(
                AppStrings.convertOroToOther,
                style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w900, color: AppColors.dark),
              ),
            ),
            Spacer(),
            TextButton(
                onPressed: () {},
                child: Text(
                  AppStrings.learnMore,
                  style: AppTextStyles.bodyMedium.copyWith(
                      decoration: TextDecoration.underline,
                      color: AppColors.light,
                      decorationColor: AppColors.light),
                ))
          ],
        ),
      ),
    );
  }
}
