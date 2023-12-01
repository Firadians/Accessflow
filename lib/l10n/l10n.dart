import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui'; // Import this for Locale.

class AppLocalizations {
  AppLocalizations(this.localeName);

  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get title {
    return Intl.message('Hello World', name: 'title', locale: localeName);
  }

  String get welcome {
    return Intl.message('Welcome to the Flutter app!',
        name: 'welcome', locale: localeName);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale.languageCode));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    return false;
  }
}
