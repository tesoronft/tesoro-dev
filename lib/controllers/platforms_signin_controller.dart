import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:tesoro_nft_app/services/remote_config_service.dart';

class PlatformsSigninController {
  static Future<String?> signinWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    try {
      await googleSignIn.initialize(
        serverClientId: RemoteConfigService.getString('google_web_client_id'),
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
      log('Google Sign-In User: ${googleUser?.email}, ID: ${googleUser?.id}');
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      log('Google Auth Tokens - ID Token: ${googleAuth.idToken}');
      return googleAuth.idToken ?? googleUser.id;
    } on GoogleSignInException catch (e) {
      log(e.toString());
      return null;
    }
  }
}
