import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class PlatformsSigninController {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool _isGoogleSignInInitialized = false;

  static Future<String?> signinWithGoogle() async {
    try {
      if (!_isGoogleSignInInitialized) {
        await _googleSignIn.initialize(
          // serverClientId: RemoteConfigService.getString('google_web_client_id'),
          serverClientId:
              '498406490238-ooucift9ll6q12iehoi89relpgnskuo4.apps.googleusercontent.com',
        );
        _isGoogleSignInInitialized = true;
      }
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      log('Google Sign-In User: ${googleUser.email}, ID: ${googleUser.id}');

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      log('Google Auth Tokens - ID Token: ${googleAuth.idToken}');
      return googleAuth.idToken ?? googleUser.id;
    } catch (e) {
      log(e.toString());
      CustomSnackbar().showSnackbar(
          SnackBarEnums.failed, e.toString(), navigatorKey.currentContext!);
      return null;
    }
  }

  static Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      log('User signed out from Google');
    } catch (e) {
      log('Error signing out from Google: ${e.toString()}');
    }
  }

  static Future<String?> signInWithApple() async {
    final appleSignInAvailable = await SignInWithApple.isAvailable();
    if (!appleSignInAvailable) {
      log('Apple Sign-In is not available on this device');
      return null;
    }
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      log('Apple Sign-In Credential: ${credential.email}, ID: ${credential.userIdentifier}');
      return credential.userIdentifier;
    } catch (e) {
      log('Error during Apple Sign-In: ${e.toString()}');
      return null;
    }
  }
}
