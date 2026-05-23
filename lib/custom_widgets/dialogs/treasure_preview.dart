import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/set_image.dart';

import '../../enums/dialog_enums.dart';
import '../../models/treasures/treasure_get_model.dart';

class TreasurePreview extends StatelessWidget {
  TreasurePreview(
      {super.key, required this.treasure, this.isConfirmation = false});
  final TreasureGetModel treasure;
  bool isConfirmation = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isConfirmation ? 10 : 0),
      ),
      backgroundColor: AppColors.light,
      title: SizedBox(
          height: 200,
          width: 200,
          child: SetImage(imagePath: treasure.photos!.first)),
      titlePadding: EdgeInsets.all(6),
      contentPadding: EdgeInsets.all(6),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                treasure.title ?? 'No Title',
                style: AppTextStyles.bodySmall
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              !isConfirmation
                  ? CustomBtn(
                      text: 'View',
                      btnColor: AppColors.light,
                      width: 50,
                      height: 30,
                      textStyle: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.dialogBtn,
                          fontWeight: FontWeight.bold),
                      onBtnTap: () =>
                          context.push(Routes.treasureDetails, extra: treasure),
                    )
                  : RichText(
                      text: TextSpan(children: [
                      TextSpan(
                        text: '\$${treasure.price ?? '0'}',
                        style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                            decoration: TextDecoration.lineThrough),
                      ),
                      TextSpan(
                        text: '  Free',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.currency),
                      )
                    ]))
            ],
          ),
          if (isConfirmation)
            RichText(
                text: TextSpan(
                    text: '${AppStrings.condition}: ',
                    style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.dark),
                    children: [
                  TextSpan(
                    text: treasure.condition?.name ?? 'No Condition',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.error),
                  )
                ])),
          if (isConfirmation) Divider()
        ],
      ),
      actionsPadding: EdgeInsets.all(6),
      actions: !isConfirmation
          ? []
          : [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(AppStrings.isTheItemStillThere,
                    style: AppTextStyles.bodySmall
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              Consumer2<ApiProvider, PreferencesProvider>(
                builder: (context, apiProvider, preferencesProvider, child) =>
                    apiProvider.isLoading
                        ? Center(
                            child: SpinKitCircle(
                            color: AppColors.primary,
                          ))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomBtn(
                                btnColor: AppColors.dialogBtn,
                                width: 150,
                                text: AppStrings.yes,
                                onBtnTap: () => Navigator.of(context)
                                    .pop(DialogEnums.treasureTaken),
                              ),
                              CustomBtn(
                                btnColor: AppColors.dialogBtn,
                                width: 150,
                                text: AppStrings.no,
                                onBtnTap: () async {
                                  final result =
                                      await apiProvider.deleteTreasure(
                                          treasure.productId ?? "",
                                          preferencesProvider.accessToken ??
                                              "");
                                  if (result == ApiEnums.failed) {
                                    CustomSnackbar().showSnackbar(
                                        SnackBarEnums.failed,
                                        apiProvider.responseTxt,
                                        context);
                                  } else {
                                    CustomSnackbar().showSnackbar(
                                        SnackBarEnums.success,
                                        apiProvider.responseTxt,
                                        context);
                                    Navigator.of(context)
                                        .pop(DialogEnums.treasureNotTaken);
                                  }
                                },
                              )
                            ],
                          ),
              ),
            ],
    );
  }
}
