import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class OnboardingTiles extends StatelessWidget {
  const OnboardingTiles(
      {super.key, required this.imagePath, required this.title});
  final String imagePath, title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(80),
        border: Border.all(color: AppColors.light),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: AppColors.dark.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Image.asset(
              imagePath,
              height: 50,
            ),
            Text(
              title,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
