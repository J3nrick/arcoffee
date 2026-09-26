import 'package:flutter/cupertino.dart';
import '../core/constants/app_colors.dart';

/// Available aesthetic modes for Arcoffee.
enum CourtThemeMode {
  dayCourt,
  midnightCourt,
}

/// Dynamic Theme Engine reacting to current day and hour (especially 24-hour weekends),
/// with smooth manual override capability.
class ThemeController extends ChangeNotifier {
  CourtThemeMode _mode = CourtThemeMode.dayCourt;
  bool _isManualOverride = false;

  ThemeController() {
    _evaluateTimeOfDay();
  }

  CourtThemeMode get mode => _mode;
  bool get isMidnightCourt => _mode == CourtThemeMode.midnightCourt;
  bool get isManualOverride => _isManualOverride;

  /// Evaluates current schedule:
  /// On Fri-Sun late-night / overnight (or any evening past 7:00 PM),
  /// defaults to "Midnight Court" mode.
  void _evaluateTimeOfDay() {
    final now = DateTime.now();
    final hour = now.hour;
    final weekday = now.weekday; // 5 = Friday, 6 = Saturday, 7 = Sunday

    // Friday - Sunday late night / 24-hour session
    final isWeekend24h = weekday == DateTime.friday ||
        weekday == DateTime.saturday ||
        weekday == DateTime.sunday;

    final isNightHours = hour >= 19 || hour < 6;

    if (isWeekend24h && isNightHours) {
      _mode = CourtThemeMode.midnightCourt;
    } else if (isNightHours) {
      _mode = CourtThemeMode.midnightCourt;
    } else {
      _mode = CourtThemeMode.dayCourt;
    }
  }

  /// Toggle manually between Day Court and Midnight Court
  void toggleTheme() {
    _isManualOverride = true;
    _mode = isMidnightCourt ? CourtThemeMode.dayCourt : CourtThemeMode.midnightCourt;
    notifyListeners();
  }

  void setMode(CourtThemeMode newMode) {
    _isManualOverride = true;
    if (_mode == newMode) return;
    _mode = newMode;
    notifyListeners();
  }

  // --- Dynamic Theme Color Tokens ---

  Color get scaffoldBackground => isMidnightCourt
      ? const Color(0xFF08111B)
      : AppColors.creamBackground;

  Color get cardBackground => isMidnightCourt
      ? const Color(0xFF0F1E2E)
      : AppColors.pureWhite;

  Color get glassBackground => isMidnightCourt
      ? const Color(0xD90A1522)
      : AppColors.glassFill;

  Color get glassWhite => isMidnightCourt
      ? const Color(0xB8122334)
      : AppColors.glassWhite;

  Color get primaryText => isMidnightCourt
      ? const Color(0xFFFBF7EB)
      : AppColors.textPrimary;

  Color get secondaryText => isMidnightCourt
      ? const Color(0xFF90A4B8)
      : AppColors.textSecondary;

  Color get tertiaryText => isMidnightCourt
      ? const Color(0xFF6B8094)
      : AppColors.textTertiary;

  Color get borderLight => isMidnightCourt
      ? const Color(0x337A92A8)
      : AppColors.borderLight;

  Color get accentOrange => AppColors.accentOrange;

  Color get desktopWallpaper => isMidnightCourt
      ? const Color(0xFF040A10)
      : const Color(0xFFEDE4D4);

  Color get titlebarBg => isMidnightCourt
      ? const Color(0xF2091420)
      : const Color(0xF2FBF7EB);

  List<BoxShadow> get glowingOrangeShadow => isMidnightCourt
      ? [
          BoxShadow(
            color: AppColors.accentOrange.withValues(alpha: 0.55),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.accentOrange.withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: 6,
          ),
        ]
      : [
          BoxShadow(
            color: AppColors.accentOrange.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ];

  List<BoxShadow> get cardElevationShadow => isMidnightCourt
      ? [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ]
      : [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ];
}

/// Global InheritedNotifier to access ThemeController anywhere down the widget tree.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'No ThemeScope found in context');
    return scope!.notifier!;
  }
}
