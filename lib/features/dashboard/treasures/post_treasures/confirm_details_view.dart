import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/dialogs/message_dialog.dart';
import 'package:tesoro_nft_app/data/treasure/post_treasure_data.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_post_model.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/set_image.dart';

import '../../../../services/analytics_service.dart';

class ConfirmDetailsView extends StatelessWidget {
  const ConfirmDetailsView({super.key, required this.treasurePostModel});
  final TreasurePostModel treasurePostModel;
  @override
  Widget build(BuildContext buildContext) {
    return PopScope(
      onPopInvoked: (didPop) => false,
      child: Consumer2<ApiProvider, PreferencesProvider>(
        builder: (context, apis, prefs, child) => AbsorbPointer(
          absorbing: apis.isLoading,
          child: CustomScaffold(
            isAppbarRequired: true,
            backgroundColor: AppColors.light,
            appBarTitle: AppStrings.itemDetails,
            child: SingleChildScrollView(
              child: SafeArea(
                minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
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
                      itemCount: treasurePostModel.photos?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.light,
                          ),
                          child: SetImage(
                              imagePath:
                                  treasurePostModel.photos?[index] ?? ''),
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
                      treasurePostModel.categoryId ?? 'N/A',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    Text(
                      AppStrings.condition,
                      style: AppTextStyles.headingMedium
                          .copyWith(color: AppColors.dialogBtn),
                    ),
                    Text(
                      treasurePostModel.conditionId ?? 'N/A',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    if (treasurePostModel.description != '')
                      Text(
                        AppStrings.description,
                        style: AppTextStyles.headingMedium
                            .copyWith(color: AppColors.dialogBtn),
                      ),
                    if (treasurePostModel.description != '')
                      Text(
                        treasurePostModel.description ?? 'N/A',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                    apis.isLoading
                        ? Center(
                            child: SpinKitCircle(
                              color: AppColors.primary,
                            ),
                          )
                        : Consumer<PreferencesProvider>(
                            builder: (context, prefs, child) => CustomBtn(
                                text: AppStrings.postItem,
                                trailingIcon: Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.light,
                                ),
                                onBtnTap: () async {
                                  final result = await apis.createTreasure(
                                      treasurePostModel,
                                      prefs.accessToken ?? '');
                                  if (result == ApiEnums.success) {
                                    await apis
                                        .getUserData(prefs.accessToken ?? '');
                                    await AnalyticsService.logEvent(
                                        'item_posted_successfully');
                                    showDialog(
                                      context: buildContext,
                                      barrierDismissible: false,
                                      builder: (context) => MessageDialog(
                                          btnTapped: () {
                                            Navigator.of(buildContext).pop();
                                            context.go(Routes.dashboard);
                                          },
                                          btnTxt: 'Back to Home',
                                          imageUrl: AppImages.achievment,
                                          subtitle: AppStrings
                                              .yourListingItemIsVissible,
                                          title: AppStrings
                                              .itemPostedSuccessfully),
                                    );
                                  } else {
                                    await AnalyticsService.logEvent(
                                        'item_posting_failed');
                                    CustomSnackbar().showSnackbar(
                                      SnackBarEnums.failed,
                                      apis.responseTxt,
                                      buildContext,
                                    );
                                  }
                                }),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
