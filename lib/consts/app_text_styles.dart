import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';

class AppTextStyles {
  static TextStyle headingLarge = GoogleFonts.raleway(
    fontSize: 32,
    height: 1,
    fontWeight: FontWeight.w900,
    color: AppColors.light,
  );
  static TextStyle headingMedium = GoogleFonts.raleway(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.dark,
  );
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.light,
  );
  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.dark,
  );
  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
  );
  static TextStyle labelMedium = GoogleFonts.raleway(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
  );
}
