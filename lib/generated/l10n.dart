// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `Lap`
  String get lap {
    return Intl.message(
      'Lap',
      name: 'lap',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Rate and review`
  String get review {
    return Intl.message(
      'Rate and review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `If you liked the application, please give it a rating.\nThis will help its development!`
  String get reviewRequestMessage {
    return Intl.message(
      'If you liked the application, please give it a rating.\nThis will help its development!',
      name: 'reviewRequestMessage',
      desc: '',
      args: [],
    );
  }

  /// `RATE`
  String get rate {
    return Intl.message(
      'RATE',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `NO, THANKS`
  String get noThanks {
    return Intl.message(
      'NO, THANKS',
      name: 'noThanks',
      desc: '',
      args: [],
    );
  }

  /// `LATER`
  String get later {
    return Intl.message(
      'LATER',
      name: 'later',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Measurements`
  String get measures {
    return Intl.message(
      'Measurements',
      name: 'measures',
      desc: '',
      args: [],
    );
  }

  /// `Overall time`
  String get overall_time {
    return Intl.message(
      'Overall time',
      name: 'overall_time',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date_created {
    return Intl.message(
      'Date',
      name: 'date_created',
      desc: '',
      args: [],
    );
  }

  /// `Laps`
  String get laps {
    return Intl.message(
      'Laps',
      name: 'laps',
      desc: '',
      args: [],
    );
  }

  /// `No Measurements`
  String get no_measures {
    return Intl.message(
      'No Measurements',
      name: 'no_measures',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit_app_bar {
    return Intl.message(
      'Edit',
      name: 'edit_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get del_app_bar {
    return Intl.message(
      'Delete',
      name: 'del_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `Laps cannot be removed!`
  String get no_possible_delete_laps {
    return Intl.message(
      'Laps cannot be removed!',
      name: 'no_possible_delete_laps',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share_app_bar {
    return Intl.message(
      'Share',
      name: 'share_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `To *csv`
  String get to_csv_app_bar {
    return Intl.message(
      'To *csv',
      name: 'to_csv_app_bar',
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
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fi'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}