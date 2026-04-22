import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/internet_checker.dart';

class OfflineView extends StatelessWidget {
  const OfflineView({super.key, this.btn1Tap});
  final Function()? btn1Tap;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: EdgeInsets.all(8),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.offline, height: 250),
            Text(
              'You are offline. Please check your internet connection.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            // Consumer<InternetChecker>(
            //   builder: (context, internet, child) => CustomBtn(
            //     text: 'Refresh',
            //     onBtnTap: () async {
            //       final isConnected = await internet.checkConnection();
            //       if (isConnected) {
            //         btn1Tap?.call() ?? context.go(Routes.splash);
            //       } else {
            //         CustomSnackbar().showSnackbar(
            //             SnackBarEnums.failed,
            //             'Connection is still offline. Please check your network.',
            //             context);
            //       }
            //     },
            //   ),
            // )
          ],
        ));
  }
}
