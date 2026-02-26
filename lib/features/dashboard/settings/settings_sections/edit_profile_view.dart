import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
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
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/device_image_picker.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});
  final AuthController _authController = AuthController();
  final ValueNotifier<XFile?> _profileImage = ValueNotifier<XFile?>(null);

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
                                      profileImage: _profileImage.value?.path ??
                                          api.userProfile?.profileImage ??
                                          'https://e7.pngegg.com/pngimages/371/667/png-clipart-computer-icons-user-profile-encapsulated-postscript-icon-black-rectangle-black.png'),
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
                            CustomBtn(
                                text: 'Update',
                                onBtnTap: () async {
                                  final result = await api.getImageUrl(
                                      _profileImage.value!,
                                      'user-profiles',
                                      prefs.accessToken ?? '');
                                  final authEnum = await api.updateUserData(
                                    prefs.accessToken ?? '',
                                    api.userProfile?.email,
                                    _authController.nameController.text,
                                    result,
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
                                }),
                            SizedBox(height: 20),
                            if (prefs.isSSOUser != true)
                              ListTile(
                                title: Text('Update Password'),
                                onTap: () =>
                                    context.push(Routes.updatePassword),
                                // tileColor: AppColors.lightPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Color(0xff9EA1A8))),
                                titleTextStyle: AppTextStyles.bodyMedium,
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: AppColors.dark, size: 16),
                              ),
                            ListTile(
                              title: Text('Delete Account'),
                              onTap: () => context.push(Routes.deleteAccount),
                              tileColor: AppColors.error,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Color(0xff9EA1A8))),
                              titleTextStyle: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.light),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: AppColors.light, size: 16),
                            ),
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
