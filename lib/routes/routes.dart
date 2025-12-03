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
import 'package:tesoro_nft_app/features/onboarding/onboarding1_view.dart';

import '../features/dashboard/dashboard_view.dart';
import '../features/dashboard/settings/settings_view.dart';
import '../features/onboarding/onboarding2_view.dart';
import '../features/onboarding/splash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Routes {
  static const String splash = '/splash';
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String dashboard = '/dashboard';
  static const String home = '/dashboard/home';
  static const String settings = '/dashboard/settings';
  static const String userAccount = '/dashboard/account';
  static const String tipsReceived = '/dashboard/account/tipsReceived';
  static const String tipsGiven = '/dashboard/account/tipsGiven';
  static const String treasurePosted = '/dashboard/account/treasurePosted';
  static const String treasureCollected =
      '/dashboard/account/treasureCollected';
  static const String oroPage = '/dashboard/account/oroPage';
  static GoRouter router = GoRouter(initialLocation: splash, routes: [
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
  ]);
}
