import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/utils/covert_time_to_minutes.dart';

class TipsInfo extends StatelessWidget {
  const TipsInfo(
      {super.key,
      required this.address,
      required this.amountTitle,
      required this.date,
      required this.totalAmount,
      required this.userName});
  final String userName, date, amountTitle, totalAmount, address;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    userName,
                    style:
                        AppTextStyles.bodyLarge.copyWith(color: AppColors.dark),
                  ),
                ),
                Text(
                  ConvertTimeToMinutes.formatDate(date),
                  style: AppTextStyles.labelMedium
                      .copyWith(color: Color(0xff666666)),
                )
              ],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: amountTitle,
                      style: AppTextStyles.labelMedium
                          .copyWith(fontWeight: FontWeight.w900)),
                  TextSpan(
                      text: totalAmount,
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.currency)),
                ],
              ),
            ),
            SizedBox(
              width: 350,
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.location,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: address, style: AppTextStyles.labelMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
