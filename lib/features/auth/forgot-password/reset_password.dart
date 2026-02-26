import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/form_validator.dart';

import '../../../controllers/auth_controller.dart';
import '../../../custom_widgets/custom_btn.dart';
import '../../../custom_widgets/custom_snackbar.dart';
import '../../../custom_widgets/custom_text_field.dart';
import '../../../enums/api_enums.dart';
import '../../../enums/snack_bar_enums.dart';
import '../../../providers/api_provider.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key, required this.email});
  final String email;
  final AuthController authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    authController.emailController.text = email;
    return CustomScaffold(
        backgroundColor: AppColors.light,
        isAppbarRequired: true,
        appBarTitle: 'Reset Password',
        child: SafeArea(
            minimum: EdgeInsets.all(6.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  Image.asset(AppImages.logo, height: 100),
                  CustomTextField(
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    editingController: authController.emailController,
                    validation: FormValidators.validateEmail(
                        authController.emailController.text),
                  ),
                  CustomTextField(
                    hintText: 'Enter New Password',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    editingController: authController.passwordController,
                    validation: FormValidators.validatePassword(
                        authController.passwordController.text),
                  ),
                  Consumer<ApiProvider>(
                    builder: (context, apiProvider, child) {
                      return apiProvider.isLoading
                          ? Center(
                              child: SpinKitCircle(
                                color: AppColors.primary,
                              ),
                            )
                          : CustomBtn(
                              text: 'Update',
                              onBtnTap: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                final result = await apiProvider.resetPassword(
                                    authController.emailController.text,
                                    authController.passwordController.text);
                                if (result == ApiEnums.success) {
                                  CustomSnackbar().showSnackbar(
                                      SnackBarEnums.success,
                                      apiProvider.responseTxt,
                                      context);
                                  context.go(Routes.signin);
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
              ),
            )));
  }
}
