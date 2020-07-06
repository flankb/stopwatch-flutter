import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:stopwatch/bloc/measure_bloc/bloc.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/service_locator.dart';
import 'package:stopwatch/util/ticker.dart';
import 'package:stopwatch/view/pages/about_page.dart';
import 'package:stopwatch/view/pages/settings_page.dart';
import 'package:stopwatch/widgets/circular.dart';
import 'package:stopwatch/widgets/inherited/app_theme_notified.dart';
import 'package:stopwatch/widgets/stopwatch_body.dart';
import 'package:preferences/preferences.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import 'package:tuple/tuple.dart';
//import 'package:scrollable_positioned_list/scrollable_positioned_list.dart' as scrollList;

import 'models/stopwatch_status.dart';
import 'generated/l10n.dart';
import 'theme_data.dart';
import 'util_mixins/rate_app_mixin.dart';
import 'widgets/inherited/sound_widget.dart';

// Рефакторинг
// https://iirokrankka.com/2018/12/11/splitting-widgets-to-methods-performance-antipattern/

/// Main Rate my app instance.
//RateMyApp _rateMyApp = RateMyApp();

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 3,
  minLaunches: 3,
  remindDays: 3,
  remindLaunches: 3,
  googlePlayIdentifier: 'com.garnetjuice.stopwatch',
  appStoreIdentifier: '585027354',
);

AppTheme readLastTheme(){
  final themeStr = PrefService.getString('theme') ?? AppTheme.GreenDark.toString();
  AppTheme theme = AppTheme.values.firstWhere((e) => e.toString() == themeStr);
  return theme;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // This allows to use async methods in the main method without any problem.

  // https://github.com/Skyost/rate_my_app/blob/master/example/lib/main.dart
  await rateMyApp.init();
  await PrefService.init(prefix: 'pref_'); // Настройки

  // Здесь прочитать какая тема (перед инициализацией приложения)
  final initialTheme = readLastTheme();
  final controller  = ThemeController(initialTheme, appThemeData);

  setupLocators();
  runApp(MyApp(initialTheme: initialTheme, themeController: controller,));
}

// Добавление темной темы во Flutter:
// https://proandroiddev.com/how-to-dynamically-change-the-theme-in-flutter-698bd022d0f0
// https://resocoder.com/2019/08/09/switch-themes-with-flutter-bloc-dynamic-theming-tutorial-dark-light-theme/
// https://pub.dev/packages/theme_provider
// https://pub.dev/packages/dynamic_theme
// https://api.flutter.dev/flutter/widgets/InheritedModel-class.html
class MyApp extends StatelessWidget {
  final AppTheme initialTheme;
  final ThemeController themeController;

  const MyApp({Key key, this.initialTheme, this.themeController}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPrint("themeController.themeData " + themeController.theme.toString());

    //final textTheme = Theme.of(context).textTheme;

    return InheritedThemeNotifier(
      controller: themeController,
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
              title: 'Секундомер',
              theme:  InheritedThemeNotifier.of(context).themeData.materialTheme,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              home: MyTabPageStateful() //MyHomePage(title: 'Flutter Demo Home Page'),
              );
        }
      ),
    );
  }
}

class CaptionModel extends Model {
  String _captionValue = 'ЗАГРУЗКА...';

  String get caption => _captionValue;

  void updateCaption(String caption) {
    _captionValue = caption == '' ? 'ВЕСЬ СЛОВАРЬ' : "#${caption.toUpperCase()}";
    notifyListeners();
  }

  static CaptionModel of(BuildContext context) => ScopedModel.of<CaptionModel>(context);
}

class Choice {
  const Choice({this.title, this.icon, this.settingsType = SettingsType.None});

  final String title;
  final IconData icon;
  final SettingsType settingsType;
}

enum SettingsType { None, Settings, Review, About }

const List<Choice> choices = const <Choice>[
  //const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Поиск', icon: Icons.search),
  const Choice(
      title: 'Оценить приложение',
      //icon: Icons.rate_review,
      settingsType: SettingsType.Review),
  const Choice(
      title: 'Настройки',
      //icon: Icons.settings,
      settingsType: SettingsType.Settings),
  const Choice(title: 'О программе', icon: Icons.info, settingsType: SettingsType.About),
  //const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class MyTabPageStateful extends StatefulWidget {
  @override
  _MyTabPageState createState() => _MyTabPageState();
}

