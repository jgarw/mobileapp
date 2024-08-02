import 'package:flutter/material.dart';

/// A provider for managing and notifying changes to the application's locale.
///
/// The [LocaleProvider] uses [ChangeNotifier] to provide a way to manage
/// the application's locale and notify listeners about changes. It holds
/// the current locale and allows updating it, which will then notify all
/// listeners of the change.
  class LocaleProvider with ChangeNotifier {

    /// The current locale of the application.
    ///
    /// This property holds the current [Locale] used in the application.
    /// It defaults to English ('en') if not set.
    Locale _locale = const Locale('en', '');

    /// Gets the current locale.
    ///
    /// Returns the current [Locale] being used by the application.
    Locale get locale => _locale;

    /// Sets a new locale and notifies listeners if the locale has changed.
    ///
    /// This method updates the current locale with the provided [locale] if
    /// it is different from the current locale. After updating the locale,
    /// it calls [notifyListeners] to inform all listeners about the change.
    ///
    /// [locale] The new [Locale] to be set.
    void setLocale(Locale locale) {
      if (locale != _locale) {
        _locale = locale;

    notifyListeners();
      }
    }}

