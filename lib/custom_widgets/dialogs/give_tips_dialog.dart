import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/enums/dialog_enums.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/models/tips/give_tips_model.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';

import '../../consts/app_colors.dart';
import '../../consts/app_text_styles.dart';

class GiveTipsDialog extends StatelessWidget {
  GiveTipsDialog(
      {super.key,
      required this.receiverId,
      required this.senderId,
      required this.treasureId});
  final TextEditingController amount = TextEditingController();
  final String receiverId, senderId, treasureId;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: AppColors.light,
      icon: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () =>
                Navigator.of(context).pop(DialogEnums.treasureNotTaken),
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0xffE4E4E4),
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(Icons.close)),
          )),
      title: LottieBuilder.asset(AppImages.coins, height: 100, width: 100),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.tipAmount,
            style:
                AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Consumer2<ApiProvider, PreferencesProvider>(
            builder: (context, apis, prefs, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TipAmountOption(
                    amount: '1',
                    apiProvider: apis,
                    accessToken: prefs.accessToken ?? '',
                    tipsModel: GiveTipsModel()
                      ..amount = 1
                      ..receiverId = receiverId
                      ..treasureId = treasureId
                      ..senderId = prefs.userId),
                TipAmountOption(
                    amount: '5',
                    apiProvider: apis,
                    accessToken: prefs.accessToken ?? '',
                    tipsModel: GiveTipsModel()
                      ..amount = 5
                      ..receiverId = receiverId
                      ..treasureId = treasureId
                      ..senderId = prefs.userId),
                TipAmountOption(
                    amount: '10',
                    apiProvider: apis,
                    accessToken: prefs.accessToken ?? '',
                    tipsModel: GiveTipsModel()
                      ..amount = 10
                      ..receiverId = receiverId
                      ..treasureId = treasureId
                      ..senderId = prefs.userId),
              ],
            ),
          )
        ],
      ),
      actions: [
        CustomTextField(
            hintText: AppStrings.enterCustomAmount,
            keyboardType: TextInputType.number,
            editingController: amount),
        SizedBox(
          height: 10,
        ),
        Consumer2<ApiProvider, PreferencesProvider>(
          builder: (context, apis, prefs, child) => apis.isLoading
              ? Center(
                  child: SpinKitCircle(
                  color: AppColors.primary,
                ))
              : CustomBtn(
                  text: 'Next',
                  onBtnTap: () async {
                    if (amount.text.isEmpty) {
                      return;
                    }
                    final result = await apis.createTips(
                        GiveTipsModel()
                          ..amount = double.parse(amount.text)
                          ..receiverId = receiverId
                          ..treasureId = treasureId
                          ..senderId = prefs.userId,
                        prefs.accessToken ?? '');
                    if (result == ApiEnums.success) {
                      CustomSnackbar().showSnackbar(
                          SnackBarEnums.success, apis.responseTxt, context);
                      Navigator.of(context).pop(DialogEnums.treasureTaken);
                    } else {
                      CustomSnackbar().showSnackbar(
                          SnackBarEnums.failed, apis.responseTxt, context);
                    }
                  },
                ),
        )
      ],
    );
  }
}

class TipAmountOption extends StatelessWidget {
  const TipAmountOption(
      {super.key,
      required this.amount,
      required this.apiProvider,
      required this.accessToken,
      required this.tipsModel});
  final String amount;
  final ApiProvider apiProvider;
  final String accessToken;
  final GiveTipsModel tipsModel;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          final result = await apiProvider.createTips(tipsModel, accessToken);
          if (result == ApiEnums.success) {
            CustomSnackbar().showSnackbar(
                SnackBarEnums.success, apiProvider.responseTxt, context);
            Navigator.of(context).pop(DialogEnums.treasureTaken);
          } else {
            CustomSnackbar().showSnackbar(
                SnackBarEnums.failed, apiProvider.responseTxt, context);
          }
        },
        child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.dialogBtn,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '\$$amount',
              style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.light),
            ),
          ),
        ),
      ),
    );
  }
}
