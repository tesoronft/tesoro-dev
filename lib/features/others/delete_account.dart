import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/auth_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../../enums/api_enums.dart';

class DeleteAccountView extends StatelessWidget {
  DeleteAccountView({super.key});
  final AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isAppbarRequired: true,
        backgroundColor: AppColors.light,
        appBarTitle: AppStrings.deleteAccount,
        child: Consumer2<ApiProvider, PreferencesProvider>(
          builder: (context, api, prefs, child) => SafeArea(
              minimum: EdgeInsets.all(6),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(AppStrings.areYouSureYouWantToDelete,
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.dark),
                          textAlign: TextAlign.center),
                      Text(
                        AppStrings.deletingYourAccountWillResultIn,
                        style: AppTextStyles.labelMedium
                            .copyWith(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                      if (prefs.isSSOUser == null)
                        CustomTextField(
                            hintText: AppStrings.enterPassword,
                            keyboardType: TextInputType.visiblePassword,
                            editingController:
                                authController.passwordController,
                            isPassword: true),
                      CustomBtn(
                        text: AppStrings.deleteAccount,
                        onBtnTap: () async {
                          final result = await api.deleteAccount(
                              authController.passwordController.text,
                              prefs.userId!);

                          if (result == ApiEnums.success) {
                            await prefs.clearAllValues();

                            navigatorKey.currentContext?.go(Routes.onboarding1);
                          } else {}
                        },
                      )
                    ],
                  ),
                  prefs.isDeleting ? LoaderWidget() : SizedBox()
                ],
              )),
        ));
  }
}
