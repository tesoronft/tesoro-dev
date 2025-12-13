import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';

import '../consts/app_text_styles.dart';

class SettingsCentral extends StatelessWidget {
  const SettingsCentral(
      {super.key,
      required this.givenAmount,
      required this.receivedAmount,
      required this.firstTitle,
      required this.secondTitle,
      required this.onFirstTap,
      required this.onSecondTap});
  final String receivedAmount, givenAmount, firstTitle, secondTitle;
  final VoidCallback onFirstTap, onSecondTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Wrap(
        spacing: 20,
        children: [
          GestureDetector(
            onTap: onFirstTap,
            child: Container(
              width: MediaQuery.sizeOf(context).width / 2.3,
              decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: AppColors.dark, blurRadius: 2)]),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    firstTitle,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.dark),
                  ),
                  Text(
                    givenAmount,
                    style: AppTextStyles.headingLarge
                        .copyWith(fontSize: 24, color: AppColors.error),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onSecondTap,
            child: Container(
              width: MediaQuery.sizeOf(context).width / 2.3,
              decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: AppColors.dark, blurRadius: 2)]),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    secondTitle,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.dark),
                  ),
                  Text(
                    receivedAmount,
                    style: AppTextStyles.headingLarge
                        .copyWith(fontSize: 24, color: AppColors.error),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
