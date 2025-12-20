import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/dialogs/message_dialog.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/data/treasure/post_treasure_data.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_post_model.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';

class ConfirmDetailsView extends StatelessWidget {
  const ConfirmDetailsView({super.key, required this.treasurePostModel});
  final TreasurePostModel treasurePostModel;
  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, PreferencesProvider>(
      builder: (context, apis, prefs, child) => CustomScaffold(
        isAppbarRequired: true,
        backgroundColor:
            apis.isLoading ? AppColors.light.withAlpha(60) : AppColors.light,
        appBarTitle: AppStrings.itemDetails,
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0.6,
                          crossAxisSpacing: 10),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          color: AppColors.light,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.zero,
                          child: Image.asset(
                            AppImages.chairs,
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 3,
                      itemBuilder: (context, index) => ListTile(
                        leading: Icon(Icons.check),
                        title: Text(
                          PostTreasureData.labels[index],
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.dark),
                        ),
                      ),
                    ),
                    SizedBox(height: 20, child: Divider()),
                    Text(
                      '${AppStrings.title}:',
                      style: AppTextStyles.headingMedium
                          .copyWith(color: AppColors.dialogBtn),
                    ),
                    Text(
                      treasurePostModel.title ?? 'N/A',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    Text(
                      AppStrings.location,
                      style: AppTextStyles.headingMedium
                          .copyWith(color: AppColors.dialogBtn),
                    ),
                    Text(
                      treasurePostModel.location?.address ?? '',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '${AppStrings.estimatePrice}:',
                      style: AppTextStyles.headingMedium
                          .copyWith(color: AppColors.dialogBtn),
                    ),
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                          text: treasurePostModel.price.toString(),
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.dark,
                              fontWeight: FontWeight.normal,
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
                    Text(
                      AppStrings.category,
                      style: AppTextStyles.headingMedium
                          .copyWith(color: AppColors.dialogBtn),
                    ),
                    Text(
                      treasurePostModel.category ?? 'N/A',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    Text(
                      AppStrings.condition,
                      style: AppTextStyles.headingMedium
                          .copyWith(color: AppColors.dialogBtn),
                    ),
                    Text(
                      treasurePostModel.condition ?? 'N/A',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    Text(
                      AppStrings.description,
                      style: AppTextStyles.headingMedium
                          .copyWith(color: AppColors.dialogBtn),
                    ),
                    Text(
                      treasurePostModel.description ?? 'N/A',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    CustomBtn(
                        text: AppStrings.postItem,
                        trailingIcon: Icon(
                          Icons.arrow_forward,
                          color: AppColors.light,
                        ),
                        onBtnTap: () {
                          //apis.createTreasure();
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => MessageDialog(
                                btnTapped: () => context.pop(),
                                btnTxt: 'Back to Home',
                                imageUrl: AppImages.achievment,
                                subtitle: AppStrings.yourListingItemIsVissible,
                                title: AppStrings.itemPostedSuccessfully),
                          );
                        }),
                  ],
                ),
                apis.isLoading ? LoaderWidget() : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
