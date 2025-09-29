import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Start with system preference

  ThemeMode get themeMode => _themeMode;

  // Uses system theme preference as the default
  ThemeData get currentTheme {
    if (_themeMode == ThemeMode.system) {
      // Logic to determine system theme if needed, but Flutter handles this
      return _lightTheme; // Fallback or handle external logic
    }
    return _themeMode == ThemeMode.dark ? _darkTheme : _lightTheme;
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // --- Theme Definitions for Impressive UI ---

  // 1. Light Theme: Clean, Soft, and Accessible
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Primary Color: A vibrant but slightly muted Blue
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E88E5), // A sophisticated Blue (Indigo-ish)
      brightness: Brightness.light,
      primary: const Color(0xFF1E88E5), // Primary blue
      secondary: const Color(
        0xFF00BFA5,
      ), // Teal/Accent for floating action buttons
      surface: Colors.white, // Pure white surfaces
      background: const Color(
        0xFFF5F5F5,
      ), // Off-white/light-grey background for depth
    ),

    // Typography: A bit bolder for headings
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(color: Colors.black87),
    ),

    // Component Styles: Rounded and Subtle Shadows
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.5,
      foregroundColor: Colors.black,
    ),

    // Input fields (for your Login/Add Todo screens)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFE0E0E0), // Light grey fill
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none, // No border, use fill for definition
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Color(0xFF1E88E5),
          width: 2,
        ), // Blue focus border
      ),
    ),
  );

  // 2. Dark Theme: Deep, High-Contrast, and Luxurious
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Primary Color: Same seed, but using deep colors for contrast
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E88E5),
      brightness: Brightness.dark,
      primary: const Color(0xFF42A5F5), // Lighter blue for dark surfaces
      secondary: const Color(
        0xFF00E676,
      ), // Brighter green for contrast (e.g., FAB)
      surface: const Color(
        0xFF121212,
      ), // Very deep black for surfaces (OLED friendly)
      background: const Color(0xFF0A0A0A), // Even deeper black for background
      onSurface: Colors.white70,
    ),

    // Typography: Maintain readability
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(color: Colors.white70),
    ),

    // Component Styles: Highly visible against dark background
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E), // Slightly lighter surface for cards
      elevation: 8, // Higher elevation for perceived depth
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 4.0, // Floating effect
      foregroundColor: Colors.white,
    ),

    // Input fields for dark mode
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C), // Darker grey fill
      hintStyle: const TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 2),
      ),
    ),
  );
}
