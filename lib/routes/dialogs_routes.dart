import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/enums/dialog_enums.dart';

import '../consts/app_images.dart';
import '../consts/app_strings.dart';
import '../custom_widgets/dialogs/just_actions_dialogs.dart';
import 'routes.dart';

class DialogsRoutes {
  void showNextDialog(DialogEnums dialogType) {
    late JustActionsDialogs dialog;
    switch (dialogType) {
      case DialogEnums.treasureTaken:
        dialog = JustActionsDialogs(
            lottieImage: AppImages.dollarchest,
            btn1Txt: AppStrings.next,
            btn1Tap: () => navigatorKey.currentContext?.go(Routes.dashboard),
            title: AppStrings.congratsOnYourTesoroAppFinds);
        break;
      case DialogEnums.treasureNotTaken:
        dialog = JustActionsDialogs(
            lottieImage: AppImages.mapDotted,
            btn1Txt: AppStrings.next,
            btn1Tap: () => navigatorKey.currentContext?.go(Routes.dashboard),
            title: AppStrings.congratsOnYourTesoroAppFinds);
        break;
      default:
    }
    showDialog(
        context: navigatorKey.currentContext!, builder: (context) => dialog);
  }
}
