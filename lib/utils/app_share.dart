import 'package:share_plus/share_plus.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';

class AppShare {
  static Future<void> shareApp() async {
    final share = SharePlus.instance;
    await share.share(ShareParams(
      title: AppStrings.downloadThisAmazingApp,
      text: AppStrings.oneMansTrashIsAnotherTreasure,
      previewThumbnail: XFile(AppImages.logo),
    ));
  }
}
