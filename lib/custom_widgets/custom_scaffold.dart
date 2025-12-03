import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';

import '../consts/app_text_styles.dart';

class CustomScaffold extends StatelessWidget {
  CustomScaffold(
      {super.key,
      required this.child,
      this.appBar,
      this.defaultPadding,
      this.extendBody,
      this.backgroundColor,
      this.isAppbarRequired = false,
      this.appBarTitle,
      this.appBarTitleColor});
  final Widget child;
  final PreferredSizeWidget? appBar;
  final EdgeInsets? defaultPadding;
  final bool? extendBody;
  bool isAppbarRequired = false;
  final Color? backgroundColor, appBarTitleColor;
  final String? appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor ?? AppColors.primary,
      extendBody: extendBody ?? true,
      appBar: isAppbarRequired == false
          ? null
          : AppBar(
              backgroundColor: AppColors.light,
              surfaceTintColor: AppColors.light,
              centerTitle: true,
              title: Text(
                appBarTitle ?? '',
                style: AppTextStyles.headingMedium
                    .copyWith(color: appBarTitleColor ?? AppColors.dark),
              ),
            ),
      body: child,
    );
  }
}
