import 'package:flutter/material.dart';

// 1. Core Application and Storage Keys (Your Original)
class AppConstants {
  static const String appName =
      'Pro Task Manager'; // Updated for better branding
  static const String appVersion = '1.0.0';
}

class StorageKeys {
  static const String todos = 'todos';
  static const String theme = 'theme';
  static const String isLoggedIn = 'isLoggedIn'; // Added for completeness
}

// 2. Design System Constants (New for Impressive UI)
class AppDesign {
  // --- Spacing and Radii ---
  static const double spacingExtraSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingExtraLarge = 32.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0; // Used for CardTheme
  static const double radiusLarge = 30.0; // Used for Pill-shaped elements

  // --- Animation Durations ---
  static const Duration durationShort = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(
    milliseconds: 300,
  ); // Standard transition time
  static const Duration durationLong = Duration(milliseconds: 500);

  // --- Box Shadows (for Card Elevation/Depth) ---
  static const List<BoxShadow> lightCardShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05), // Very subtle grey
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(
      color: Color.fromRGBO(
        0,
        0,
        0,
        0.4,
      ), // Higher opacity for visibility in dark mode
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
}
