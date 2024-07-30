// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `CST2335 Final Project`
  String get appTitle {
    return Intl.message(
      'CST2335 Final Project',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Customers Page`
  String get customersPage {
    return Intl.message(
      'Customers Page',
      name: 'customersPage',
      desc: '',
      args: [],
    );
  }

  /// `Flights Page`
  String get flightsPage {
    return Intl.message(
      'Flights Page',
      name: 'flightsPage',
      desc: '',
      args: [],
    );
  }

  /// `Reservations Page`
  String get reservationsPage {
    return Intl.message(
      'Reservations Page',
      name: 'reservationsPage',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this?`
  String get confirmDeletion {
    return Intl.message(
      'Are you sure you want to delete this?',
      name: 'confirmDeletion',
      desc: '',
      args: [],
    );
  }

  /// `हिंदी में स्विच करें`
  String get switchToHindi {
    return Intl.message(
      'हिंदी में स्विच करें',
      name: 'switchToHindi',
      desc: '',
      args: [],
    );
  }

  /// `अंग्रेजी में स्विच करें`
  String get switchToEnglish {
    return Intl.message(
      'अंग्रेजी में स्विच करें',
      name: 'switchToEnglish',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'hi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
