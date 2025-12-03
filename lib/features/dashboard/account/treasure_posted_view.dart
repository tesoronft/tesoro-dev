import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/custom_widgets/treasure_posted_card.dart';

class TreasurePostedView extends StatelessWidget {
  const TreasurePostedView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: AppColors.light,
        child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PopupButton(),
                    Text(
                      AppStrings.treasurePosted,
                      style: AppTextStyles.headingMedium,
                    ),
                    SizedBox.shrink()
                  ],
                ),
                DropdownButton(
                  borderRadius: BorderRadius.circular(10),
                  value: AppStrings.available,
                  items: [
                    DropdownMenuItem(
                      value: 'Available',
                      child: Text(
                        AppStrings.available,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    DropdownMenuItem(
                        value: 'Unavailable',
                        child: Text(
                          AppStrings.unavailable,
                          style: AppTextStyles.bodyMedium,
                        ))
                  ],
                  onChanged: (value) {},
                ),
                Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.9,
                            mainAxisSpacing: 10),
                        itemCount: 13,
                        itemBuilder: (context, index) {
                          return TreasurePostedCard(
                              condition: 'Good',
                              imagePath: AppImages.chairs,
                              itemName: 'Old Chair');
                        }))
              ],
            )));
  }
}
