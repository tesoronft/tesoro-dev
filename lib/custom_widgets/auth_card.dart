import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/auth_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class AuthCard extends StatelessWidget {
  AuthCard({super.key, required this.issSignin, required this.onBtnTap});
  final bool issSignin;
  final VoidCallback onBtnTap;
  final AuthController _authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, PreferencesProvider>(
      builder: (context, apis, prefs, child) => Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(80),
          border: Border.all(color: AppColors.light),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark.withAlpha(20),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: AppColors.dark.withAlpha(20),
              blurRadius: 4,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Image.asset(
                AppImages.transparantLogo,
                height: 75,
              ),
              Form(
                child: Column(
                  spacing: 20,
                  children: [
                    if (!issSignin)
                      CustomTextField(
                        editingController: _authController.nameController,
                        hintText: AppStrings.name,
                        keyboardType: TextInputType.name,
                      ),
                    CustomTextField(
                      editingController: _authController.emailController,
                      hintText: AppStrings.exampleEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      editingController: _authController.passwordController,
                      hintText: AppStrings.password,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      // onVisibilityTap: () {},
                    ),
                    if (!issSignin)
                      CustomTextField(
                        editingController:
                            _authController.confirmPasswordController,
                        hintText: AppStrings.confirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        //  onVisibilityTap: () {},
                      ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.dark,
                              fontWeight: FontWeight.w900),
                        )),
                    apis.isLoading
                        ? SpinKitCircle(
                            color: AppColors.primary,
                          )
                        : CustomBtn(
                            text: issSignin
                                ? AppStrings.signin
                                : AppStrings.signup,
                            onBtnTap: () async {
                              final result = issSignin
                                  ? await apis.signInUser(
                                      _authController.emailController.text,
                                      _authController.passwordController.text)
                                  : await apis.createAccount(
                                      _authController.nameController.text,
                                      _authController.emailController.text,
                                      _authController.passwordController.text);
                              if (!apis.isLoading &&
                                  result == ApiEnums.success) {
                                CustomSnackbar().showSnackbar(
                                    SnackBarEnums.success,
                                    apis.responseTxt,
                                    context);
                                await prefs.setUserId(
                                    apis.authModel?.user?.userId ?? '');
                                await prefs.setAccessToken(
                                    apis.authModel?.accessToken ?? '');
                                await prefs.setRefreshToken(
                                    apis.authModel?.refreshToken ?? '');
                                context.go(Routes.dashboard);
                              } else {
                                CustomSnackbar().showSnackbar(
                                    SnackBarEnums.failed,
                                    apis.responseTxt,
                                    context);
                              }
                            },
                          ),
                    RichText(
                      text: TextSpan(
                        text: issSignin
                            ? AppStrings.dontHaveAnAccount
                            : AppStrings.alreadyHaveAnAccount,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.black),
                        children: [
                          TextSpan(
                              text: issSignin
                                  ? ' ${AppStrings.signup}'
                                  : ' ${AppStrings.signin}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                decorationColor: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(
                                    !issSignin ? Routes.signin : Routes.signup,
                                  );
                                }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
