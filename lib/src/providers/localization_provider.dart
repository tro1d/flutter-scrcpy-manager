import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/localization.dart';
import 'scrcpy_provider.dart';
import 'tray_manager_provider.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier(ref));

final localizationProvider = Provider((ref) {
  final locale = ref.watch(localeProvider);
  return Localization.of(locale);
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this.ref) : super(_setlocalization('en')) {
    _initLocale();
  }

  final Ref ref;

  static Locale _setlocalization(String localization) => Locale(localization);

  Future<Locale> _initLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lang = prefs.getString('language') ?? '';
    if (lang.isEmpty) {
      return state = _setlocalization('en');
    } else {
      return state = _setlocalization(lang);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', state.languageCode);
    ref.read(trayManagerProvider.notifier).initialized();
    ref.read(adbDevicesProvider.notifier).initialized();
  }
}
