import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:preferences/preferences.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/widgets/inherited/app_theme_notified.dart';
import 'package:validators/validators.dart';

import '../../constants.dart';
import '../../theme_data.dart';
import 'history_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sunrise = S.current.sunrise;
    final twilight = S.current.twilight;

    return Scaffold(
      body: SafeArea(
          child: Column(
            children: <Widget>[
              // Заголовок
              PageCaption(caption : S.of(context).settings),
              /*Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  BackButton(),
                  Text(S.of(context).settings, style: TextStyle(fontSize: 36),)
                ],
              ),*/
              Expanded(
                child: PreferencePage([
                  SwitchPreference(
                    S.of(context).sound,
                    PREF_SOUND,
                    defaultVal: true,
                  ),
                  SwitchPreference(
                    S.of(context).vibration,
                    PREF_VIBRATION,
                    defaultVal: true,
                  ),
                  SwitchPreference(
                    S.of(context).keep_screen_on,
                    PREF_KEEP_SCREEN_AWAKE,
                    defaultVal: false,
                    //desc: "Вкл",
                  ),

                  SwitchPreference(
                    S.of(context).save_measures,
                    PREF_SAVE_MEASURES,
                    defaultVal: true,
                    //desc: "Вкл",
                  ),

                  DropdownPreference<String>( //
                    S.of(context).app_theme,
                    PREF_THEME,
                    defaultVal: AppTheme.GreenLight.toString(),
                    onChange: (v) {
                      AppTheme theme = AppTheme.values.firstWhere((e) => e.toString() == v.toString());
                      //debugPrint("Selected theme: " + theme.toString());
                      InheritedThemeNotifier.of(context).updateTheme(theme);
                    },
                    displayValues: ['${S.current.magenta} $sunrise',
                      '${S.current.magenta} $twilight',
                      '${S.current.breeze} $sunrise',
                      '${S.current.breeze} $twilight',
                      '${S.current.cedar} $sunrise',
                      '${S.current.cedar} $twilight'],
                    values: [AppTheme.MagentaLight.toString(), AppTheme.MagentaDark.toString(), AppTheme.BlueLight.toString(), AppTheme.BlueDark.toString(), AppTheme.GreenLight.toString(), AppTheme.GreenDark.toString()],
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}

/*
Мажента свет
Мажента сумерки
Бриз свет
Бриз сумерки
Поляна свет
Поляна сумерки
 */