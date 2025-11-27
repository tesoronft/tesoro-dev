import 'package:flutter/widgets.dart';

class AppColors {
  static const Color primary = Color(0xFFD4AF37);
  static const Color dialogBtn = Color(0xFF0D5C63);
  static const Color error = Color(0xFFD00E13);
  static const Color lightPrimary = Color(0xFFFDE7CD);
  static const Color currency = Color(0xFF34C759);
  static const Color dark = Color(0xFF121A2C);
  static const Color light = Color(0xFFFFFFFF);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD700),
      Color(0xFFC99700),
    ],
  );
}
