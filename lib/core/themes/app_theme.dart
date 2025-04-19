import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPalette.borderColor]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 3),
        borderRadius: BorderRadius.circular(10),
      );
  static final lightThemeMode = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: AppPalette.textColor,
      fontFamily: 'ProductSans',
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: AppPalette.hintTextColor),
      contentPadding: EdgeInsets.all(16),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(AppPalette.errorColor),
      focusedErrorBorder: _border(AppPalette.errorColor),
    ),
  );
}

