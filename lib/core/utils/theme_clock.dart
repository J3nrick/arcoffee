/// Time-Aware Utility Engine for Arcoffee.
/// Intelligently tracks the user's current local time, day of the week,
/// and court operating schedules (especially the 24-hour non-stop weekend sessions).
class ThemeClock {
  /// Evaluates whether the "Night Court" nocturnal aesthetic should be active.
  /// Automatically triggers if the user visits on Friday, Saturday, or Sunday
  /// during evening/late-night hours (e.g., 6:00 PM to 4:00 AM).
  static bool isNightCourtActive({DateTime? now}) {
    final current = now ?? DateTime.now();
    final weekday = current.weekday; // 1 = Mon, ..., 5 = Fri, 6 = Sat, 7 = Sun
    final hour = current.hour; // 0 - 23

    // Evening / Late-night hours: 6:00 PM (18:00) through 4:00 AM (03:59)
    final bool isEveningOrLateNight = hour >= 18 || hour < 4;

    // Friday evening starting at 6:00 PM
    if (weekday == DateTime.friday && hour >= 18) {
      return true;
    }

    // Saturday late-night (00:00 - 04:00) or Saturday evening (18:00 - 23:59)
    if (weekday == DateTime.saturday && isEveningOrLateNight) {
      return true;
    }

    // Sunday late-night (00:00 - 04:00) or Sunday evening (18:00 - 23:59)
    if (weekday == DateTime.sunday && isEveningOrLateNight) {
      return true;
    }

    // Monday early morning (00:00 - 04:00) — continuation of Sunday 24H overnight rally
    if (weekday == DateTime.monday && hour < 4) {
      return true;
    }

    // Weekday nocturnal fallback: Mon-Thu past 7:00 PM (19:00 - 04:00)
    if (hour >= 19 || hour < 4) {
      return true;
    }

    return false;
  }

  /// Determines if Arcoffee is currently in its 24-Hour Non-Stop Weekend session.
  /// Active continuously from Friday 2:00 PM through Monday morning.
  static bool is24HourWeekendSession({DateTime? now}) {
    final current = now ?? DateTime.now();
    final weekday = current.weekday;
    final hour = current.hour;

    if (weekday == DateTime.friday && hour >= 14) return true;
    if (weekday == DateTime.saturday) return true;
    if (weekday == DateTime.sunday) return true;
    if (weekday == DateTime.monday && hour < 4) return true;

    return false;
  }

  /// Editorial scoreboard status label for live court operational display.
  static String getOperatingStatusBadge({DateTime? now}) {
    if (isNightCourtActive(now: now)) {
      return "NIGHT COURT ACTIVE • 24H NON-STOP";
    } else if (is24HourWeekendSession(now: now)) {
      return "DAY COURT • 24H NON-STOP WEEKEND";
    } else {
      return "DAY COURT • ACTIVE SESSION";
    }
  }

  /// Returns descriptive session detail.
  static String getSessionHoursDescription({DateTime? now}) {
    final current = now ?? DateTime.now();
    final weekday = current.weekday;

    if (weekday == DateTime.friday ||
        weekday == DateTime.saturday ||
        weekday == DateTime.sunday) {
      return "Fri–Sun: 24 Hours Non-Stop Court & Bar Service";
    } else {
      return "Mon–Thu: 2:00 PM – 10:00 PM Active Sessions";
    }
  }
}
