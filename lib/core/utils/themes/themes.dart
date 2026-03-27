import 'package:flutter/material.dart';
import 'package:turing_registration/core/utils/constants/constants.dart';

abstract class AppTheme {
  static TextTheme _textTheme(Color textColor, Color secondaryTextColor) =>
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textColor,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: secondaryTextColor,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: secondaryTextColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      );

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kBgColor,
    primaryColor: kPrimaryColor,
    colorScheme: const ColorScheme.dark(
      primary: kPrimaryColor,
      secondary: kPrimaryLight,
      surface: kSurfaceColor,
      onSurface: kTextColor,
      error: kErrorColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: kTextColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: kTextColor),
    ),
    cardTheme: CardThemeData(
      color: kCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kDividerColor),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: kTextColor,
      selectionColor: kTextColor.withOpacity(0.2),
      selectionHandleColor: kTextColor,
    ),
    textTheme: _textTheme(kTextColor, kSecondaryTextColor),
    fontFamily: "Outfit",
    dividerTheme: const DividerThemeData(color: kDividerColor, thickness: 1),
  );
}
