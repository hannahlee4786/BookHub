import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define reusable colors
class AppColors {
  static const butterscotch         = Color(0xFFFCEACA);
  static const strawberryMilkshake  = Color(0xFFFBD9CD);
  static const mintGlow             = Color(0xFFD4DCD1);
  static const goldenGoose          = Color(0xFFF1BC52);
  static const brownMoss            = Color(0xFF543618);

  static const background   = butterscotch;
  static const surface      = strawberryMilkshake;
  static const accent       = goldenGoose;
  static const primary      = brownMoss;
  static const onPrimary    = butterscotch;
  static const onBackground = brownMoss;
  static const divider      = Color(0xFFE8C9B8);
}

// Creates the app-wide Flutter theme applied once initialized in main.dart
ThemeData buildAppTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    colorScheme: ColorScheme.light(
      primary:                 AppColors.primary,
      onPrimary:               AppColors.onPrimary,
      secondary:               AppColors.goldenGoose,
      onSecondary:             AppColors.brownMoss,
      surface:                 AppColors.surface,
      onSurface:               AppColors.brownMoss,
      surfaceContainerHighest: AppColors.mintGlow,
      outline:                 AppColors.divider,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: AppColors.onPrimary, fontSize: 22, fontWeight: FontWeight.w700),
    ),
    textTheme: GoogleFonts.latoTextTheme(base.textTheme).copyWith(
      displayLarge:  GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.brownMoss),
      displayMedium: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.brownMoss),
      titleLarge:    GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.brownMoss),
      titleMedium:   GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.brownMoss),
      bodyLarge:     GoogleFonts.lato(fontSize: 15, color: AppColors.brownMoss),
      bodyMedium:    GoogleFonts.lato(fontSize: 14, color: AppColors.brownMoss),
      bodySmall:     GoogleFonts.lato(fontSize: 12, color: Color.fromRGBO(84, 54, 24, 0.7)),
      labelLarge:    GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.onPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color.fromRGBO(255, 255, 255, 0.6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.goldenGoose, width: 2),
      ),
      hintStyle: GoogleFonts.lato(color: Color.fromRGBO(84, 54, 24, 0.45)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.mintGlow,
      labelStyle: GoogleFonts.lato(fontSize: 12, color: AppColors.brownMoss),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    cardTheme: CardThemeData(
      color: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 2,
      shadowColor: Color.fromRGBO(84, 54, 24, 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    dividerColor: AppColors.divider,
    iconTheme: const IconThemeData(color: AppColors.brownMoss),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.goldenGoose),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.brownMoss,
      contentTextStyle: GoogleFonts.lato(color: AppColors.butterscotch),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
