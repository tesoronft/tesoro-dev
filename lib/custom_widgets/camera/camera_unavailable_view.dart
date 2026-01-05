import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/utils/app_permissions.dart';

class CameraUnavailableView extends StatelessWidget {
  const CameraUnavailableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Camera Permission Denied',
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          'Please allow camera permission to continue',
          style: AppTextStyles.bodySmall,
        ),
        Consumer<AppPermissions>(
          builder: (context, permissions, child) => CustomBtn(
              text: 'Allow Camera',
              onBtnTap: () async {
                await permissions.getCameraPermission();
              }),
        )
      ],
    );
  }
}
