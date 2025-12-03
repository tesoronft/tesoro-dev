import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/custom_widgets/treasure_collected_card.dart';

class TreasureCollectedView extends StatelessWidget {
  const TreasureCollectedView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.light,
      child: SafeArea(
        minimum: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupButton(),
                Text(
                  AppStrings.treasureCollected,
                  style: AppTextStyles.headingMedium,
                ),
                SizedBox.shrink()
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TreasureCollectedCard(
                      date: 'Jan 18,2025',
                      imageUrl: AppImages.chairs,
                      itemName: 'Dining Table',
                      location: 'Los Angeles, CA',
                      personName: '@JohnDoe',
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
