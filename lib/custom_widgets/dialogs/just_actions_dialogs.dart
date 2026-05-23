import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/dialogs/give_tips_dialog.dart';
import 'package:tesoro_nft_app/custom_widgets/dialogs/navigation_completed_dialog.dart';
import 'package:tesoro_nft_app/custom_widgets/dialogs/treasure_preview.dart';
import 'package:tesoro_nft_app/enums/dialog_enums.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';

import '../../consts/app_colors.dart';
import '../../consts/app_images.dart';
import '../../consts/app_strings.dart';
import '../../enums/api_enums.dart';
import '../../enums/snack_bar_enums.dart';
import '../../models/treasures/treasure_get_model.dart';
import '../../routes/routes.dart';

class JustActionsDialogs extends StatelessWidget {
  const JustActionsDialogs(
      {super.key,
      required this.lottieImage,
      required this.title,
      this.btn1Txt,
      this.btn2Txt,
      this.btn1Tap,
      this.subtitle,
      this.btn2Tap});
  final String lottieImage;
  final String title;

  final String? btn1Txt, btn2Txt, subtitle;
  final Function()? btn1Tap, btn2Tap;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: AppColors.light,
      icon: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => context.pop(),
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0xffE4E4E4),
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(Icons.close)),
          )),
      title: LottieBuilder.asset(lottieImage, height: 100, width: 100),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style:
                AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style:
                  AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (btn1Txt != null)
          CustomBtn(
            width: btn2Txt == null ? double.infinity : 100,
            text: btn1Txt!,
            btnColor: AppColors.dialogBtn,
            onBtnTap: btn1Tap ??
                () {
                  Navigator.of(context).pop(DialogEnums.treasureTaken);
                  // btn1Tap?.call();
                },
          ),
        if (btn2Txt != null)
          CustomBtn(
            width: btn1Txt == null ? double.infinity : 100,
            btnColor: AppColors.dialogBtn,
            text: btn2Txt!,
            onBtnTap: () {
              Navigator.of(context).pop(DialogEnums.treasureNotTaken);
              // btn2Tap?.call();
            },
          ),
      ],
    );
  }
}

Future<DialogEnums?> showActionDialog(
  BuildContext dialogContext, {
  required String title,
  String? subtitle,
  required String lottie,
  required String btn1,
  Function()? btn1Tap,
  String? btn2,
}) {
  return showDialog<DialogEnums>(
    context: dialogContext,
    barrierDismissible: false,
    builder: (_) => JustActionsDialogs(
      title: title,
      subtitle: subtitle,
      lottieImage: lottie,
      btn1Txt: btn1,
      btn2Txt: btn2,
      btn1Tap: () =>
          btn1Tap?.call() ??
          Navigator.pop(dialogContext, DialogEnums.treasureTaken),
      btn2Tap: btn2 == null
          ? null
          : () => Navigator.pop(dialogContext, DialogEnums.treasureNotTaken),
    ),
  );
}

Future<void> showAllDialogs(
    BuildContext allDialogs, String senderId, TreasureGetModel treasure) async {
  final startResult = await showDialog(
    context: allDialogs,
    builder: (context) => TreasurePreview(
      treasure: treasure,
      isConfirmation: true,
    ),
  );
  if (!allDialogs.mounted) return;
  if (startResult == DialogEnums.treasureNotTaken) {
    allDialogs.go(Routes.dashboard);
    return;
  }
  if (!allDialogs.mounted) return;
  final firstResult = await showActionDialog(
    allDialogs,
    title: AppStrings.didYouTakeTheItem,
    lottie: AppImages.takePhotos,
    btn1: AppStrings.yes,
    btn2: AppStrings.no,
    btn1Tap: () async {
      CustomSnackbar().showSnackbar(
          SnackBarEnums.processing, 'Collecting treasure...', allDialogs);
      final result = await allDialogs.read<ApiProvider>().collectTreasure(
          allDialogs.read<PreferencesProvider>().accessToken ?? '',
          senderId,
          treasure.productId ?? '');
      final result2 = await allDialogs.read<ApiProvider>().storeTreasureAmount(
          senderId,
          treasure.postedBy?.id ?? treasure.userId ?? '',
          treasure.productId ?? '',
          treasure.price?.toString() ?? '',
          allDialogs.read<PreferencesProvider>().accessToken ?? '');
      if (result == ApiEnums.success && result2 == ApiEnums.success) {
        CustomSnackbar().showSnackbar(SnackBarEnums.success,
            allDialogs.read<ApiProvider>().responseTxt, allDialogs);
        Navigator.of(allDialogs).pop(DialogEnums.treasureTaken);
      }
    },
  );
  if (!allDialogs.mounted) return;
  if (firstResult == DialogEnums.treasureNotTaken) {
    await showActionDialog(
      allDialogs,
      lottie: AppImages.mapDotted,
      btn1: 'Close',
      title: AppStrings.sorry,
      subtitle: AppStrings.bestOfLuckOnYourAdventure,
    );
    if (!allDialogs.mounted) return;
    allDialogs.go(Routes.dashboard);
    return;
  }
  if (!allDialogs.mounted) return;
  final result2 = await showActionDialog(
    allDialogs,
    lottie: AppImages.mapBrowsing,
    btn1: AppStrings.next,
    //btn1Tap: () => Navigator.of(allDialogs).pop(DialogEnums.treasureTaken),
    title: AppStrings.congratsOnYourTesoroAppFinds,
  );
  if (!allDialogs.mounted) return;
  if (result2 == DialogEnums.treasureNotTaken) {
    allDialogs.go(Routes.dashboard);
    return;
  }
  if (!allDialogs.mounted) return;
  final result3 = await showActionDialog(
    allDialogs,
    lottie: AppImages.money,
    btn1: AppStrings.yes,
    btn2: AppStrings.no,
    title: 'Would you like to give a tip ${treasure.postedBy?.name ?? ''}',
  );
  if (!allDialogs.mounted) return;
  if (result3 == DialogEnums.treasureNotTaken) {
    allDialogs.go(Routes.dashboard);
    return;
  }
  if (!allDialogs.mounted) return;
  final result4 = await showDialog<DialogEnums>(
    context: allDialogs,
    barrierDismissible: false,
    builder: (context) => GiveTipsDialog(
      receiverId: treasure.postedBy?.id ?? treasure.userId ?? '',
      senderId: senderId,
      treasureId: treasure.productId ?? '',
    ),
  );
  if (!allDialogs.mounted) return;
  if (result4 == DialogEnums.treasureNotTaken) {
    allDialogs.go(Routes.dashboard);
    return;
  }
  if (!allDialogs.mounted) return;
  final result5 = await showActionDialog(
    allDialogs,
    lottie: AppImages.dollarchest,
    btn1: AppStrings.next,
    title: AppStrings.thankYouForUsingTheTesoroApp,
  );
  if (!allDialogs.mounted) return;
  if (result5 == DialogEnums.treasureNotTaken) {
    allDialogs.go(Routes.dashboard);
    return;
  }
  if (!allDialogs.mounted) return;
  final result6 = await showDialog<DialogEnums>(
    barrierDismissible: false,
    context: allDialogs,
    builder: (context) => NavigationCompletedDialog(
      treasureId: treasure.productId ?? '',
      userId: senderId,
      name: treasure.postedBy?.name ?? "",
    ),
  );
  if (!allDialogs.mounted) return;
  if (result6 == DialogEnums.treasureTaken) {
    allDialogs.go(Routes.dashboard);
    return;
  }
  if (!allDialogs.mounted) return;
}
