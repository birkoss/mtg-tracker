import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static Color accent = const Color.fromRGBO(
    91,
    162,
    224,
    1,
  );

  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: CustomTheme.accent,
    primary: Colors.white,
    side: BorderSide(color: CustomTheme.accent, width: 1),
    padding: const EdgeInsets.all(10),
  );

  static ButtonStyle toggleOnButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    primary: CustomTheme.accent,
    side: BorderSide(color: CustomTheme.accent, width: 1),
    padding: const EdgeInsets.all(10),
    textStyle: GoogleFonts.urbanist(
      fontSize: 16,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
    ),
  );

  static ButtonStyle toggleOffButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: Colors.white70,
    primary: CustomTheme.accent,
    side: BorderSide(color: CustomTheme.accent.withOpacity(0.2), width: 1),
    padding: const EdgeInsets.all(10),
    textStyle: GoogleFonts.urbanist(
      fontSize: 16,
      letterSpacing: 1,
      fontWeight: FontWeight.normal,
    ),
  );

  static TextStyle settingTitle = GoogleFonts.urbanist(
    fontSize: 16,
    letterSpacing: 1,
    fontWeight: FontWeight.bold,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: const MaterialColor(
        4284195552,
        <int, Color>{
          50: Color.fromRGBO(
            91,
            162,
            224,
            .1,
          ),
          100: Color.fromRGBO(
            91,
            162,
            224,
            .2,
          ),
          200: Color.fromRGBO(
            91,
            162,
            224,
            .3,
          ),
          300: Color.fromRGBO(
            91,
            162,
            224,
            .4,
          ),
          400: Color.fromRGBO(
            91,
            162,
            224,
            .5,
          ),
          500: Color.fromRGBO(
            91,
            162,
            224,
            .6,
          ),
          600: Color.fromRGBO(
            91,
            162,
            224,
            .7,
          ),
          700: Color.fromRGBO(
            91,
            162,
            224,
            .8,
          ),
          800: Color.fromRGBO(
            91,
            162,
            224,
            .9,
          ),
          900: Color.fromRGBO(
            91,
            162,
            224,
            1,
          ),
        },
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: GoogleFonts.urbanist(
          color: Colors.black87,
          fontSize: 18,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.urbanist(
          fontSize: 30,
          letterSpacing: 1,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headline2: GoogleFonts.urbanist(
          fontSize: 14,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
          fontSize: 15,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
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
      primarySwatch: const MaterialColor(
        4284195552,
        <int, Color>{
          50: Color.fromRGBO(
            91,
            162,
            224,
            .1,
          ),
          100: Color.fromRGBO(
            91,
            162,
            224,
            .2,
          ),
          200: Color.fromRGBO(
            91,
            162,
            224,
            .3,
          ),
          300: Color.fromRGBO(
            91,
            162,
            224,
            .4,
          ),
          400: Color.fromRGBO(
            91,
            162,
            224,
            .5,
          ),
          500: Color.fromRGBO(
            91,
            162,
            224,
            .6,
          ),
          600: Color.fromRGBO(
            91,
            162,
            224,
            .7,
          ),
          700: Color.fromRGBO(
            91,
            162,
            224,
            .8,
          ),
          800: Color.fromRGBO(
            91,
            162,
            224,
            .9,
          ),
          900: Color.fromRGBO(
            91,
            162,
            224,
            1,
          ),
        },
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.urbanist(
          color: Colors.black87,
          fontSize: 18,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.urbanist(
          fontSize: 30,
          letterSpacing: 1,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headline2: GoogleFonts.urbanist(
          fontSize: 14,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
          fontSize: 15,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
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
