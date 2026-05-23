import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';

class SettingsData {
  static List<String> settingsTitle = [
    AppStrings.myAccount,
    //AppStrings.upgradeToPremium,
    AppStrings.aboutUs,
    AppStrings.privacyPolicy,
    AppStrings.termsAndConditions,
    AppStrings.rateUs,
    AppStrings.feedback,
    AppStrings.contactUs,
    AppStrings.shareTesoroApp
  ];
  static const List<String> settingsIcon = [
    AppImages.profile,
    AppImages.about,
    AppImages.privacyPolicy,
    AppImages.doc,
    AppImages.star,
    AppImages.chat,
    AppImages.phone,
    AppImages.share,
  ];
}
