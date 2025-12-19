import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/post_treasure_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';

class ItemDetailsView extends StatelessWidget {
  ItemDetailsView({super.key});
  final PostTreasureController _postTreasureController =
      PostTreasureController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbarRequired: true,
      appBarTitle: AppStrings.itemDetails,
      backgroundColor: AppColors.light,
      child: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Text(
                  AppStrings.price,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.price,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.price,
                ),
                Text(
                  AppStrings.category,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectCategory,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.price,
                ),
                Text(
                  AppStrings.condition,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectCondition,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.price,
                ),
                Text(
                  AppStrings.brand,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectBrand,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.price,
                ),
                Text(
                  AppStrings.model,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectModel,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.price,
                ),
                Text(
                  AppStrings.type,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectType,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.price,
                ),
                Text(
                  AppStrings.description,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.enterItemDesc,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.price,
                ),
                CustomBtn(
                  text: AppStrings.next,
                  onBtnTap: () {},
                  isDisabled: _postTreasureController.price.text.isEmpty &&
                      _postTreasureController.category.text.isEmpty &&
                      _postTreasureController.condition.text.isEmpty,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
