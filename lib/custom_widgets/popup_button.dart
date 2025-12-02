import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';

class PopupButton extends StatelessWidget {
  const PopupButton({super.key, this.onTap});
  final VoidCallback? onTap;
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
          color: AppColors.light,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: AppColors.dark,
          ),
        ),
      ),
    );
  }
}
