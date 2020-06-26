import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:preferences/preferences.dart';
import 'package:stopwatch/widgets/inherited/app_theme_notified.dart';
import 'package:validators/validators.dart';

import '../../theme_data.dart';

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
          DropdownPreference<String>( //
            'Тема приложения',
            'theme',
            defaultVal: AppTheme.BlueLight.toString(),
            onChange: (v) {


              AppTheme theme = AppTheme.values.firstWhere((e) => e.toString() == v.toString());
              debugPrint("Selected theme: " + theme.toString());

              InheritedThemeNotifier.of(context).updateTheme(theme);
            },
            displayValues: ['Blue Light', 'Blue Dark', 'Green Light', 'Green Dark'],
            values: [AppTheme.BlueLight.toString(), AppTheme.BlueDark.toString(), AppTheme.GreenLight.toString(), AppTheme.GreenDark.toString()],
          ),
          TextFieldPreference(
            'E-mail',
            'email',
            defaultVal: 'email@example.com',
            validator: (str) {
              if (!isEmail(str)) {
                return "Invalid email";
              }

              return null;
            },
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            autofocus: false,
            maxLines: 1,
          )
        ]));
  }
}