class _MyTabPageState extends State<MyTabPageStateful>
    with
        //AppReviewer,
        //AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver,
        AfterLayoutMixin<MyTabPageStateful> {
  void _showDialog(BuildContext context, String message) {
    //await Future.delayed(Duration(seconds: 2));
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _select(Choice choice) {
    // Раскомментировать для вызова экрана с отзывом
    switch (choice.settingsType) {
      case SettingsType.Review:
        LaunchReview.launch(
          androidAppId: "com.garnetjuice.stopwatch",
          iOSAppId: "585027354",
        );
        break;

      case SettingsType.Settings:
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;

      case SettingsType.About:
        Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
        break;

      default:
        break;
    }
    // Causes the app to rebuild with the new _selectedChoice.
  }

  CaptionModel captionModel;

  ItemScrollController _categoryScrollController;
  bool categoryInited = false;

  //int _selectedIndex = 0;

  Future _soundsLoader;

  MeasureBloc measureBloc;

  @override
  void initState() {
    super.initState();

    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);*/

    WidgetsBinding.instance.addObserver(this);

    _categoryScrollController = ItemScrollController();

    _init();
    debugPrint('Main initState');
  }

  @override
  void reassemble() {
    super.reassemble();
    debugPrint('reassemble' + " " + describeEnum(StopwatchStatus.Ready));

    _init();
  }

  _init() {
    if (captionModel == null) {
      captionModel = CaptionModel();
    }

    if (measureBloc == null /*|| true*/) {
      measureBloc = GetIt.I.get<MeasureBloc>();
      measureBloc.add(MeasureOpenedEvent());
    }

    _soundsLoader = _loadSounds();
  }

  /*Soundpool _pool;
  int _soundId1;
  int _soundId2;*/

  Future<Tuple2<Soundpool, List<int>>> _loadSounds() async {
    final pool = Soundpool(streamType: StreamType.notification);

    final soundId1 = await rootBundle.load("assets/sounds/sound1.wav").then((ByteData soundData) {
      return pool.load(soundData);
    });

    final soundId2 = await rootBundle.load("assets/sounds/sound2.wav").then((ByteData soundData) {
      return pool.load(soundData);
    });

    return Tuple2(pool, [soundId1, soundId2]);
  }

  @override
  void dispose() async {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/

    WidgetsBinding.instance.removeObserver(this);
    await measureBloc.close();
    super.dispose();
  }

  _showRateDialog(BuildContext context) {
    if (rateMyApp.shouldOpenDialog) {
      rateMyApp.showRateDialog(
        context,
        title: 'Оценить приложение',
        // The dialog title.
        message: 'Если вам понравилось приложение, пожалуйста поставьте ему оценку.\nЭто поможет его развитию!',
        // The dialog message.
        rateButton: 'ОЦЕНИТЬ',
        // The dialog "rate" button text.
        noButton: 'НЕТ, СПАСИБО',
        // The dialog "no" button text.
        laterButton: 'ПОЗЖЕ',
        // The dialog "later" button text.
        listener: (button) {
          // The button click listener (useful if you want to cancel the click event).
          switch (button) {
            case RateMyAppDialogButton.rate:
              print('Clicked on "Rate".');
              break;
            case RateMyAppDialogButton.later:
              print('Clicked on "Later".');
              break;
            case RateMyAppDialogButton.no:
              print('Clicked on "No".');
              break;
          }

          return true; // Return false if you want to cancel the click event.
        },
        ignoreIOS: false,
        // Set to false if you want to show the native Apple app rating dialog on iOS.
        dialogStyle: DialogStyle(),
        // Custom dialog styles.
        onDismissed: () => rateMyApp.callEvent(
            RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        // actionsBuilder: (_) => [], // This one allows you to use your own buttons.
      );
    }
  }

  /*
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    debugPrint('Main page loaded!');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 2));
      _showRateDialog(context);
    });

    //final tabsTemplate = ['КАТЕГОРИИ', 'ВЕСЬ СЛОВАРЬ'];

    // Подсказки по разметке:
    // https://medium.com/flutter-community/flutter-expanded-widget-e203590f00cf

    // BlocProvider.of<FilteredTodosBloc>(context).add(FilterUpdated(filter));

    //(child: StopwatchBody()),

    debugPrint("measureBloc == null " + (measureBloc == null).toString());

    return Scaffold(
        body: BlocProvider(
            create: (BuildContext context) => measureBloc,
            child: FutureBuilder(
                future: _soundsLoader,
                builder: (context, snapshot) {
                  return snapshot.hasData
                    ? SoundWidget(
                          soundPool: snapshot.data.item1,
                          sounds: snapshot.data.item2,
                          child: StopwatchBody(
                            measureBloc: measureBloc,
                          ),
                        )
                      : CenterCircularWidget();
                })));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("AppLifecycleState " + state.toString());
    if (state == AppLifecycleState.inactive) {
      // TODO Сохранить сущности в БД
    }
  }

  //@override
  // TODO: implement wantKeepAlive
  //bool get wantKeepAlive => true;

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    debugPrint("afterFirstLayout");
  }
}
