import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        background: AppColors.background,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        tertiary: AppColors.tertiary,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.manropeTextTheme(
        ThemeData.dark().textTheme.copyWith(
          headlineLarge: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.02,
            color: AppColors.onSurface,
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          bodyLarge: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: AppColors.onSurface,
          ),
          bodyMedium: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.onSurfaceVariant,
          ),
          labelLarge: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
          labelSmall: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
