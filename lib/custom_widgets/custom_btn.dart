import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn(
      {super.key,
      required this.text,
      this.leadingIcon,
      this.trailingIcon,
      this.spacing,
      this.padding,
      this.height,
      this.width,
      this.textStyle,
      this.btnColor,
      required this.onBtnTap,
      this.isDisabled = false});
  final String text;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? spacing, padding, height, width;
  final TextStyle? textStyle;
  final Color? btnColor;
  final VoidCallback onBtnTap;
  final bool isDisabled;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onBtnTap,
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            color: btnColor ?? AppColors.primary,
            borderRadius: BorderRadius.circular(padding ?? 10),
            boxShadow: [
              BoxShadow(
                color: AppColors.dark.withAlpha(20),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: AppColors.dark.withAlpha(20),
                blurRadius: 4,
                offset: const Offset(2, 0),
              ),
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: spacing ?? 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leadingIcon ?? SizedBox.shrink(),
            Text(
              text,
              style: textStyle ??
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.light),
            ),
            trailingIcon ?? SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
