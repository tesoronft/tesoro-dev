import 'package:flutter/cupertino.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/features/dashboard/account/user_account_view.dart';
import 'package:tesoro_nft_app/features/dashboard/home/home_view.dart';
import 'package:tesoro_nft_app/features/dashboard/settings/settings_view.dart';
import 'package:tesoro_nft_app/features/dashboard/treasures/all_treasures/all_treasures_view.dart';

class DashboardData {
  static const List<String> dashboardIcons = [
    AppImages.location,
    AppImages.dollarChest,
    AppImages.person,
    AppImages.user
  ];

  // ✅ FIX: Load screens LAZILY on-demand instead of all at once
  // This prevents multiple simultaneous location requests and API calls
  static Widget getScreen(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return AllTreasuresView(isFromHome: false);
      case 2:
        return UserAccountView();
      case 3:
        return SettingsView();
      default:
        return HomeView();
      //   return HomeView();
    }
  }
}
