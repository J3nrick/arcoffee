import 'package:flutter/cupertino.dart';
import '../core/design/app_colors.dart';
import '../core/design/app_typography.dart';

/// Cupertino Theme configuration adhering strictly to Apple HIG principles,
/// supporting both Day Court and Midnight Court palettes.
class AppTheme {
  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.accentOrange,
      primaryContrastingColor: AppColors.pureWhite,
      scaffoldBackgroundColor: AppColors.surfaceDayL1,
      barBackgroundColor: AppColors.glassDay,
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
          color: AppColors.textSecondaryDay,
        ),
        navTitleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: AppColors.deepBlue,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: AppColors.deepBlue,
        ),
      ),
    );
  }

  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.accentOrange,
      primaryContrastingColor: AppColors.pureWhite,
      scaffoldBackgroundColor: AppColors.surfaceNightL1,
      barBackgroundColor: AppColors.glassNight,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.accentOrange,
        textStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimaryNight,
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
          color: AppColors.textSecondaryNight,
        ),
        navTitleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: AppColors.textPrimaryNight,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: AppColors.textPrimaryNight,
        ),
      ),
    );
  }
}
