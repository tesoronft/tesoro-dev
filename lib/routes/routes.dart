import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/features/auth/signin/signin_view.dart';
import 'package:tesoro_nft_app/features/auth/signup/signup_view.dart';
import 'package:tesoro_nft_app/features/dashboard/account/oro_page_view.dart';
import 'package:tesoro_nft_app/features/dashboard/account/tips_given_view.dart';
import 'package:tesoro_nft_app/features/dashboard/account/tips_received_view.dart';
import 'package:tesoro_nft_app/features/dashboard/account/treasure_collected_view.dart';
import 'package:tesoro_nft_app/features/dashboard/account/treasure_posted_view.dart';
import 'package:tesoro_nft_app/features/dashboard/account/user_account_view.dart';
import 'package:tesoro_nft_app/features/dashboard/camera/camera_view.dart';
import 'package:tesoro_nft_app/features/dashboard/settings/settings_sections/edit_profile_view.dart';
import 'package:tesoro_nft_app/features/dashboard/settings/settings_sections/web_view.dart';
import 'package:tesoro_nft_app/features/dashboard/treasures/all_treasures/all_treasures_view.dart';
import 'package:tesoro_nft_app/features/dashboard/treasures/all_treasures/treasure_details_view.dart';
import 'package:tesoro_nft_app/features/dashboard/treasures/post_treasures/confirm_details_view.dart';
import 'package:tesoro_nft_app/features/dashboard/treasures/post_treasures/item_details_view.dart';
import 'package:tesoro_nft_app/features/dashboard/treasures/post_treasures/post_treasure_view.dart';
import 'package:tesoro_nft_app/features/dashboard/treasures/treasure_navigation.dart';
import 'package:tesoro_nft_app/features/onboarding/onboarding1_view.dart';
import 'package:tesoro_nft_app/features/others/delete_account.dart';
import 'package:tesoro_nft_app/features/subscriptions/main_subscription_view.dart';
import 'package:tesoro_nft_app/features/subscriptions/subscription_first_view.dart';
import 'package:tesoro_nft_app/features/subscriptions/subscription_second_view.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_post_model.dart';

