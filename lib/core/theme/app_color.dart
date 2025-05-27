import 'package:flutter/material.dart';

/// This [AppColor] defines a set of colors used throughout the app.
/// A utility class that defines the color palette used throughout the application.
/// Each color is represented as a static constant with a descriptive name.
class AppColor {
  /// Pure white color (#FFFFFF).
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black color (#000000).
  static const Color black = Color(0xFF000000);

  /// Dark slate blue
  static const Color darkSlateBlue = Color(0xff484E62);

  static const Color grayChat = Color(0xFF858585);

  static const Color grey = Color(0xFF6D6D6D);

  static const Color grayHintText = Color(0xFF858585);

  ///
  static const Color purplecustomColor = Color(0xFF1E2A44);

  ///
  static const Color orangecustomColor = Color(0xFFFF7618);

  /// Light gray color (#A4A4A4).
  static const Color customsLightGray = Color(0xFFA4A4A4);

  /// Light cyan color (#E5F2F2).
  static const Color lightCyan = Color(0xFFE5F2F2);

  ///Light peach
  static const Color lightPeach = Color(0xFFFFE5DE);

  /// Deep navy blue color (#192C83).
  static const Color navyBlue = Color(0xFF192C83);

  /// Dark gray color (#202224).
  static const Color darkGray = Color(0xFF202224);

  /// Light gray
  static const Color lightGrayText = Color(0xFFF2F2F2);

  static const Color customOffWhite = Color(0xFFEDEEF1);

  /// Light gray color (#EDEEF1).
  static const Color customLightGray = Color(0xFFEDEEF1);

  /// Bright teal color (#21E5B5).
  static const Color teal = Color(0xFF21E5B5);

  ///
  static const Color purple = Color(0xFF800080);

  ///
  static const Color darkBlue = Color(0xFF132241);

  /// Vibrant emerald green color (#06E3A1).
  static const Color emerald = Color(0xFF06E3A1);

  /// Charcoal gray color (#1B2431).
  static const Color charcoal = Color(0xFF1B2431);

  static const Color green = Color(0xFF5FB765);

  /// Medium gray color (#757575).
  static const Color mediumGray = Color(0xFF757575);

  /// Light gray color (#E4E4E4).
  static const Color lightGray = Color(0xFFE4E4E4);

  /// Very light gray color (#F5F6FA).
  static const Color veryLightGray = Color(0xFFF5F6FA);

  /// Bright red color (#EF3826).
  static const Color red = Color(0xFFEF3826);

  /// Cool gray color (#979797).
  static const Color coolGray = Color(0xFF979797);

  /// Silver gray color (#B1B1B1).
  static const Color silver = Color(0xFFB1B1B1);

  /// Pale gray color (#D5D5D5).
  static const Color paleGray = Color(0xFFD5D5D5);

  /// Off-white color (#FAFBFD).
  static const Color offWhite = Color(0xFFFAFBFD);

  /// Soft white color (#F9F9FB).
  static const Color softWhite = Color(0xFFF9F9FB);

  /// Bright pink color (#F93C65).
  static const Color pink = Color(0xFFF93C65);

  /// Slate blue-gray color (#313D4F).
  static const Color slate = Color(0xFF313D4F);

  /// Dark slate gray color (#565656).
  static const Color darkSlate = Color(0xFF565656);

  /// Muted gray color (#404040).
  static const Color mutedGray = Color(0xFF404040);

  /// Very pale gray color (#E0E0E0).
  static const Color veryPaleGray = Color(0xFFE0E0E0);

  /// Bright blue color (#4880FF).
  static const Color blue = Color(0xFF4880FF);

  /// Light beige color (#E7E0DB).
  static const Color lightBeige = Color(0xFFE7E0DB);

  /// Vibrant yellow color (#F1E235).
  static const Color vibrantYellow = Color(0xFFF1E235);

  /// Darker gray color (#6D6D6D).
  static const Color darkerGray = Color(0xFF6D6D6D);

  /// Royal blue color (#4379EE).
  static const Color royalBlue = Color(0xFF4379EE);

  /// Bright yellow color (#FEC53D).
  static const Color yellow = Color(0xFFFEC53D);

  ///
  static const Color appbarBackground = Color(0xFFFCF3ED);

  /// Graphite gray color (#5C5C5C).
  static const Color graphite = Color(0xFF5C5C5C);

  /// Faint gray color (#F3F3F5).
  static const Color faintGray = Color(0xFFF3F3F5);

  /// Subtle gray color (#D9D9D9).
  static const Color subtleGray = Color(0xFFD9D9D9);

  /// Mid-tone gray color (#B5B5B5).
  static const Color midGray = Color(0xFFB5B5B5);

  /// Near-black color (#191919).
  static const Color nearBlack = Color(0xFF191919);

  /// Peach orange color (#FF9066).
  static const Color peach = Color(0xFFFF9066);

  /// Dark navy color (#313649).
  static const Color darkNavy = Color(0xFF313649);

  /// silver gray
  static const Color silverGray = Color(0xFFBABCBF);

  /// Deep blue color (#132241).
  static const Color deepBlue = Color(0xFF132241);

  static const Color darkGrayText = Color(0xFF575757);

  static const LinearGradient defaultGradient = LinearGradient(
    colors: [
      Color(0xFFFCF3ED), // #FCF3ED
      Color(0xFFEFEFF0), // #EFEFF0
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient splashGradient = LinearGradient(
    colors: [
      Color(0xFF313649), // #313649
      Color(0xFF162442), // #132241
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Gradient from dark navy (#313649) to deep blue (#132241).
  static const LinearGradient navyGradient = LinearGradient(
    colors: [
      darkNavy, // #313649
      deepBlue, // #132241
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColor.white,
    secondary: AppColor.white,
  ),
  scaffoldBackgroundColor: const Color(
    0xFFFCF3ED,
  ), // Fallback to one gradient color
  drawerTheme: const DrawerThemeData(backgroundColor: AppColor.white),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'HelveticaNeue',
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontFamily: 'HelveticaNeue',
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'HelveticaNeue',
      fontWeight: FontWeight.w300,
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColor.blue,
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColor.black,
    secondary: AppColor.black,
  ),
  scaffoldBackgroundColor: const Color(
    0xFFEFEFF0,
  ), // Fallback to one gradient color
  drawerTheme: const DrawerThemeData(backgroundColor: AppColor.black),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'HelveticaNeue',
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontFamily: 'HelveticaNeue',
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'HelveticaNeue',
      fontWeight: FontWeight.w300,
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColor.blue,
  ),
);
