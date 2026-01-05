import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/controllers/auth_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});
  final AuthController _authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, PreferencesProvider>(
        builder: (context, api, prefs, child) {
      _authController.nameController.text = api.userProfile?.name ?? '';
      return CustomScaffold(
        isAppbarRequired: true,
        appBarTitle: 'Edit Profile',
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Stack(
            children: [
              Form(
                child: Column(
                  spacing: 10,
                  children: [
                    CircleAvatar(),
                    CustomTextField(
                        hintText: AppStrings.name,
                        keyboardType: TextInputType.text,
                        editingController: _authController.nameController),
                    CustomTextField(
                      hintText: AppStrings.password,
                      keyboardType: TextInputType.visiblePassword,
                      editingController: _authController.passwordController,
                      isPassword: true,
                      isVissible: false,
                    ),
                    CustomTextField(
                      hintText: AppStrings.confirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                      editingController:
                          _authController.confirmPasswordController,
                      isPassword: true,
                      isVissible: false,
                    ),
                    CustomBtn(text: 'Update', onBtnTap: () {})
                  ],
                ),
              ),
              if (api.isLoading) LoaderWidget()
            ],
          ),
        ),
      );
    });
  }
}
