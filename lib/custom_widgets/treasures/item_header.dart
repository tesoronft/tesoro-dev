import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class ItemHeader extends StatelessWidget {
  const ItemHeader(
      {super.key,
      required this.condition,
      required this.itemName,
      required this.price});
  final String itemName, price, condition;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              itemName,
              style: AppTextStyles.headingMedium,
            ),
            RichText(
                text: TextSpan(
              children: [
                TextSpan(
                  text: '\$$price',
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.dark,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.dark),
                ),
                TextSpan(
                  text: ' Free',
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: AppColors.currency),
                ),
              ],
            )),
          ],
        ),
        RichText(
            text: TextSpan(children: [
          TextSpan(text: 'Condition: ', style: AppTextStyles.bodyMedium),
          TextSpan(
              text: condition,
              style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error, fontWeight: FontWeight.normal)),
        ]))
      ],
    );
  }
}
