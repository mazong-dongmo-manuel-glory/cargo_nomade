import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Color(0xFF0D5159), // Turquoise
  scaffoldBackgroundColor: Colors.transparent,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF0D5159), // Turquoise
    secondary: Color(0xFF0D5159), // Vert vif
    background: Colors.transparent,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.black87,
    error: Colors.red,
    onError: Colors.white,
  ),

  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.roboto(fontSize: 16, color: Colors.white70),
    bodyMedium: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
    bodySmall: GoogleFonts.roboto(fontSize: 12, color: Colors.white54),
    titleSmall: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.greenAccent,
    elevation: 0,
    shadowColor: Colors.greenAccent,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: const BorderSide(color: Color(0xFF20B2AA), width: 2),
    ),
    hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
    labelStyle: GoogleFonts.poppins(color: Colors.grey[800]),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00C853),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white.withOpacity(0.9),
      textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.white, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: const Color(0xFF20B2AA),
    unselectedItemColor: Colors.grey[600],
    selectedLabelStyle: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    margin: const EdgeInsets.all(12.0),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF00C853),
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  ),
);
