import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/settings_tile.dart';
import 'package:tesoro_nft_app/data/dashboard/settings_data.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.light,
      isAppbarRequired: true,
      appBarTitle: AppStrings.settings,
      child: SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: SettingsData.settingsTitle.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SettingsTile(
                      imageUrl: SettingsData.settingsIcon[index],
                      title: SettingsData.settingsTitle[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
