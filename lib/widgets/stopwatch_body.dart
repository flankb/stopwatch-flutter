import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_review/launch_review.dart';
import 'package:path/path.dart';
import 'package:stopwatch/bloc/measure_bloc/bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';
import 'package:stopwatch/constants.dart';
import 'package:stopwatch/fake/fake_data_fabric.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';
import 'package:stopwatch/purchaser.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/util/time_displayer.dart';
import 'package:stopwatch/view/pages/about_page.dart';
import 'package:stopwatch/view/pages/history_page.dart';
import 'package:stopwatch/view/pages/settings_page.dart';
import 'package:stopwatch/widgets/measure_lap_item.dart';
import 'package:preferences/preference_service.dart';
import 'package:stopwatch/widgets/metro_app_bar.dart';
import 'package:vibration/vibration.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock/wakelock.dart';

import '../service_locator.dart';
import 'buttons_bar.dart';
import 'inherited/sound_widget.dart';

class StopwatchBody extends StatefulWidget {
  final MeasureBloc measureBloc;

  const StopwatchBody({Key key, this.measureBloc}) : super(key: key);

  @override
  _StopwatchBodyState createState() => _StopwatchBodyState();
}

class _StopwatchBodyState extends State<StopwatchBody> with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  AnimationController _controller;
  Animation<double> animation;
  bool _existsVibrator = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300), upperBound: 150, lowerBound: 0);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    _initVibratorPossibility();
    _enableWakeLock();
  }

  _initVibratorPossibility() async {
    _existsVibrator = await Vibration.hasVibrator();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("StopwatchBody build. Mounted is ${mounted.toString()}");

    // TODO Здесь можно инициализировать WakeLock

    //List<LapViewModel> items = FakeDataFabric.mainPageLaps();

    /*
    key: Key('my-widget-key'),
      onVisibilityChanged: (VisibilityInfo info) {
        var visiblePercentage = info.visibleFraction * 100;
        debugPrint('Widget ${info.key} is $visiblePercentage% visible');
      },
     */

    return VisibilityDetector(
      key: Key('STOPWATCH_VISIBILITY_key'),
      onVisibilityChanged: (VisibilityInfo info) async {
        var visiblePercentage = info.visibleFraction * 100;
        debugPrint('Widget ${info.key} is $visiblePercentage% visible');

        if(visiblePercentage > 50){
          await _enableWakeLock();
        }
        else{
          await _disableWakelock();
        }
      },
      child: BlocBuilder<MeasureBloc, MeasureState>(builder: (BuildContext context, MeasureState state) {
        final mediaQueryOrientation = MediaQuery.of(context).orientation;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: StreamBuilder<int>(
                    initialData: 0,
                    stream: widget.measureBloc.tickStream,
                    builder: (context, snapshot) {
                      /*if (snapshot.data == -1) {
                        debugPrint("Hash code 2: ${state.measure.hashCode}");
                        debugPrint("StreamBuilder ok! Measure ${state.measure} LastRestarted ${state.measure.lastRestartedOverall}");
                      }*/

                      final delta1 = snapshot.data > 0 ? DateTime.now().difference(state.measure.lastRestartedOverall).inMilliseconds : 0;
                      final overallDifference = state.measure.elapsed + delta1; // TODO elapsed не сбрасывается
                      final lapDifference = state.measure.elapsedLap + delta1;

                      final d1 = Duration(milliseconds: overallDifference);
                      final d2 = Duration(milliseconds: lapDifference);

                      return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, widget) {
                            return Transform.translate(
                              offset: Offset(0 + _controller.value, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.ideographic,
                                    children: <Widget>[
                                      Text(
                                        "${TimeDisplayer.formatBase(d2)},",
                                        key: Key('lap_text'),
                                        style: TextStyle(fontSize: 30),
                                      ),
                                      Text(
                                        TimeDisplayer.formatMills(d2),
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.ideographic,
                                    children: <Widget>[
                                      Text(
                                        "${TimeDisplayer.formatBase(d1)},",
                                        key: Key('overall_text'),
                                        style: TextStyle(fontSize: 44),
                                      ),
                                      Text(
                                        TimeDisplayer.formatMills(d1),
                                        style: TextStyle(fontSize: 32),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    }),
              ),
            ),

            if (state is MeasurePausedState) Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                  TimeDisplayer.humanFormat(Duration(milliseconds: state.measure.elapsed)),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: state.measure.laps.length,
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  final lap = state.measure.laps[index];

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                    child: MeasureLapItem(
                      difference: "+${lap.differenceTime()},${lap.differenceMills()}",
                      order: lap.order,
                      overall: "${lap.overallTime()},${lap.overallMills()}",
                    ),
                  );
                },
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: mediaQueryOrientation == Orientation.portrait ? 150 : 70,
                //minHeight: 100
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                        child: RawMaterialButton(
                          key: Key('start_button'),
                          //enableFeedback: false
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Text(
                              state is MeasureStartedState ? S.of(context).pause : S.of(context).start,
                              style: TextStyle(fontSize: 28, color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            if (state is MeasureReadyState || state is MeasurePausedState) {
                              widget.measureBloc.add(MeasureStartedEvent());
                            } else if (state is MeasureStartedState) {
                              widget.measureBloc.add(MeasurePausedEvent());
                            }

                            _playSound(context, 0);
                            _vibrate();
                          },
                          fillColor: state is MeasureStartedState ? Colors.red : Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                        child: RawMaterialButton(
                          key: Key('lap_button'),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Text(S.of(context).lap, style: TextStyle(fontSize: 28, color: Colors.black)),
                          ),
                          onPressed: state is MeasureStartedState
                              ? () async {
                                  widget.measureBloc.add(LapAddedEvent());
                                  _playSound(context, 1);
                                  _vibrate();

                                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                    _scrollController.animateTo(
                                      _scrollController.position.maxScrollExtent,
                                      duration: const Duration(milliseconds: 50),
                                      curve: Curves.easeOut,
                                    );
                                  });

                                  /*
                                    if (_controller.isCompleted) {
                                      _controller.reverse();
                                    } else {
                                      _controller.forward();
                                    }
                                   */
                                }
                              : null,
                          fillColor: Colors.yellowAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: MetroAppBar(
                  primaryCommands: [
                    StreamBuilder<PurchaseCompletedState>(
                      stream: getIt.get<PurchaserBloc>().purchaseStateStreamController.stream,
                      initialData: PurchaseCompletedState.empty(),
                      builder: (context, snapshot) {
                        return PrimaryCommand(
                          pic: Icons.refresh,
                          tooltip: S.of(context).reset,
                          onPressed: () {
                            final measureCounts = state.measure.finishedMeasuresCount;
                            bool saveMeasure = PrefService.getBool(PREF_SAVE_MEASURES) ?? true;
                            final proOwned = snapshot.data.skuIsAcknowledged(PRO_PACKAGE);
                            saveMeasure = saveMeasure && (proOwned || measureCounts <= MAX_FREE_MEASURES);

                            BlocProvider.of<MeasureBloc>(context).add(MeasureFinishedEvent(saveMeasure));

                            if (_controller.isCompleted) {
                              _controller.reverse();
                            } else {
                              _controller.forward();
                            }
                          },
                        );
                      }
                    ),
                    PrimaryCommand(
                      pic: Icons.list,
                      tooltip: S.of(context).history,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return HistoryPage(
                            pageType: MeasureViewModel,
                            entityId: null,
                          );
                        }));
                      },
                    ),
                    PrimaryCommand(
                      pic: Icons.settings,
                      tooltip: S.of(context).settings,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return SettingsPage();
                        }));
                      },
                    ),
                  ],
                  secondaryCommands: <SecondaryCommand>[
                    SecondaryCommand(
                        commandName: "review",
                        onPressed: () {
                          LaunchReview.launch(
                            androidAppId: "com.garnetjuice.stopwatch",
                            iOSAppId: "585027354",
                          );
                        },
                        child: Text(S.of(context).review)),
                    SecondaryCommand(
                        commandName: "about",
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            return AboutPage();
                          }));
                        },
                        child: Text(S.of(context).about))
                  ],
                ))
          ],
        );
      }),
    );
  }

  @override
  void dispose() async {
    await _disableWakelock();
    super.dispose();
  }

  _vibrate() async {
    final vibration = PrefService.getBool(PREF_VIBRATION) ?? true;
    if (vibration) {
      if (_existsVibrator) {
        Vibration.vibrate(duration: 50);
      }
    }
  }

  _playSound(BuildContext context, int soundId) {
    final sound = PrefService.getBool(PREF_SOUND) ?? true;

    if (sound) {
      final s = SoundWidget.of(context);
      s.soundPool.play(s.sounds[soundId]);
    }
  }

  _enableWakeLock() async {
    debugPrint('Start wakelock enabling!');

    if (PrefService.getBool(PREF_KEEP_SCREEN_AWAKE) ?? false) {
      if(!(await Wakelock.isEnabled)){
        await Wakelock.enable();
        debugPrint('Wakelock enabled!');
      }
    }
  }

  _disableWakelock() async {
    debugPrint('Start wakelock disabling!');

    if ((await Wakelock.isEnabled)) {
      await Wakelock.disable();
      debugPrint('Wakelock disabled!');
    }
  }
}