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

        SwitchPreference(
          'Звук',
          'sound',
          defaultVal: true,
        ),
        SwitchPreference(
          'Вибрация',
          'vibration',
          defaultVal: true,
        ),
        SwitchPreference(
          'Блокировка экрана',
          'screen_block',
          defaultVal: true,
          desc: "Вкл",
        ),
        TextFieldPreference(
          'E-mail',
          'email',

          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          autofocus: false,
          maxLines: 1,
        )
      ])
    );
  }
}