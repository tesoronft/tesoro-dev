import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../consts/app_colors.dart';
import '../consts/app_text_styles.dart';
import 'custom_btn.dart';

class PermissionEnableComponent extends StatelessWidget {
  const PermissionEnableComponent({super.key});

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
                'Location permissions are denied forever',
                softWrap: true,
                style:
                    AppTextStyles.bodyMedium.copyWith(color: AppColors.light),
              ),
            ),
            CustomBtn(
              text: 'Enable',
              btnColor: AppColors.lightPrimary,
              textStyle: AppTextStyles.bodyMedium,
              onBtnTap: () async {
                await openAppSettings();
              },
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}
