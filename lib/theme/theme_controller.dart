import 'package:flutter/cupertino.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/theme_clock.dart';

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

  /// Evaluates current schedule using ThemeClock:
  /// On Fri, Sat, Sun evening/late-night hours (6:00 PM to 4:00 AM) or nocturnal hours,
  /// defaults to "Night Court" mode.
  void _evaluateTimeOfDay() {
    if (ThemeClock.isNightCourtActive()) {
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
      ? const Color(0xFF0B1F33) // Arcoffee Navy
      : AppColors.creamBackground;

  Color get cardBackground => isMidnightCourt
      ? const Color(0xFF10283E)
      : AppColors.pureWhite;

  Color get glassBackground => isMidnightCourt
      ? const Color(0xD90A1B2C)
      : AppColors.glassFill;

  Color get glassWhite => isMidnightCourt
      ? const Color(0xB8132B42)
      : AppColors.glassWhite;

  Color get primaryText => isMidnightCourt
      ? const Color(0xFFFBF7EB) // Cream Text
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

  Color get accentOrange => const Color(0xFFF36B21); // Arcoffee Orange

  Color get desktopWallpaper => isMidnightCourt
      ? const Color(0xFF050E17)
      : const Color(0xFFEDE4D4);

  Color get titlebarBg => isMidnightCourt
      ? const Color(0xF20B1F33)
      : const Color(0xF2FBF7EB);

  List<BoxShadow> get glowingOrangeShadow => isMidnightCourt
      ? [
          BoxShadow(
            color: const Color(0xFFF36B21).withValues(alpha: 0.60),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFFF36B21).withValues(alpha: 0.25),
            blurRadius: 40,
            spreadRadius: 6,
          ),
        ]
      : [
          BoxShadow(
            color: const Color(0xFFF36B21).withValues(alpha: 0.35),
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
