import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard(
      {super.key,
      required this.description,
      required this.price,
      required this.title});
  final String title, price, description;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.dialogBtn),
            ),
            Text(
              price,
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.error,
                fontSize: 24,
              ),
            ),
            Text(
              description,
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.dialogBtn),
            )
          ],
        ),
      ),
    );
  }
}
