import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class TreasureCollectedCard extends StatelessWidget {
  const TreasureCollectedCard(
      {super.key,
      required this.date,
      required this.imageUrl,
      required this.itemName,
      required this.location,
      required this.personName});
  final String imageUrl, itemName, date, personName, location;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.light,
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 10,
          children: [
            Container(
              height: 80,
              width: 90,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  itemName,
                  style: AppTextStyles.bodyMedium,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: AppStrings.collectedOn,
                      style: AppTextStyles.labelMedium
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: date,
                      style: AppTextStyles.labelMedium
                          .copyWith(color: Color(0xff666666))),
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: AppStrings.collectedFrom,
                      style: AppTextStyles.labelMedium
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: personName,
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.primary)),
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: AppStrings.location,
                      style: AppTextStyles.labelMedium
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: location,
                      style: AppTextStyles.labelMedium
                          .copyWith(color: Color(0xff666666))),
                ]))
              ],
            )
          ],
        ),
      ),
    );
  }
}
