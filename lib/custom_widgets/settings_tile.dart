import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.imageUrl, required this.title});
  final String imageUrl, title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 0),
            ),
          ]),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 6,
        children: [
          SvgPicture.asset(imageUrl),
          Text(
            title,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.dark, fontWeight: FontWeight.normal),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
          ),
        ],
      ),
    );
  }
}
