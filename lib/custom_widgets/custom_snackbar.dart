import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class CustomSnackbar {
  void showSnackbar(
      SnackBarEnums snackbarEnum, String responseTxt, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        backgroundColor: snackbarEnum == SnackBarEnums.success
            ? AppColors.dialogBtn
            : snackbarEnum == SnackBarEnums.failed
                ? AppColors.error
                : Colors.yellow,
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            spacing: 10,
            children: [
              Icon(
                snackbarEnum == SnackBarEnums.success
                    ? Icons.check
                    : snackbarEnum == SnackBarEnums.failed
                        ? Icons.close
                        : Icons.info,
                color: AppColors.light,
              ),
              SizedBox(
                width: 275,
                child: Text(
                  responseTxt,
                  softWrap: true,
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.light, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
