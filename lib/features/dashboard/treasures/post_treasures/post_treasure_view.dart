import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/post_treasure_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/custom_widgets/go_to_camera.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class PostTreasureView extends StatelessWidget {
  PostTreasureView({super.key});
  final PostTreasureController _postTreasureController =
      PostTreasureController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbarRequired: true,
      appBarTitle: AppStrings.postYourItem,
      backgroundColor: AppColors.light,
      child: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.title,
                style: AppTextStyles.bodySmall,
              ),
              CustomTextField(
                hintText: AppStrings.enterTitle,
                keyboardType: TextInputType.text,
                fillColors: Colors.grey[100],
                editingController: _postTreasureController.title,
              ),
              Text(
                AppStrings.location,
                style: AppTextStyles.bodySmall,
              ),
              CustomTextField(
                hintText: AppStrings.addLocation,
                keyboardType: TextInputType.text,
                fillColors: Colors.grey[100],
                editingController: _postTreasureController.location,
              ),
              Text(
                AppStrings.addPhotos,
                style: AppTextStyles.bodySmall,
              ),
              GoToCamera(onWidgetTap: () {}),
              CustomBtn(
                text: AppStrings.next,
                onBtnTap: () {
                  context.push(Routes.itemDetails);
                },
                isDisabled: _postTreasureController.title.text.isEmpty &&
                        _postTreasureController.location.text.isEmpty
                    ? true
                    : false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
