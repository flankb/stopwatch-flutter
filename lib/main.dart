import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:extended_theme/extended_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:soundpool/soundpool.dart';
import 'package:stopwatch/bloc/measure_bloc/bloc.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/widgets/circular.dart';
import 'package:stopwatch/widgets/stopwatch_body.dart';
import 'package:tuple/tuple.dart';

import 'bloc/entity_bloc/bloc.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc/storage_bloc/bloc.dart';
import 'constants.dart';
import 'generated/l10n.dart';
import 'models/stopwatch_status.dart';
import 'resources/settings_repository.dart';
import 'theme_data.dart';
import 'util/ticker.dart';
import 'widgets/inherited/sound_widget.dart';
import 'widgets/inherited/storage_blocs_provider.dart';

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 3,
  minLaunches: 3,
  remindDays: 3,
  remindLaunches: 3,
  googlePlayIdentifier: 'com.garnetjuice.stopwatch',
  appStoreIdentifier: '585027354',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await rateMyApp.init();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StorageBloc measuresBloc;
  late StorageBloc lapsBloc;

  @override
  void initState() {
    super.initState();

    final repository = StopwatchRepository();

    measuresBloc = StorageBloc(repository, EntityBloc(repository));
    lapsBloc = StorageBloc(repository, EntityBloc(repository));
  }

  @override
  void dispose() {
    measuresBloc.close();
    lapsBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            SettingsBloc(SettingsRepository())..add(LoadSettingsEvent()),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) => state is SettingsUpdatingState
              ? const CenterCircularWidget()
              : ThemeScope<AppTheme>(
                  themeId: (state as SettingsLoadedState)
                      .getSettingsValue(prefTheme),
                  availableThemes: appThemeData,
                  themeBuilder: (context, appTheme) => RepositoryProvider(
                    create: (context) => StopwatchRepository(),
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => MeasureBloc(
                            Ticker3(),
                            RepositoryProvider.of<StopwatchRepository>(context),
                          ),
                        ),
                      ],
                      child: StorageBlocsProvider(
                        measuresBloc: measuresBloc,
                        lapsBloc: lapsBloc,
                        child: MaterialApp(
                          onGenerateTitle: (BuildContext context) =>
                              S.of(context).app_title,
                          theme: appTheme.material,
                          localizationsDelegates: const [
                            S.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                          ],
                          supportedLocales: S.delegate.supportedLocales,
                          home:
                              MainPage(), //MyHomePage(title: 'Flutter Demo Home Page'),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      );
}

class Choice {
  const Choice({
    required this.title,
    this.icon,
    this.settingsType = SettingsType.none,
  });

  final String title;
  final IconData? icon;
  final SettingsType settingsType;
}

enum SettingsType { none, settings, review, about }

const List<Choice> choices = <Choice>[
  Choice(title: '??????????', icon: Icons.search),
  Choice(
    title: '?????????????? ????????????????????',
    settingsType: SettingsType.review,
  ),
  Choice(
    title: '??????????????????',
    settingsType: SettingsType.settings,
  ),
  Choice(
    title: '?? ??????????????????',
    icon: Icons.info,
    settingsType: SettingsType.about,
  ),
];

class MainPage extends StatefulWidget {
  @override
  _MyTabPageState createState() => _MyTabPageState();
}

class _MyTabPageState extends State<MainPage>
    with WidgetsBindingObserver, AfterLayoutMixin<MainPage> {
  bool categoryInited = false;
  late Future<Tuple2<Soundpool, List<int>>> _soundsLoader;

  late MeasureBloc measureBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _init();
    debugPrint('Main initState');
  }

  @override
  void reassemble() {
    super.reassemble();
    debugPrint('reassemble ${describeEnum(StopwatchStatus.Ready)}');

    _init();
  }

  void _init() {
    measureBloc = context.read<MeasureBloc>();
    measureBloc.add(MeasureOpenedEvent());

    _soundsLoader = _loadSounds();
  }

  Future<Tuple2<Soundpool, List<int>>> _loadSounds() async {
    final pool = Soundpool.fromOptions();

    final soundId1 =
        await rootBundle.load('assets/sounds/sound1.wav').then(pool.load);

    final soundId2 =
        await rootBundle.load('assets/sounds/sound2.wav').then(pool.load);

    return Tuple2(pool, [soundId1, soundId2]);
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await measureBloc.close();
    super.dispose();
  }

  void _showRateDialog(BuildContext context) {
    if (rateMyApp.shouldOpenDialog) {
      rateMyApp.showRateDialog(
        context,
        title: S.of(context).review,
        message: S.of(context).reviewRequestMessage,
        rateButton: S.of(context).rate,
        noButton: S.of(context).noThanks,
        laterButton: S.of(context).later,
        listener: (button) {
          switch (button) {
            case RateMyAppDialogButton.rate:
              debugPrint('Clicked on "Rate".');
              break;
            case RateMyAppDialogButton.later:
              debugPrint('Clicked on "Later".');
              break;
            case RateMyAppDialogButton.no:
              debugPrint('Clicked on "No".');
              break;
          }

          return true; // Return false if you want to cancel the click event.
        },
        // ignoreIOS: false,
        // Set to false if you want to show the native Apple app rating dialog on iOS.
        dialogStyle: const DialogStyle(),
        // Custom dialog styles.
        onDismissed: () => rateMyApp.callEvent(
          RateMyAppEventType.laterButtonPressed,
        ), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Main page loaded!');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(seconds: 2));
      if (mounted) {
        _showRateDialog(context);
      }
    });

    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => measureBloc,
        child: FutureBuilder<Tuple2<Soundpool, List<int>>>(
          future: _soundsLoader,
          builder: (context, snapshot) => snapshot.hasData
              ? SoundWidget(
                  soundPool: snapshot.data!.item1,
                  sounds: snapshot.data!.item2,
                  child: StopwatchBody(
                    measureBloc: measureBloc,
                  ),
                )
              : const CenterCircularWidget(),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('AppLifecycleState $state');
  }

  @override
  void afterFirstLayout(BuildContext context) {
    debugPrint('afterFirstLayout');
  }
}
