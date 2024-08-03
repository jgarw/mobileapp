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

  /// `Customer Management`
  String get customerManagement {
    return Intl.message(
      'Customer Management',
      name: 'customerManagement',
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

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth (YYYY-MM-DD)`
  String get birthday {
    return Intl.message(
      'Date of Birth (YYYY-MM-DD)',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all the fields`
  String get pleaseFillAllFields {
    return Intl.message(
      'Please fill all the fields',
      name: 'pleaseFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Database not Initialized`
  String get databaseNotInitialized {
    return Intl.message(
      'Database not Initialized',
      name: 'databaseNotInitialized',
      desc: '',
      args: [],
    );
  }

  /// `Customer Details saved for the next time`
  String get savedForNextTime {
    return Intl.message(
      'Customer Details saved for the next time',
      name: 'savedForNextTime',
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

  /// `Save Details`
  String get saveDetails {
    return Intl.message(
      'Save Details',
      name: 'saveDetails',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to save for the next time?`
  String get saveForNextTime {
    return Intl.message(
      'Do you want to save for the next time?',
      name: 'saveForNextTime',
      desc: '',
      args: [],
    );
  }

  /// `Customer Added`
  String get customerAdded {
    return Intl.message(
      'Customer Added',
      name: 'customerAdded',
      desc: '',
      args: [],
    );
  }

  /// `No Customers Found`
  String get noCustomerFound {
    return Intl.message(
      'No Customers Found',
      name: 'noCustomerFound',
      desc: '',
      args: [],
    );
  }

  /// `Customer Updated`
  String get customerUpdated {
    return Intl.message(
      'Customer Updated',
      name: 'customerUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Customer Deleted`
  String get customerDeleted {
    return Intl.message(
      'Customer Deleted',
      name: 'customerDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Update Customer`
  String get updateCustomer {
    return Intl.message(
      'Update Customer',
      name: 'updateCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Add Customer`
  String get addCustomer {
    return Intl.message(
      'Add Customer',
      name: 'addCustomer',
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
