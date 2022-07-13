import 'package:flutter/material.dart';
import 'package:movie_recommendation_app/theme/pallette.dart';

class CustomTheme {
  static ThemeData darkTheme(BuildContext context) {
    final theme = Theme.of(context);
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          Palette.red500.value,
          {
            50: Color(Palette.red100.value),
            100: Color(Palette.red200.value),
            200: Color(Palette.red300.value),
            300: Color(Palette.red400.value),
            400: Color(Palette.red500.value),
            500: Color(Palette.red500.value),
            600: Color(Palette.red600.value),
            700: Color(Palette.red700.value),
            800: Color(Palette.red800.value),
            900: Color(Palette.red900.value),
          },
        ),
      ).copyWith(
        secondary: Color(Palette.red500.value),
      ),
      sliderTheme: SliderThemeData(
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade800,
          thumbColor: Colors.white,
          valueIndicatorColor: Palette.red500,
          inactiveTickMarkColor: Colors.transparent,
          activeTickMarkColor: Colors.transparent),
      scaffoldBackgroundColor: Palette.almostBlack,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Palette.almostBlack,
      ),
      textTheme: theme.primaryTextTheme
          .copyWith(
              button: theme.primaryTextTheme.button?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ))
          .apply(
            displayColor: Colors.white,
          ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(backgroundColor: Palette.red500)),
    );
  }
}
