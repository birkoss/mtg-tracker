import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.blueGrey,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.blueGrey,
        backgroundColor: Colors.blueGrey.shade50,
        brightness: Brightness.light,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueGrey,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.blueGrey),
        trackColor: WidgetStateProperty.all(Colors.blueGrey.shade200),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.blueGrey,
        selectionColor: Colors.blueGrey.shade200,
        selectionHandleColor: Colors.blueGrey,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.urbanist(
          fontSize: 18,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        /* Amount number */
        /* headline1 */
        displayLarge: GoogleFonts.urbanist(
          fontSize: 45,
          letterSpacing: 1,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        /* Amount Changes (+1, -2) */
        /* headline2 */
        displayMedium: GoogleFonts.urbanist(
          fontSize: 20,
          letterSpacing: 2,
          color: Colors.white70,
        ),
        /* headline3 */
        displaySmall: GoogleFonts.urbanist(
          fontSize: 43,
          letterSpacing: 1,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: GoogleFonts.urbanist(
          fontSize: 31,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        headlineSmall: GoogleFonts.urbanist(
          fontSize: 22,
          letterSpacing: 1,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        titleMedium: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        titleSmall: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        /* Settings title */
        /* bodyText1 */
        bodyLarge: GoogleFonts.urbanist(
          fontSize: 16,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: GoogleFonts.urbanist(
          fontSize: 15,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
        ),
        labelLarge: GoogleFonts.urbanist(
            fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        bodySmall: GoogleFonts.urbanist(
            fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        labelSmall: GoogleFonts.urbanist(
            fontSize: 9, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.blueGrey,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.blueGrey,
        backgroundColor: Colors.blueGrey.shade900,
        brightness: Brightness.dark,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueGrey,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.blueGrey),
        trackColor: WidgetStateProperty.all(Colors.blueGrey.shade700),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.blueGrey,
        selectionColor: Colors.blueGrey.shade700,
        selectionHandleColor: Colors.blueGrey,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.urbanist(
          fontSize: 18,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.urbanist(
          fontSize: 45,
          letterSpacing: 1,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.urbanist(
          fontSize: 20,
          letterSpacing: 2,
          color: Colors.white70,
        ),
        displaySmall: GoogleFonts.urbanist(
          fontSize: 43,
          letterSpacing: 1,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: GoogleFonts.urbanist(
          fontSize: 31,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        headlineSmall: GoogleFonts.urbanist(
          fontSize: 22,
          letterSpacing: 1,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        titleMedium: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        titleSmall: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        bodyLarge: GoogleFonts.urbanist(
          fontSize: 16,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: GoogleFonts.urbanist(
          fontSize: 15,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
        ),
        labelLarge: GoogleFonts.urbanist(
            fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        bodySmall: GoogleFonts.urbanist(
            fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        labelSmall: GoogleFonts.urbanist(
            fontSize: 9, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
    );
  }
}
