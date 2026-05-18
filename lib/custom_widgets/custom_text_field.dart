import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {super.key,
      required this.hintText,
      this.isPassword = false,
      this.fillColors,
      required this.keyboardType,
      this.maxLength,
      required this.editingController,
      this.helperTxt,
      this.validation,
      this.prefixIcon});
  final String hintText;
  final bool isPassword;
  bool isVissible = false;
  final String? helperTxt;
  final TextInputType keyboardType;
  final TextEditingController editingController;
  Color? fillColors;
  int? maxLength;
  String? validation;
  final IconData? prefixIcon;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.editingController,
      maxLines: widget.maxLength ?? 1,
      validator: (value) {
        return widget.validation != null
            ? value!.isEmpty
                ? widget.validation
                : null
            : null;
      },
      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.normal),
      cursorColor: AppColors.primary,
      textAlign: TextAlign.start,
      smartDashesType: SmartDashesType.disabled,
      obscureText: widget.isPassword ? !widget.isVissible : widget.isVissible,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        fillColor: widget.fillColors ?? AppColors.light,
        helperText: widget.helperTxt,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: AppColors.primary,
              )
            : null,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.dark.withAlpha(30))),
        hintText: widget.hintText,
        hintStyle: AppTextStyles.bodySmall.copyWith(color: Color(0xff9EA1A8)),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() {
                      widget.isVissible = !widget.isVissible;
                    }),
                icon: Icon(
                  widget.isVissible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.primary,
                ))
            : SizedBox.shrink(),
      ),
    );
  }
}
