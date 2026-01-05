import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/post_treasure_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_post_model.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class ItemDetailsView extends StatelessWidget {
  ItemDetailsView({super.key, required this.treasurePostModel});
  final PostTreasureController _postTreasureController =
      PostTreasureController();
  final TreasurePostModel treasurePostModel;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbarRequired: true,
      appBarTitle: AppStrings.itemDetails,
      backgroundColor: AppColors.light,
      child: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
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
                  editingController: _postTreasureController.category,
                ),
                Text(
                  AppStrings.condition,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectCondition,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.condition,
                ),
                Text(
                  AppStrings.brand,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectBrand,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.brand,
                ),
                Text(
                  AppStrings.model,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectModel,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.model,
                ),
                Text(
                  AppStrings.type,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.selectType,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.type,
                ),
                Text(
                  AppStrings.description,
                  style: AppTextStyles.bodySmall,
                ),
                CustomTextField(
                  hintText: AppStrings.enterItemDesc,
                  keyboardType: TextInputType.text,
                  editingController: _postTreasureController.description,
                ),
                CustomBtn(
                  text: AppStrings.next,
                  onBtnTap: () {
                    treasurePostModel.brand =
                        _postTreasureController.brand.text;
                    treasurePostModel.description =
                        _postTreasureController.description.text;
                    treasurePostModel.type = _postTreasureController.type.text;
                    treasurePostModel.itemModel =
                        _postTreasureController.model.text;
                    treasurePostModel.condition =
                        _postTreasureController.brand.text;
                    treasurePostModel.condition =
                        _postTreasureController.brand.text;
                    treasurePostModel.category =
                        _postTreasureController.category.text;
                    treasurePostModel.price =
                        int.parse(_postTreasureController.price.text);
                    context.push(Routes.confirmDetails,
                        extra: treasurePostModel);
                  },
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
