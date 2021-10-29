import 'package:extended_theme/extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/widgets/circular.dart';

import '../../constants.dart';
import '../../theme_data.dart';
import 'history_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool sound;
  late bool vibration;
  late bool keepScreenAwake;
  late bool persistMeasure;
  late String theme;

  late Future _initPrefsAction;
  late SharedPreferences _sharedPrefs;

  @override
  void initState() {
    super.initState();

    _initPrefsAction = _initPrefs();
  }

  Future _initPrefs() async {
    _sharedPrefs = await SharedPreferences.getInstance();

    sound = _sharedPrefs.getBool(PREF_SOUND) ?? true;
    vibration = _sharedPrefs.getBool(PREF_VIBRATION) ?? true;
    keepScreenAwake = _sharedPrefs.getBool(PREF_KEEP_SCREEN_AWAKE) ?? false;
    persistMeasure = _sharedPrefs.getBool(PREF_SAVE_MEASURES) ?? true;
    theme = _sharedPrefs.getString(PREF_THEME) ?? GreenLight;
  }

  _writeBoolValue(String key, bool value) {}

  @override
  Widget build(BuildContext context) {
    final sunrise = S.current.sunrise;
    final twilight = S.current.twilight;

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          // Заголовок
          PageCaption(caption: S.of(context).settings),
          /*Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  BackButton(),
                  Text(S.of(context).settings, style: TextStyle(fontSize: 36),)
                ],
              ),*/
          Expanded(
            child: FutureBuilder(
                future: _initPrefsAction,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return CenterCircularWidget();
                  }

                  return Column(children: [
                    SwitchListTile(
                      title: Text(S.of(context).sound),
                      value: sound,
                      onChanged: (bool value) {
                        setState(() {
                          sound = value;
                          _writeBoolValue(PREF_SOUND, value);
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(S.of(context).vibration),
                      value: vibration,
                      onChanged: (bool value) {
                        setState(() {
                          vibration = value;
                          _writeBoolValue(PREF_VIBRATION, value);
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(S.of(context).keep_screen_on),
                      value: keepScreenAwake,
                      onChanged: (bool value) {
                        setState(() {
                          keepScreenAwake = value;
                          _writeBoolValue(PREF_KEEP_SCREEN_AWAKE, value);
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text(S.of(context).save_measures),
                      value: persistMeasure,
                      onChanged: (bool value) {
                        setState(() {
                          persistMeasure = value;
                          _writeBoolValue(PREF_SAVE_MEASURES, value);
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: DropdownButton<String>(
                          value: theme,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          // style: const TextStyle(color: Colors.deepPurple),
                          // underline: Container(
                          //   height: 2,
                          //   color: Colors.deepPurpleAccent,
                          // ),
                          onChanged: (String? newValue) {
                            setState(() {
                              theme = newValue!;
                              _sharedPrefs.setString(PREF_THEME, newValue);
                              ThemeHolder.of<AppTheme>(context)
                                  .updateThemeById(newValue);
                              // Обновить тему
                            });
                          },
                          items: <String, String>{
                            MagentaLight: '${S.current.magenta} $sunrise',
                            MagentaDark: '${S.current.magenta} $twilight',
                            BlueLight: '${S.current.breeze} $sunrise',
                            BlueDark: '${S.current.breeze} $twilight',
                            GreenLight: '${S.current.cedar} $sunrise',
                            GreenDark: '${S.current.cedar} $twilight'
                          }.entries.map<DropdownMenuItem<String>>(
                              (MapEntry<String, String> entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ]);
                }),
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
