import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.hintText,
      this.isPassword = false,
      this.isVissible = false,
      this.fillColors,
      required this.keyboardType,
      this.onVisibilityTap,
      required this.editingController});
  final String hintText;
  final bool isPassword, isVissible;
  final VoidCallback? onVisibilityTap;
  final TextInputType keyboardType;
  final TextEditingController editingController;
  Color? fillColors;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: editingController,
      cursorColor: AppColors.primary,
      textAlign: TextAlign.start,
      smartDashesType: SmartDashesType.disabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: fillColors ?? AppColors.light,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.dark.withAlpha(30))),
        hintText: hintText,
        hintStyle: AppTextStyles.bodySmall.copyWith(color: Color(0xff9EA1A8)),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onVisibilityTap,
                icon: Icon(
                  isVissible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.primary,
                ))
            : SizedBox.shrink(),
      ),
    );
  }
}
