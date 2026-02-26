import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/utils/form_validator.dart';

import '../../consts/app_strings.dart';
import '../../controllers/auth_controller.dart';
import '../../custom_widgets/custom_btn.dart';
import '../../custom_widgets/custom_snackbar.dart';
import '../../custom_widgets/custom_text_field.dart';
import '../../enums/api_enums.dart';
import '../../enums/snack_bar_enums.dart';

class UpdatePassword extends StatelessWidget {
  UpdatePassword({super.key});
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: AppColors.light,
        isAppbarRequired: true,
        appBarTitle: 'Update Password',
        child: SafeArea(
            minimum: EdgeInsets.all(6),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 12,
                children: [
                  CustomTextField(
                    hintText: 'Current Password',
                    keyboardType: TextInputType.visiblePassword,
                    editingController:
                        _authController.currentPasswordController,
                    isPassword: true,
                    // isVissible: false,
                  ),
                  CustomTextField(
                    hintText: 'New Password',
                    keyboardType: TextInputType.visiblePassword,
                    editingController: _authController.passwordController,
                    isPassword: true,
                    validation: FormValidators.validatePassword(
                        _authController.passwordController.text),
                    // isVissible: false,
                  ),
                  CustomTextField(
                    hintText: AppStrings.confirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    editingController:
                        _authController.confirmPasswordController,
                    isPassword: true,
                    validation: FormValidators.validateConfirmPassword(
                        _authController.passwordController.text,
                        _authController.confirmPasswordController.text),
                    //isVissible: false,
                  ),
                  Consumer2<ApiProvider, PreferencesProvider>(
                    builder: (context, api, prefs, child) => api.isLoading
                        ? LoaderWidget()
                        : CustomBtn(
                            text: 'Update',
                            onBtnTap: () async {
                              if (_formKey.currentState!.validate()) {
                                return;
                              }
                              final authEnum = await api.updateUserData(
                                prefs.accessToken ?? '',
                                api.userProfile?.email,
                                _authController.nameController.text,
                                '',
                                _authController.confirmPasswordController.text,
                                _authController.currentPasswordController.text,
                                prefs.userId ?? '',
                              );
                              if (authEnum == ApiEnums.success) {
                                await api.getUserData(prefs.accessToken ?? '');
                                CustomSnackbar().showSnackbar(
                                    SnackBarEnums.success,
                                    'Password Updated Successfully',
                                    context);
                              } else {
                                CustomSnackbar().showSnackbar(
                                    SnackBarEnums.failed,
                                    api.responseTxt,
                                    context);
                              }
                            }),
                  ),
                ],
              ),
            )));
  }
}
