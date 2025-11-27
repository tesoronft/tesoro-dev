import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {super.key,
      required this.child,
      this.appBar,
      this.defaultPadding,
      this.extendBody});
  final Widget child;
  final PreferredSizeWidget? appBar;
  final EdgeInsets? defaultPadding;
  final bool? extendBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      extendBody: extendBody ?? false,
      appBar: appBar,
      body: child,
    );
  }
}
