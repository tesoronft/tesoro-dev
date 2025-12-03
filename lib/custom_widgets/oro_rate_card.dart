import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class OroRateCard extends StatelessWidget {
  const OroRateCard(
      {super.key,
      required this.convertedRate,
      required this.usdAmount,
      required this.difference,
      required this.oroAvailable});
  final String usdAmount, convertedRate, difference, oroAvailable;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Color(0xff121A2C),
      ),
      child: ListTile(
        leading: Image.asset(
          AppImages.transparantLogo,
          height: 60,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Whatrr',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.light),
            ),
            Text(
              usdAmount,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.light),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: convertedRate,
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary),
                  ),
                  TextSpan(
                    text: difference,
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.error),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: oroAvailable,
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary),
                  ),
                  TextSpan(
                    text: ' WHATRR',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