import '../features/auth/forgot-password/confirm_email_view.dart';
import '../features/auth/forgot-password/confirm_otp_view.dart';
import '../features/auth/forgot-password/reset_password.dart';
import '../features/dashboard/dashboard_view.dart';
import '../features/dashboard/settings/settings_view.dart';
import '../features/dashboard/treasures/all_treasures/update_treasure_view.dart';
import '../features/onboarding/onboarding2_view.dart';
import '../features/onboarding/splash.dart';
import '../features/others/offline_view.dart';
import '../features/others/update_password.dart';
import '../models/treasures/treasure_get_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Routes {
  static const String splash = '/splash';
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String confirmEmail = '/forgotPassword/confirmEmail';
  static const String confirmOtp = '/forgotPassword/confirmOtp';
  static const String resetPassword = '/forgotPassword/resetPassword';
  static const String forgotPassword = '/forgotPassword';
  static const String dashboard = '/dashboard';
  static const String home = '/dashboard/home';
  static const String settings = '/dashboard/settings';
  static const String updateProfile = '/dashboard/settings/updateProfile';
  static const String userAccount = '/dashboard/account';
  static const String tipsReceived = '/dashboard/account/tipsReceived';
  static const String tipsGiven = '/dashboard/account/tipsGiven';
  static const String treasurePosted = '/dashboard/account/treasurePosted';
  static const String treasureCollected =
      '/dashboard/account/treasureCollected';
  static const String oroPage = '/dashboard/account/oroPage';
  static const String allTreasures = '/dashboard/allTreasures';
  static const String treasureDetails =
      '/dashboard/allTreasures/treasureDetails';
  static const String editTreasureInfo =
      '/dashboard/allTreasures/editTreasureInfo';
  static const String itemDetails = '/dashboard/postTreasures/itemDetails';
  static const String confirmDetails =
      '/dashboard/postTreasures/confirmDetails';
  static const String postTreasure = '/dashboard/postTreasures/postTreasure';
  static const String webView = '/dashboard/settings/webView';
  static const String subscriptionViewOne =
      '/subscriptions/subscriptionViewOne';
  static const String subscriptionViewTwo =
      '/subscriptions/subscriptionViewTwo';
  static const String mainSubscriptionView =
      '/subscriptions/mainSubscriptionView';
  static const String navigationView = '/treasures/navigation';
  static const String cameraView = '/dashboard/cameraView';
  static const String offlineView = '/others/offlineView';
  static const String updatePassword = '/others/updatePassword';
  static const String deleteAccount = '/others/deleteAccount';
  static GoRouter router =
      GoRouter(initialLocation: splash, navigatorKey: navigatorKey, routes: [
    GoRoute(path: splash, builder: (context, state) => const SplashView()),
    GoRoute(
        path: onboarding1,
        builder: (context, state) => const Onboarding1View()),
    GoRoute(
        path: onboarding2,
        builder: (context, state) => const Onboarding2View()),
    GoRoute(path: signin, builder: (context, state) => const SigninView()),
    GoRoute(path: signup, builder: (context, state) => const SignupView()),
    GoRoute(
        path: confirmEmail, builder: (context, state) => ConfirmEmailView()),
    GoRoute(
        path: confirmOtp,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ConfirmOtpView(email: email);
        }),
    GoRoute(
        path: resetPassword,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ResetPassword(email: email);
        }),
    GoRoute(
        path: forgotPassword,
        builder: (context, state) => const Onboarding2View()),
    GoRoute(
        path: dashboard, builder: (context, state) => const DashboardView()),
    GoRoute(path: settings, builder: (context, state) => const SettingsView()),
    GoRoute(
        path: userAccount,
        builder: (context, state) => const UserAccountView()),
    GoRoute(
        path: tipsGiven, builder: (context, state) => const TipsGivenView()),
    GoRoute(
        path: tipsReceived,
        builder: (context, state) => const TipsReceivedView()),
    GoRoute(
        path: treasureCollected,
        builder: (context, state) => const TreasureCollectedView()),
    GoRoute(
        path: treasurePosted,
        builder: (context, state) => const TreasurePostedView()),
    GoRoute(path: oroPage, builder: (context, state) => const OroPageView()),
    GoRoute(
      path: allTreasures,
      pageBuilder: (context, state) {
        // Extract your extra variable
        final isFromHome = state.extra as bool? ?? false;

        return CustomTransitionPage(
          key: state.pageKey,
          child: AllTreasuresView(isFromHome: isFromHome),
          transitionDuration: const Duration(milliseconds: 1000),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
        path: itemDetails,
        builder: (context, state) {
          final data = state.extra as TreasurePostModel;
          return ItemDetailsView(
            treasurePostModel: data,
          );
        }),
    GoRoute(
      path: postTreasure,
      builder: (context, state) => PostTreasureView(),
    ),
    GoRoute(
        path: treasureDetails,
        builder: (context, state) {
          final data = state.extra as TreasureGetModel;
          return TreasureDetailsView(
            treasureGetModel: data,
          );
        }),
    GoRoute(
        path: editTreasureInfo,
        builder: (context, state) {
          final data = state.extra as TreasureGetModel;
          return UpdateTreasureView(
            treasureGetModel: data,
          );
        }),
    GoRoute(
        path: webView,
        builder: (context, state) {
          final url = state.extra as String;
          return WebView(
            contentId: url,
          );
        }),
    GoRoute(
      path: subscriptionViewOne,
      builder: (context, state) => SubscriptionFirstView(),
    ),
    GoRoute(
      path: subscriptionViewTwo,
      builder: (context, state) => SubscriptionSecondView(),
    ),
    GoRoute(
      path: mainSubscriptionView,
      builder: (context, state) => MainSubscriptionView(),
    ),
    GoRoute(
      path: cameraView,
      builder: (context, state) => CameraView(),
    ),
    GoRoute(
        path: navigationView,
        builder: (context, state) {
          final treasure = state.extra as TreasureGetModel;
          return TreasureNavigation(
            treasureGetModel: treasure,
          );
        }),
    GoRoute(
      path: updateProfile,
      builder: (context, state) => EditProfileView(),
    ),
    GoRoute(
      path: offlineView,
      builder: (context, state) => OfflineView(),
    ),
    GoRoute(
      path: updatePassword,
      builder: (context, state) => UpdatePassword(),
    ),
    GoRoute(
      path: deleteAccount,
      builder: (context, state) => DeleteAccountView(),
    ),
    GoRoute(
        path: confirmDetails,
        builder: (context, state) {
          final data = state.extra as TreasurePostModel;
          return ConfirmDetailsView(
            treasurePostModel: data,
          );
        }),
  ]);
}
