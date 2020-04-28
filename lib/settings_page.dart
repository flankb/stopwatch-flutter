import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:preferences/preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Настройки"),
      ),
      body: PreferencePage([
        PreferenceTitle('Общие'),
        DropdownPreference(
          'Стартовая страница',
          'start_page',
          defaultVal: 'Timeline',
          displayValues: ['Посты', 'По времени', 'Личные сообщения'],
          values: ['Posts', 'Timeline', 'Private Messages'],
        ),
        PreferenceTitle('Персонализация'),
        RadioPreference(
          'Светлая тема',
          'light',
          'ui_theme',
          isDefault: true,
        ),
        RadioPreference(
          'Тёмная тема',
          'dark',
          'ui_theme',
        ),
      ])
    );
  }
}