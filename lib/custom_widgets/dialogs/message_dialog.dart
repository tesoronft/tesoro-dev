import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog(
      {super.key,
      required this.btnTapped,
      required this.btnTxt,
      required this.imageUrl,
      required this.subtitle,
      required this.title});
  final String imageUrl, title, subtitle, btnTxt;
  final VoidCallback btnTapped;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.light,
      icon: Image.asset(imageUrl),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextStyles.headingMedium,
      ),
      content: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium,
      ),
      actions: [
        CustomBtn(text: btnTxt, onBtnTap: btnTapped),
      ],
    );
  }
}
