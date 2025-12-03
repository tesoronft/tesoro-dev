import 'package:flutter/widgets.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class AppSizes {
  static final fullHeight =
      MediaQuery.sizeOf(navigatorKey.currentContext!).height;
  static final fullWidth =
      MediaQuery.sizeOf(navigatorKey.currentContext!).width;
  static final halfHeight =
      MediaQuery.sizeOf(navigatorKey.currentContext!).height / 2;
  static final halfWidth =
      MediaQuery.sizeOf(navigatorKey.currentContext!).width / 2;
}
