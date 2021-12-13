import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/bloc/settings_bloc/settings_bloc.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/widgets/circular.dart';

import '../../constants.dart';
import 'history_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  void _writeBoolValue(BuildContext context, String key, bool value) {
    context.read<SettingsBloc>().add(SetSettingsEvent(key, value));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Заголовок
              PageCaption(caption: S.of(context).settings),
              Expanded(
                child: BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    if (state is SettingsUpdatingState) {
                      return const CenterCircularWidget();
                    }

                    final settingsState = state as SettingsLoadedState;

                    return Column(
                      children: [
                        SwitchListTile(
                          title: Text(S.of(context).sound),
                          value: settingsState.getSettingsValue(prefSound)!,
                          onChanged: (bool value) {
                            _writeBoolValue(context, prefSound, value);
                          },
                        ),
                        SwitchListTile(
                          title: Text(S.of(context).vibration),
                          value: settingsState.getSettingsValue(prefVibration)!,
                          onChanged: (bool value) {
                            _writeBoolValue(context, prefVibration, value);
                          },
                        ),
                        SwitchListTile(
                          title: Text(S.of(context).keep_screen_on),
                          value: settingsState
                              .getSettingsValue(prefKeepScreenAwake)!,
                          onChanged: (bool value) {
                            _writeBoolValue(
                                context, prefKeepScreenAwake, value);
                          },
                        ),
                        SwitchListTile(
                          title: Text(S.of(context).save_measures),
                          value:
                              settingsState.getSettingsValue(prefSaveMeasures)!,
                          onChanged: (bool value) {
                            _writeBoolValue(context, prefSaveMeasures, value);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: DropdownButton<String>(
                              value: state.getSettingsValue(prefTheme),
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  context.read<SettingsBloc>().add(
                                      SetSettingsEvent(prefTheme, newValue));
                                }
                              },
                              items: <String, String>{
                                magentaLight: '${S.current.magenta} ',
                                magentaDark: '${S.current.magenta} ',
                                blueLight: '${S.current.breeze} ',
                                blueDark: '${S.current.breeze} ',
                                greenLight: '${S.current.cedar} ',
                                greenDark: '${S.current.cedar} '
                              }
                                  .entries
                                  .map<DropdownMenuItem<String>>(
                                    (MapEntry<String, String> entry) =>
                                        DropdownMenuItem<String>(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}


/*
Мажента свет
Мажента сумерки
Бриз свет
Бриз сумерки
Поляна свет
Поляна сумерки
 */
