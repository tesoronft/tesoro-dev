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
  BuildContext context, {
  required String title,
  String? subtitle,
  required String lottie,
  required String btn1,
  Function()? btn1Tap,
  String? btn2,
}) {
  return showDialog<DialogEnums>(
    context: context,
    barrierDismissible: false,
    builder: (_) => JustActionsDialogs(
      title: title,
      subtitle: subtitle,
      lottieImage: lottie,
      btn1Txt: btn1,
      btn2Txt: btn2,
      btn1Tap: () =>
          btn1Tap?.call() ?? Navigator.pop(context, DialogEnums.treasureTaken),
      btn2Tap: btn2 == null
          ? null
          : () => Navigator.pop(context, DialogEnums.treasureNotTaken),
    ),
  );
}

Future<void> showAllDialogs(
    BuildContext context, String senderId, TreasureGetModel treasure) async {
  final startResult = await showDialog(
    context: context,
    builder: (context) => TreasurePreview(
      treasure: treasure,
      isConfirmation: true,
    ),
  );
  if (!context.mounted) return;
  if (startResult == DialogEnums.treasureNotTaken) {
    context.go(Routes.dashboard);
    return;
  }
  final firstResult = await showActionDialog(
    context,
    title: AppStrings.didYouTakeTheItem,
    lottie: AppImages.takePhotos,
    btn1: AppStrings.yes,
    btn2: AppStrings.no,
    btn1Tap: () async {
      CustomSnackbar().showSnackbar(
          SnackBarEnums.processing, 'Collecting treasure...', context);
      final result = await context.read<ApiProvider>().collectTreasure(
          context.read<PreferencesProvider>().accessToken ?? '',
          senderId,
          treasure.productId ?? '');
      if (result == ApiEnums.success) {
        CustomSnackbar().showSnackbar(SnackBarEnums.success,
            context.read<ApiProvider>().responseTxt, context);
        Navigator.of(context).pop(DialogEnums.treasureTaken);
      }
    },
  );
  if (!context.mounted) return;

  if (firstResult == DialogEnums.treasureNotTaken) {
    await showActionDialog(
      context,
      lottie: AppImages.mapDotted,
      btn1: 'Close',
      title: AppStrings.sorry,
      subtitle: AppStrings.bestOfLuckOnYourAdventure,
    );
    if (!context.mounted) return;
    context.go(Routes.dashboard);
    return;
  }
  final result2 = await showActionDialog(
    context,
    lottie: AppImages.mapBrowsing,
    btn1: AppStrings.next,
    btn1Tap: () => Navigator.of(context).pop(DialogEnums.treasureNotTaken),
    title: AppStrings.congratsOnYourTesoroAppFinds,
  );
  if (!context.mounted) return;
  if (result2 == DialogEnums.treasureNotTaken) {
    context.go(Routes.dashboard);
    return;
  }
  if (!context.mounted) return;
  final result3 = await showActionDialog(
    context,
    lottie: AppImages.money,
    btn1: AppStrings.yes,
    btn2: AppStrings.no,
    title: 'Would you like to give a tip ${treasure.postedBy?.name ?? ''}',
  );
  if (!context.mounted) return;
  if (result3 == DialogEnums.treasureNotTaken) {
    context.go(Routes.dashboard);
    return;
  }
  if (!context.mounted) return;
  final result4 = await showDialog<DialogEnums>(
    context: context,
    barrierDismissible: false,
    builder: (context) => GiveTipsDialog(
      receiverId: treasure.postedBy?.id ?? treasure.userId ?? '',
      senderId: senderId,
      treasureId: treasure.productId ?? '',
    ),
  );
  if (!context.mounted) return;
  if (result4 == DialogEnums.treasureNotTaken) {
    context.go(Routes.dashboard);
    return;
  }
  if (!context.mounted) return;
  final result5 = await showActionDialog(
    context,
    lottie: AppImages.dollarchest,
    btn1: AppStrings.next,
    title: AppStrings.thankYouForUsingTheTesoroApp,
  );
  if (!context.mounted) return;
  if (result5 == DialogEnums.treasureNotTaken) {
    context.go(Routes.dashboard);
    return;
  }
  if (!context.mounted) return;
  final result6 = await showDialog<DialogEnums>(
    barrierDismissible: false,
    context: context,
    builder: (context) => NavigationCompletedDialog(
      treasureId: treasure.productId ?? '',
      userId: senderId,
      name: treasure.postedBy?.name ?? "",
    ),
  );
  if (!context.mounted) return;
  if (result6 == DialogEnums.treasureTaken) {
    context.go(Routes.dashboard);
    return;
  }
  if (!context.mounted) return;
}
