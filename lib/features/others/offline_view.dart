import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/utils/internet_checker.dart';

class OfflineView extends StatelessWidget {
  const OfflineView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => false,
      child: CustomScaffold(
          backgroundColor: AppColors.light,
          child: SafeArea(
              minimum: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    'You are offline. Please check your internet connection.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  )),
                  Consumer<InternetChecker>(
                    builder: (context, internet, child) => CustomBtn(
                      text: 'Refresh',
                      onBtnTap: () async {
                        // final isConnected = await internet.initConnectivity();
                        // if (isConnected) {
                        //   Navigator.of(context).pop();
                        // }
                      },
                    ),
                  )
                ],
              ))),
    );
  }
}
