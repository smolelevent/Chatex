import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LocaleProvider with ChangeNotifier {

  LocaleProvider(this._locale);

  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale newLocale) {
    // Ellenőrizzük, hogy a kiválasztott nyelv támogatott-e.
    if (!AppLocalizations.supportedLocales.contains(newLocale)) {
      return;
    }
    // Csak akkor értesítjük a UI-t, ha tényleg változott a nyelv.
    if (_locale == newLocale) return;

    _locale = newLocale;
    // Értesítjük a UI-t, hogy változás történt, és újra kell épülnie.
    notifyListeners();
  }
}
