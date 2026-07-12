import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized app theming.
///
/// Fix: the previous version referenced `fontFamily: 'Vazir'` everywhere,
/// but no font asset was ever bundled (it was commented out in pubspec.yaml
/// and the .ttf files didn't exist in the repo). Flutter silently falls back
/// to the platform default font in that case, so all the Persian text was
/// rendering in the wrong typeface. We now use google_fonts with Vazirmatn,
/// a proper open-source Persian/Arabic/Latin font, applied via a TextTheme
/// so there's a single source of truth instead of repeating fontFamily on
/// every single TextStyle.
class AppTheme {
  static TextTheme _textTheme(Color primaryText, Color secondaryText, Color tertiaryText) {
    final base = GoogleFonts.vazirmatnTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w800, color: primaryText),
      displayMedium: base.displayMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.w800, color: primaryText),
      displaySmall: base.displaySmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: primaryText),
      headlineLarge: base.headlineLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w700, color: primaryText),
      headlineMedium: base.headlineMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: primaryText),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: primaryText),
      titleLarge: base.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: primaryText),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: primaryText),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: secondaryText),
      bodySmall: base.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: tertiaryText),
      labelLarge: base.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: primaryText),
    );
  }

  static ThemeData lightTheme() {
    final textTheme = _textTheme(
      AppColors.textPrimaryLight,
      AppColors.textSecondaryLight,
      AppColors.textTertiaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      splashFactory: InkSparkle.splashFactory,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        titleTextStyle: textTheme.headlineMedium,
      ),

      // Cards get a soft tinted shadow instead of a flat grey one
      cardTheme: CardThemeData(
        elevation: 3,
        color: AppColors.cardLight,
        shadowColor: AppColors.primary.withOpacity(0.15),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
      ),

      iconTheme: const IconThemeData(color: AppColors.textPrimaryLight, size: 24),

      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primary.withOpacity(0.08),
        selectedColor: AppColors.primary,
        labelStyle: textTheme.bodyMedium!,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.textPrimaryLight,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData darkTheme() {
    final textTheme = _textTheme(
      AppColors.textPrimaryDark,
      AppColors.textSecondaryDark,
      AppColors.textTertiaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      splashFactory: InkSparkle.splashFactory,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        tertiary: AppColors.accentLight,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: AppColors.backgroundDark,
        onSecondary: AppColors.backgroundDark,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: textTheme,

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: textTheme.headlineMedium,
      ),

      cardTheme: CardThemeData(
        elevation: 3,
        color: AppColors.cardDark,
        shadowColor: Colors.black.withOpacity(0.4),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primaryLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
      ),

      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark, size: 24),

      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryLight.withOpacity(0.12),
        selectedColor: AppColors.primaryLight,
        labelStyle: textTheme.bodyMedium!,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.surfaceDark,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimaryDark),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
