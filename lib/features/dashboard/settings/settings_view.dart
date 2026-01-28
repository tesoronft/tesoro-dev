import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_btn.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/settings_tile.dart';
import 'package:tesoro_nft_app/data/dashboard/settings_data.dart';
import 'package:tesoro_nft_app/features/dashboard/settings/settings_controller.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apisProvider = Provider.of<ApiProvider>(context, listen: false);
      final prefsProvider =
          Provider.of<PreferencesProvider>(context, listen: false);
      if (apisProvider.userProfile == null) {
        await apisProvider.getUserData(prefsProvider.accessToken ?? '');
      }
      if (apisProvider.contentInfoModel == null) {
        await apisProvider.getAppUrls(prefsProvider.accessToken ?? '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ApiProvider, PreferencesProvider>(
      builder: (context, api, prefs, child) => CustomScaffold(
        backgroundColor: AppColors.light,
        isAppbarRequired: true,
        appBarTitle: AppStrings.settings,
        child: SafeArea(
          minimum: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: SettingsData.settingsTitle.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            final privacyPolicy = api.contentInfoModel?.items
                                ?.where((data) => data.name == 'Privacy Policy')
                                .first;
                            final termsAndConditions = api
                                .contentInfoModel?.items
                                ?.where((data) =>
                                    data.name == 'Terms and Conditions')
                                .first;
                            SettingsController.performNavigation(
                                index,
                                privacyPolicy?.id ?? '69498e250d8e23bd58b570a7',
                                termsAndConditions?.id ??
                                    '694259439b4544bc2d874689',
                                context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: SettingsTile(
                              imageUrl: SettingsData.settingsIcon[index],
                              title: SettingsData.settingsTitle[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  CustomBtn(
                      text: 'Logout',
                      trailingIcon: Icon(
                        Icons.logout,
                        color: AppColors.light,
                      ),
                      btnColor: AppColors.error,
                      onBtnTap: () async {
                        await prefs.clearAllValues();
                        context.go(Routes.onboarding1);
                      }),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              prefs.isDeleting
                  ? Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black38,
                        ),
                        child: SpinKitCircle(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
