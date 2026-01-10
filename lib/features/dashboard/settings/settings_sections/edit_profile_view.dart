import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/controllers/auth_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_avatar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_text_field.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/utils/device_image_picker.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});
  final AuthController _authController = AuthController();
  final ValueNotifier<String?> _profileImage = ValueNotifier<String?>(null);
  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, PreferencesProvider>(
        builder: (context, api, prefs, child) {
      _authController.nameController.text = api.userProfile?.name ?? '';
      return AbsorbPointer(
        absorbing: api.isLoading,
        child: CustomScaffold(
          isAppbarRequired: true,
          appBarTitle: 'Edit Profile',
          backgroundColor: AppColors.light,
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Stack(
              children: [
                ValueListenableBuilder(
                    valueListenable: _profileImage,
                    builder: (context, value, child) {
                      return Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            InkWell(
                              onTap: () async {
                                _profileImage.value = await DeviceImagePicker()
                                    .pickProfileImage();
                              },
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CustomAvatar(
                                      profileImage: _profileImage.value ??
                                          api.userProfile?.profileImage ??
                                          'https://www.vectorstock.com/royalty-free-vector/default-avatar-profile-icon-social-media-user-vector-49816613'),
                                  Positioned(
                                    bottom: 5,
                                    right: 15,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: AppColors.primary),
                                      child: Icon(
                                        Icons.image,
                                        size: 18,
                                        color: AppColors.light,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomTextField(
                                hintText: AppStrings.name,
                                keyboardType: TextInputType.text,
                                editingController:
                                    _authController.nameController),
                            CustomTextField(
                              hintText: AppStrings.password,
                              keyboardType: TextInputType.visiblePassword,
                              editingController:
                                  _authController.passwordController,
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
                            CustomBtn(
                                text: 'Update',
                                onBtnTap: () async {
                                  final authEnum = await api.updateUserData(
                                    prefs.accessToken ?? '',
                                    api.userProfile?.email,
                                    _authController.nameController.text,
                                    _profileImage.value ?? '',
                                    _authController
                                        .confirmPasswordController.text,
                                    _authController.passwordController.text,
                                    prefs.userId ?? '',
                                  );
                                  if (authEnum == ApiEnums.success) {
                                    await api
                                        .getUserData(prefs.accessToken ?? '');
                                    CustomSnackbar().showSnackbar(
                                        SnackBarEnums.success,
                                        'Data Updated Successfully',
                                        context);
                                  } else {
                                    CustomSnackbar().showSnackbar(
                                        SnackBarEnums.failed,
                                        api.responseTxt,
                                        context);
                                  }
                                })
                          ],
                        ),
                      );
                    }),
                if (api.isLoading) LoaderWidget()
              ],
            ),
          ),
        ),
      );
    });
  }
}
