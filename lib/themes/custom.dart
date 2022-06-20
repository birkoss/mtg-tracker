import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.amber,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.urbanist(
          color: Colors.black,
          fontSize: 18,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        /* Amount number */
        headline1: GoogleFonts.urbanist(
          fontSize: 45,
          letterSpacing: 1,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        /* Amount Changes (+1, -2) */
        headline2: GoogleFonts.urbanist(
          fontSize: 20,
          letterSpacing: 2,
          color: Colors.white70,
        ),
        headline3: GoogleFonts.urbanist(
          fontSize: 43,
          letterSpacing: 1,
          fontWeight: FontWeight.w400,
        ),
        headline4: GoogleFonts.urbanist(
          fontSize: 31,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        headline5: GoogleFonts.urbanist(
          fontSize: 22,
          letterSpacing: 1,
          fontWeight: FontWeight.w400,
        ),
        headline6: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        subtitle1: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        subtitle2: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        /* Settings title */
        bodyText1: GoogleFonts.urbanist(
          fontSize: 16,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: GoogleFonts.urbanist(
          fontSize: 15,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
        ),
        button: GoogleFonts.urbanist(
            fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        caption: GoogleFonts.urbanist(
            fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: GoogleFonts.urbanist(
            fontSize: 9, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.urbanist(
          fontSize: 18,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.urbanist(
          fontSize: 45,
          letterSpacing: 1,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headline2: GoogleFonts.urbanist(
          fontSize: 20,
          letterSpacing: 2,
          color: Colors.white70,
        ),
        headline3: GoogleFonts.urbanist(
          fontSize: 43,
          letterSpacing: 1,
          fontWeight: FontWeight.w400,
        ),
        headline4: GoogleFonts.urbanist(
          fontSize: 31,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        headline5: GoogleFonts.urbanist(
          fontSize: 22,
          letterSpacing: 1,
          fontWeight: FontWeight.w400,
        ),
        headline6: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        subtitle1: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        subtitle2: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        bodyText1: GoogleFonts.urbanist(
          fontSize: 16,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: GoogleFonts.urbanist(
          fontSize: 15,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
        ),
        button: GoogleFonts.urbanist(
            fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        caption: GoogleFonts.urbanist(
            fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: GoogleFonts.urbanist(
            fontSize: 9, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
    );
  }
}
