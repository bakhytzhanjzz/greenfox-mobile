import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Brand colors extracted from logo
  static const primary = Color(0xFF7BC74D); // Light green from logo
  static const primaryDark = Color(0xFF1B4D3E); // Dark forest green from logo
  static const primaryLight = Color(0xFF9FD77F); // Lighter accent
  static const accent = Color(0xFFE8F5D8); // Cream/light green from background

  // Neutrals - sophisticated palette
  static const background = Color(0xFFFAFBF8); // Off-white with green tint
  static const surface = Colors.white;
  static const surfaceVariant = Color(0xFFF4F6F3); // Very subtle green tint
  static const surfaceDark = Color(0xFF2D5446); // Dark green for cards

  // Text
  static const textPrimary = Color(0xFF1A2E25); // Very dark green
  static const textSecondary = Color(0xFF5A6F63); // Medium green-gray
  static const textTertiary = Color(0xFF9BA89F); // Light green-gray
  static const textOnDark = Color(0xFFFFFFFF); // White for dark backgrounds
  static const textOnPrimary = Color(0xFFFFFFFF); // White on green

  // Semantic colors
  static const success = Color(0xFF6BBF59);
  static const error = Color(0xFFE25C5C);
  static const warning = Color(0xFFF2B963);
  static const info = Color(0xFF5BA4CF);

  // Gradient colors
  static const gradientStart = Color(0xFF7BC74D);
  static const gradientMiddle = Color(0xFF5CAA3D);
  static const gradientEnd = Color(0xFF3D8B2E);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.primaryDark,
      secondaryContainer: AppColors.surfaceDark,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnDark,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
    ),

    scaffoldBackgroundColor: AppColors.background,

    // AppBar theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
    ),

    // Text theme with modern typography
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -1,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
    ),


    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE1E6E3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE1E6E3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: const TextStyle(color: AppColors.textTertiary),
    ),

    // Filled button theme
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primary.withOpacity(0.15),
      labelStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        color: AppColors.textOnPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Bottom nav bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE8EBE9),
      thickness: 1,
      space: 1,
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: 24,
    ),
  );
}

// Helper extension for gradient backgrounds
extension GradientExtension on BuildContext {
  Decoration get primaryGradient => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.gradientStart,
        AppColors.gradientMiddle,
        AppColors.gradientEnd,
      ],
    ),
  );

  Decoration get subtleGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.background,
        AppColors.surfaceVariant,
      ],
    ),
  );
}