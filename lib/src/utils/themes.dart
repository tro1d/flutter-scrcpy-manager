import 'dart:io';

import 'package:flutter/material.dart';

import 'colors.dart';

enum AppTheme { isDark, isLight }

ThemeData appTheme(AppTheme appTheme) {
  switch (appTheme) {
    case AppTheme.isLight:
      return ThemeData(
        fontFamily: 'Poppins',
        listTileTheme: ListTileThemeData(iconColor: FColor.isLightMaterialColor[900]),
        brightness: Brightness.light,
        primarySwatch: FColor.isLightMaterialColor,
        scaffoldBackgroundColor: FColor.isLightMaterialColor[50],
        dialogBackgroundColor: FColor.isLightMaterialColor[50],
        textTheme: _textThemeData(AppTheme.isLight),
        iconTheme: const IconThemeData(color: Colors.black87),
        elevatedButtonTheme: _elevatedButtonThemeData(AppTheme.isLight),
        outlinedButtonTheme: _outlinedButtonThemeDataa(AppTheme.isLight),
        inputDecorationTheme: _inputDecorationThemeData(AppTheme.isLight),
        dropdownMenuTheme: DropdownMenuThemeData(inputDecorationTheme: _inputDecorationThemeData(AppTheme.isLight)),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      );
    case AppTheme.isDark:
      return ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        primarySwatch: FColor.isDarkMaterialColor,
        scaffoldBackgroundColor: FColor.isDarkMaterialColor[50],
        dialogBackgroundColor: FColor.isDarkMaterialColor[50],
        textTheme: _textThemeData(AppTheme.isDark),
        iconTheme: IconThemeData(color: FColor.isLightMaterialColor[100]),
        elevatedButtonTheme: _elevatedButtonThemeData(AppTheme.isDark),
        outlinedButtonTheme: _outlinedButtonThemeDataa(AppTheme.isDark),
        inputDecorationTheme: _inputDecorationThemeData(AppTheme.isDark),
        textSelectionTheme: TextSelectionThemeData(selectionColor: FColor.isLightMaterialColor.shade600.withOpacity(0.5)),
        dropdownMenuTheme: DropdownMenuThemeData(inputDecorationTheme: _inputDecorationThemeData(AppTheme.isDark)),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      );
    default:
      return ThemeData();
  }
}

TextTheme _textThemeData(AppTheme appTheme) {
  switch (appTheme) {
    case AppTheme.isLight:
      return TextTheme(
        bodyLarge: const TextStyle(color: Colors.black87, fontSize: 16.0, letterSpacing: 0.5),
        bodySmall: const TextStyle(
          color: Colors.black87,
          fontSize: 12.0,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: FColor.isLightMaterialColor[600],
          fontSize: 16.0,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: FColor.isLightMaterialColor[600],
          fontSize: 14.0,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w600,
        ),
      );
    case AppTheme.isDark:
      return TextTheme(
        bodyLarge: const TextStyle(color: Colors.white70, fontSize: 16.0, letterSpacing: 0.5),
        bodySmall: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: FColor.isLightMaterialColor[600],
          fontSize: 16.0,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: FColor.isLightMaterialColor[600],
          fontSize: 14.0,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w600,
        ),
      );
    default:
      return const TextTheme();
  }
}

ElevatedButtonThemeData _elevatedButtonThemeData(AppTheme appTheme) {
  switch (appTheme) {
    case AppTheme.isLight:
      return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          foregroundColor: const Color(0xFFE1F5FE),
          side: BorderSide(color: FColor.isLightMaterialColor.shade900, strokeAlign: BorderSide.strokeAlignInside),
          padding: Platform.isWindows ? const EdgeInsets.symmetric(vertical: 10.0) : EdgeInsets.zero,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          visualDensity: VisualDensity.comfortable,
        ),
      );
    case AppTheme.isDark:
      return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          foregroundColor: const Color(0xFFE1F5FE),
          side: BorderSide(color: FColor.isLightMaterialColor.shade600, strokeAlign: BorderSide.strokeAlignInside),
          padding: Platform.isWindows ? const EdgeInsets.symmetric(vertical: 10.0) : EdgeInsets.zero,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          visualDensity: VisualDensity.comfortable,
        ),
      );
    default:
      return const ElevatedButtonThemeData();
  }
}

OutlinedButtonThemeData _outlinedButtonThemeDataa(AppTheme appTheme) {
  switch (appTheme) {
    case AppTheme.isLight:
      return OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: FColor.isLightMaterialColor.shade900, strokeAlign: BorderSide.strokeAlignInside),
          padding: Platform.isWindows ? const EdgeInsets.symmetric(vertical: 10.0) : EdgeInsets.zero,
          textStyle: _textThemeData(appTheme).titleMedium,
          visualDensity: VisualDensity.comfortable,
        ),
      );
    case AppTheme.isDark:
      return OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white70,
          side: BorderSide(color: FColor.isLightMaterialColor.shade600, strokeAlign: BorderSide.strokeAlignInside),
          padding: Platform.isWindows ? const EdgeInsets.symmetric(vertical: 10.0) : EdgeInsets.zero,
          textStyle: _textThemeData(appTheme).titleMedium,
          visualDensity: VisualDensity.comfortable,
        ),
      );
    default:
      return const OutlinedButtonThemeData();
  }
}

InputDecorationTheme _inputDecorationThemeData(AppTheme appTheme) {
  switch (appTheme) {
    case AppTheme.isLight:
      return InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 22.0, color: FColor.isDarkMaterialColor[200]),
      );
    case AppTheme.isDark:
      return InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 22.0, color: FColor.isLightMaterialColor[200]),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FColor.isLightMaterialColor.shade200)),
      );
    default:
      return const InputDecorationTheme();
  }
}
