import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../consts/app_colors.dart';
import '../consts/app_text_styles.dart';
import 'custom_btn.dart';

class PermissionEnableComponent extends StatelessWidget {
  const PermissionEnableComponent(
      {super.key, this.txt, this.buttonText, this.onTap});
  final String? txt, buttonText;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 250,
              child: Text(
                txt ?? 'Location permissions are denied forever',
                softWrap: true,
                style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.light, fontWeight: FontWeight.w900),
              ),
            ),
            CustomBtn(
              text: buttonText ?? 'Enable',
              btnColor: AppColors.lightPrimary,
              textStyle: AppTextStyles.bodySmall,
              onBtnTap: () async {
                if (onTap != null) {
                  onTap?.call();
                } else {
                  await openAppSettings();
                }
              },
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}
