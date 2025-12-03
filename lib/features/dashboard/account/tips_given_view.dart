import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/custom_widgets/tips_info.dart';

class TipsGivenView extends StatelessWidget {
  const TipsGivenView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: AppColors.light,
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupButton(),
                  Text(
                    AppStrings.tipsGiven,
                    style: AppTextStyles.headingMedium,
                  ),
                  SizedBox.shrink()
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TipsInfo(
                              address: '7820 Melrose Ave, Los Angeles, CA',
                              amountTitle: AppStrings.amountTipped,
                              date: 'Feb 21, 2025',
                              totalAmount: '\$3',
                              userName: 'John Doe'),
                        );
                      }))
            ],
          ),
        ));
  }
}
