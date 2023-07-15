import 'package:flutter/material.dart';

class FColor {
  static const MaterialColor isLightMaterialColor = MaterialColor(
    0xFF1d50d1,
    <int, Color>{
      50: Color(0xFFE1F5FE),
      100: Color(0xFFB3E5FC),
      200: Color(0xFF81D4FA),
      300: Color(0xFF4FC3F7),
      400: Color(0xFF29B6F6),
      500: Color(0xFF03A9F4),
      600: Color(0xFF039BE5),
      700: Color(0xFF0288D1),
      800: Color(0xFF0277BD),
      900: Color(0xFF01579B),
    },
  );

  static const MaterialColor isDarkMaterialColor = MaterialColor(
    0xFF0E1726,
    <int, Color>{
      50: Color(0xFF0E1726),
      100: Color(0xFF181C38),
      200: Color(0xFF222b50),
      300: Color(0xFF29345c),
      400: Color(0xFF313c67),
      500: Color(0xFF37436f),
      600: Color(0xFF525d81),
      700: Color(0xFF6f7895),
      800: Color(0xFF959db3),
      900: Color(0xFFe5e7ec),
    },
  );

  static Color red = const Color(0xFFFF0303);
  static Color green = const Color(0xFF69BF22);
  static Color amber = const Color(0xFFFFAB00);
  static Color transparent = const Color(0x00000000);

  static Color s050(bool isDark) => isDark ? isDarkMaterialColor.shade50 : isLightMaterialColor.shade50;
  static Color s100(bool isDark) => isDark ? isDarkMaterialColor.shade100 : isLightMaterialColor.shade100;
  static Color s200(bool isDark) => isDark ? isDarkMaterialColor.shade200 : isLightMaterialColor.shade200;
  static Color s300(bool isDark) => isDark ? isDarkMaterialColor.shade300 : isLightMaterialColor.shade300;
  static Color s400(bool isDark) => isDark ? isDarkMaterialColor.shade400 : isLightMaterialColor.shade400;
  static Color s500(bool isDark) => isDark ? isDarkMaterialColor.shade500 : isLightMaterialColor.shade500;
  static Color s600(bool isDark) => isDark ? isDarkMaterialColor.shade600 : isLightMaterialColor.shade600;
  static Color s700(bool isDark) => isDark ? isDarkMaterialColor.shade700 : isLightMaterialColor.shade700;
  static Color s800(bool isDark) => isDark ? isDarkMaterialColor.shade800 : isLightMaterialColor.shade800;
  static Color s900(bool isDark) => isDark ? isDarkMaterialColor.shade900 : isLightMaterialColor.shade900;
}
