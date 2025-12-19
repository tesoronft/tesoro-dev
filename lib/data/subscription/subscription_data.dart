import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';

class SubscriptionData {
  static List<Map<String, dynamic>> tilesData = [
    {
      'title': AppStrings.now,
      'subtitle': AppStrings.startYourTrialToUnlock,
    },
    {
      'title': AppStrings.inFiveDays,
      'subtitle': AppStrings.receiveAnEmailReminder,
    },
    {
      'title': AppStrings.inSevenDays,
      'subtitle': AppStrings.youWillBeCharged,
    }
  ];
  static List<String> labels = [
    AppStrings.getExclusiveAccess,
    AppStrings.getInstantCategorized,
    AppStrings.hideAnItemFromMap,
    AppStrings.optimizeYourSearch,
    AppStrings.notificationOnCategorizedItem,
  ];
  static List<String> images = [
    AppImages.chest,
    AppImages.notification,
    AppImages.searchMap,
    AppImages.searchTreasure,
    AppImages.bell,
  ];
}
