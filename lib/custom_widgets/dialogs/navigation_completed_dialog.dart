import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/enums/dialog_enums.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';

import '../../consts/app_colors.dart';

class NavigationCompletedDialog extends StatelessWidget {
  NavigationCompletedDialog(
      {super.key,
      required this.treasureId,
      required this.userId,
      required this.name});
  final ValueNotifier<int> rating = ValueNotifier<int>(3);
  final String userId, treasureId, name;
  final List<String> ratingsText = [
    'Alright',
    'Good',
    'Great',
    'Excellent',
    'Wow',
  ];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: rating,
        builder: (context, rate, child) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.light,
            icon: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () =>
                      Navigator.of(context).pop(DialogEnums.treasureNotTaken),
                  child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Color(0xffE4E4E4),
                          borderRadius: BorderRadius.circular(100)),
                      child: Icon(Icons.close)),
                )),
            //contentPadding: EdgeInsets.all(12),
            content: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please rate ${name} treasure',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                // Text(
                //   '',
                //   textAlign: TextAlign.center,
                //   style: AppTextStyles.bodyMedium
                //       .copyWith(fontWeight: FontWeight.normal),
                // ),
                RatingBar.builder(
                  unratedColor: Colors.black,
                  initialRating: rating.value.toDouble(),
                  itemSize: 50,
                  itemBuilder: (context, index) {
                    return Column(
                      spacing: 5,
                      children: [
                        Image.asset(
                          AppImages.diamondChest,
                          color: AppColors.primary,
                        ),
                        Text(
                          ratingsText[index],
                          style: AppTextStyles.headingMedium.copyWith(
                              fontSize: 40, fontWeight: FontWeight.w300),
                        )
                      ],
                    );
                  },
                  onRatingUpdate: (value) {
                    rating.value = value.toInt();
                  },
                )
              ],
            ),
            actions: [
              Consumer2<ApiProvider, PreferencesProvider>(
                builder: (context, apis, prefs, child) => apis.isLoading
                    ? Center(
                        child: SpinKitCircle(
                        color: AppColors.dialogBtn,
                      ))
                    : CustomBtn(
                        btnColor: AppColors.dialogBtn,
                        text: AppStrings.rateTreasure,
                        onBtnTap: () async {
                          final result = await apis.createRating(
                              userId,
                              treasureId,
                              prefs.accessToken ?? '',
                              rating.value);
                          if (result == ApiEnums.success) {
                            CustomSnackbar().showSnackbar(SnackBarEnums.success,
                                apis.responseTxt, context);
                            Navigator.of(context)
                                .pop(DialogEnums.treasureTaken);
                          } else {
                            CustomSnackbar().showSnackbar(SnackBarEnums.failed,
                                apis.responseTxt, context);
                          }
                        },
                        // width: 100,
                      ),
              ),
              // CustomBtn(
              //   text: AppStrings.no,
              //   onBtnTap: () {},
              //   width: 100,
              // ),
            ],
          );
        });
  }
}
