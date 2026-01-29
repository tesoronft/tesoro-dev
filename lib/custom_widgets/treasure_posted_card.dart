import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class TreasurePostedCard extends StatelessWidget {
  const TreasurePostedCard({
    super.key,
    required this.condition,
    required this.imagePath,
    required this.itemName,
    this.collectedBy,
  });
  final String imagePath, itemName, condition;
  final String? collectedBy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
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
                child: imagePath.contains('https')
                    ? Image.network(
                        imagePath,
                        // height: 150,
                        width: double.infinity,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(imagePath),
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
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: AppColors.dark),
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
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            color: collectedBy == null ? AppColors.primary : AppColors.error,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              collectedBy == null ? AppStrings.available : AppStrings.collected,
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.light),
            ),
          ),
        )
      ],
    );
  }
}
