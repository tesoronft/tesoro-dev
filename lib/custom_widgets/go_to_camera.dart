import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class GoToCamera extends StatelessWidget {
  const GoToCamera({super.key, required this.onWidgetTap});
  final VoidCallback onWidgetTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onWidgetTap,
      child: Container(
        height: MediaQuery.sizeOf(context).height / 6,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          '+ ${AppStrings.addPhotos}',
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }
}
