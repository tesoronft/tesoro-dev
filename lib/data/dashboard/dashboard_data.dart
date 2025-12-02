import 'package:flutter/cupertino.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/features/dashboard/settings/settings_view.dart';

class DashboardData {
  static const List<String> dashboardIcons = [
    AppImages.location,
    AppImages.dollarChest,
    AppImages.person,
    AppImages.user
  ];
  static List<Widget> dashboardScreens = [
    Placeholder(),
    Placeholder(),
    Placeholder(),
    SettingsView()
  ];
}
