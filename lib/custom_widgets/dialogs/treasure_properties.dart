import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';

class TreasureProperties extends StatelessWidget {
  TreasureProperties({super.key});
  final ValueNotifier<bool> isFirstChecked = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSecondChecked = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isThirdChecked = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Align(
        alignment: Alignment.topRight,
        child: PopupButton(
          icon: Icons.close,
          iconColor: AppColors.light,
          iconBgColor: AppColors.primary,
          iconRadius: 100,
        ),
      ),
      title: Text(
        'To continue please check all options',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: AppColors.light,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
              valueListenable: isFirstChecked,
              builder: (context, first, child) {
                return Row(
                  children: [
                    Checkbox(
                      checkColor: AppColors.light,
                      activeColor: AppColors.primary,
                      value: isFirstChecked.value,
                      onChanged: (value) {
                        isFirstChecked.value = value ?? false;
                      },
                    ),
                    Text(
                      'Item is placed on side walk.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.dark),
                    )
                  ],
                );
              }),
          ValueListenableBuilder(
              valueListenable: isSecondChecked,
              builder: (context, second, child) {
                return Row(
                  children: [
                    Checkbox(
                      value: isSecondChecked.value,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        isSecondChecked.value = value ?? false;
                      },
                    ),
                    Text(
                      'Item is free on any pests.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.dark),
                    )
                  ],
                );
              }),
          ValueListenableBuilder(
              valueListenable: isThirdChecked,
              builder: (context, third, child) {
                return Row(
                  children: [
                    Checkbox(
                      value: isThirdChecked.value,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        isThirdChecked.value = value ?? false;
                      },
                    ),
                    Text(
                      'Item is 100% free.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.dark),
                    )
                  ],
                );
              }),
          CustomBtn(
            text: 'Continue',
            onBtnTap: () {
              if (isFirstChecked.value == true &&
                  isSecondChecked.value == true &&
                  isThirdChecked.value == true) {
                Navigator.of(context).pop(true);
              } else {
                CustomSnackbar().showSnackbar(
                    SnackBarEnums.failed, 'Please check all options', context);
                Navigator.of(context).pop(false);
              }
            },
          )
        ],
      ),
    );
  }
}
