import 'package:flutter/cupertino.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_typography.dart';

/// Cupertino Theme configuration adhering strictly to Apple HIG principles,
/// supporting both Day Court and Midnight Court palettes.
class AppTheme {
  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.accentOrange,
      primaryContrastingColor: AppColors.pureWhite,
      scaffoldBackgroundColor: AppColors.creamBackground,
      barBackgroundColor: AppColors.glassFill,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.accentOrange,
        textStyle: AppTypography.body,
        actionTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.accentOrange,
          letterSpacing: -0.4,
        ),
        tabLabelTextStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: AppColors.textSecondary,
        ),
        navTitleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: AppColors.textPrimary,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.accentOrange,
      primaryContrastingColor: AppColors.pureWhite,
      scaffoldBackgroundColor: Color(0xFF07111C),
      barBackgroundColor: Color(0xCC0B1824),
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.accentOrange,
        textStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Color(0xFFFAF7F2),
          letterSpacing: -0.4,
        ),
        actionTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.accentOrange,
          letterSpacing: -0.4,
        ),
        tabLabelTextStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: Color(0xFF8FA2B5),
        ),
        navTitleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: Color(0xFFFAF7F2),
        ),
        navLargeTitleTextStyle: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: Color(0xFFFAF7F2),
        ),
      ),
    );
  }
}
