import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class TreasurePostedCard extends StatelessWidget {
  const TreasurePostedCard(
      {super.key,
      required this.condition,
      required this.imagePath,
      required this.itemName});
  final String imagePath, itemName, condition;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: AppColors.dark, blurRadius: 2)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Expanded(
            child: Image.network(
              imagePath,
              // height: 150,
              width: double.infinity,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              itemName,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.dark),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 5),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: AppStrings.condition,
                  style: AppTextStyles.labelMedium
                      .copyWith(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: condition,
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.error)),
            ])),
          )
        ],
      ),
    );
  }
}
