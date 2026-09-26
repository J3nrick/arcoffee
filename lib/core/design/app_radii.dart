import 'package:flutter/cupertino.dart';

/// Centralized Corner Radii System for Arcoffee.
/// Favors crisp architectural geometry over generic rounded blobs.
abstract class AppRadii {
  static const BorderRadius none = BorderRadius.zero;
  static const BorderRadius sm = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius md = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(24.0));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(99.0));
}
