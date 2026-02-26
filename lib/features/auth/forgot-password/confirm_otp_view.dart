import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

import '../../../consts/app_colors.dart';
import '../../../consts/app_images.dart';
import '../../../controllers/auth_controller.dart';
import '../../../custom_widgets/custom_btn.dart';
import '../../../custom_widgets/custom_text_field.dart';
import '../../../enums/api_enums.dart';
import '../../../enums/snack_bar_enums.dart';
import '../../../providers/api_provider.dart';

class ConfirmOtpView extends StatelessWidget {
  ConfirmOtpView({super.key, required this.email});
  final String email;
  final AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    authController.emailController.text = email;
    return CustomScaffold(
        backgroundColor: AppColors.light,
        isAppbarRequired: true,
        appBarTitle: 'Confirm OTP',
        child: SafeArea(
            minimum: EdgeInsets.all(6.0),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(AppImages.logo, height: 100),
                CustomTextField(
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    editingController: authController.emailController),
                CustomTextField(
                    hintText: 'Enter Otp',
                    keyboardType: TextInputType.number,
                    editingController: authController.otpController),
                Consumer<ApiProvider>(
                  builder: (context, apiProvider, child) {
                    return apiProvider.isLoading
                        ? Center(
                            child: SpinKitCircle(
                              color: AppColors.primary,
                            ),
                          )
                        : CustomBtn(
                            text: 'Confirm OTP',
                            onBtnTap: () async {
                              final result = await apiProvider.verifyOtp(
                                  authController.emailController.text,
                                  authController.otpController.text);
                              if (result == ApiEnums.success) {
                                CustomSnackbar().showSnackbar(
                                    SnackBarEnums.success,
                                    apiProvider.responseTxt,
                                    context);
                                context.push(Routes.resetPassword,
                                    extra: authController.emailController.text);
                                return;
                              } else {
                                CustomSnackbar().showSnackbar(
                                    SnackBarEnums.failed,
                                    apiProvider.responseTxt,
                                    context);
                              }
                            },
                          );
                  },
                )
              ],
            )));
  }
}
