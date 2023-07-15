import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeStateNotifier, ThemeMode>((ref) => ThemeStateNotifier());

class ThemeStateNotifier extends StateNotifier<ThemeMode> {
  ThemeStateNotifier() : super(ThemeMode.light) {
    _initThemeMode();
  }

  Future<void> _initThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool('isDark') ?? false;
    isDark ? state = ThemeMode.dark : state = ThemeMode.light;
  }

  Future<void> isDark() async {
    state = ThemeMode.dark;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', true);
  }

  Future<void> isLight() async {
    state = ThemeMode.light;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', false);
  }

  Future<void> toggleTheme() async {
    final ThemeMode newThemeMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', newThemeMode == ThemeMode.dark);
    state = newThemeMode;
  }
}
