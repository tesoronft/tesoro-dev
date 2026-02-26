import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/controllers/auth_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/form_validator.dart';

import '../../../consts/app_colors.dart';
import '../../../enums/api_enums.dart';
import '../../../enums/snack_bar_enums.dart';

class ConfirmEmailView extends StatelessWidget {
  ConfirmEmailView({super.key});
  final AuthController authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: AppColors.light,
        isAppbarRequired: true,
        appBarTitle: 'Confirm your email',
        child: SafeArea(
            minimum: EdgeInsets.all(6.0),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(AppImages.logo, height: 100),
                Form(
                  key: _formKey,
                  child: CustomTextField(
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    editingController: authController.emailController,
                    validation: FormValidators.validateEmail(
                        authController.emailController.text),
                  ),
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
                            text: 'Send OTP',
                            onBtnTap: () async {
                              if (_formKey.currentState!.validate()) {
                                final result = await apiProvider.confirmEmail(
                                    authController.emailController.text);
                                if (result == ApiEnums.success) {
                                  CustomSnackbar().showSnackbar(
                                      SnackBarEnums.success,
                                      apiProvider.responseTxt,
                                      context);
                                  context.push(Routes.confirmOtp,
                                      extra:
                                          authController.emailController.text);
                                  return;
                                } else {
                                  CustomSnackbar().showSnackbar(
                                      SnackBarEnums.failed,
                                      apiProvider.responseTxt,
                                      context);
                                }
                              }
                            },
                          );
                  },
                )
              ],
            )));
  }
}
