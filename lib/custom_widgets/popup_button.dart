import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';

class PopupButton extends StatelessWidget {
  const PopupButton(
      {super.key,
      this.onTap,
      this.icon,
      this.iconColor,
      this.iconBgColor,
      this.iconRadius});
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? iconColor, iconBgColor;
  final int? iconRadius;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            context.pop();
          },
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: iconBgColor ?? AppColors.light,
          borderRadius: BorderRadius.circular(iconRadius?.toDouble() ?? 10.0),
        ),
        child: Center(
          child: Icon(
            icon ?? Icons.arrow_back_ios,
            size: 18,
            color: iconColor ?? AppColors.dark,
          ),
        ),
      ),
    );
  }
}
