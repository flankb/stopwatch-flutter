import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_review/launch_review.dart';
import 'package:metro_appbar/metro_appbar.dart';
import 'package:stopwatch/bloc/measure_bloc/bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/constants.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/util/pref_service.dart';
import 'package:stopwatch/util/time_displayer.dart';
import 'package:stopwatch/view/pages/about_page.dart';
import 'package:stopwatch/view/pages/history_page.dart';
import 'package:stopwatch/view/pages/settings_page.dart';
import 'package:stopwatch/widgets/measure_lap_item.dart';
import 'package:vibration/vibration.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock/wakelock.dart';

import 'inherited/sound_widget.dart';

class StopwatchBody extends StatefulWidget {
  final MeasureBloc measureBloc;

  const StopwatchBody({
    required this.measureBloc,
    Key? key,
  }) : super(key: key);

  @override
  _StopwatchBodyState createState() => _StopwatchBodyState();
}

class _StopwatchBodyState extends State<StopwatchBody>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<double> animation;
  bool _existsVibrator = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        upperBound: 150,
        lowerBound: 0,
        vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    _initVibratorPossibility();
    _enableWakeLock();
  }

  Future<void> _initVibratorPossibility() async {
    _existsVibrator = (await Vibration.hasVibrator()) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('StopwatchBody build. Mounted is ${mounted.toString()}');

    return VisibilityDetector(
      key: const Key('STOPWATCH_VISIBILITY_key'),
      onVisibilityChanged: (VisibilityInfo info) async {
        final visiblePercentage = info.visibleFraction * 100;
        debugPrint('Widget ${info.key} is $visiblePercentage% visible');

        if (visiblePercentage > 50) {
          await _enableWakeLock();
        } else {
          await _disableWakelock();
        }
      },
      child: BlocBuilder<MeasureBloc, MeasureState>(
        builder: (BuildContext context, MeasureState state) {
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
                      final delta1 = snapshot.data != null && snapshot.data! > 0
                          ? DateTime.now()
                              .difference(state.measure.lastRestartedOverall)
                              .inMilliseconds
                          : 0;
                      final overallDifference = state.measure.elapsed +
                          delta1; // TODO elapsed не сбрасывается
                      final lapDifference = state.measure.elapsedLap + delta1;

                      final d1 = Duration(milliseconds: overallDifference);
                      final d2 = Duration(milliseconds: lapDifference);

                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (context, widget) => Transform.translate(
                          offset: Offset(0 + _controller.value, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.ideographic,
                                children: <Widget>[
                                  Text(
                                    '${formatBase(d2)},',
                                    key: const Key('lap_text'),
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    formatMills(d2),
                                    style: const TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.ideographic,
                                children: <Widget>[
                                  Text(
                                    '${formatBase(d1)},',
                                    key: const Key('overall_text'),
                                    style: const TextStyle(fontSize: 44),
                                  ),
                                  Text(
                                    formatMills(d1),
                                    style: const TextStyle(fontSize: 32),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (state is MeasurePausedState)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    humanFormat(Duration(milliseconds: state.measure.elapsed)),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
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
                        difference:
                            '+${lap.differenceTime()},${lap.differenceMills()}',
                        order: lap.order,
                        overall: '${lap.overallTime()},${lap.overallMills()}',
                      ),
                    );
                  },
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      mediaQueryOrientation == Orientation.portrait ? 150 : 70,
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
                            key: const Key('start_button'),
                            onPressed: () {
                              if (state is MeasureReadyState ||
                                  state is MeasurePausedState) {
                                widget.measureBloc.add(MeasureStartedEvent());
                              } else if (state is MeasureStartedState) {
                                widget.measureBloc.add(MeasurePausedEvent());
                              }

                              _playSound(context, 0);
                              _vibrate();
                            },
                            fillColor: state is MeasureStartedState
                                ? Colors.red
                                : Theme.of(context).primaryColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            //enableFeedback: false
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Text(
                                state is MeasureStartedState
                                    ? S.of(context).pause
                                    : S.of(context).start,
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                        child: RawMaterialButton(
                          key: const Key('lap_button'),
                          onPressed: state is MeasureStartedState
                              ? () async {
                                  widget.measureBloc.add(LapAddedEvent());
                                  _playSound(context, 1);

                                  // ignore: unawaited_futures
                                  _vibrate();

                                  WidgetsBinding.instance
                                      ?.addPostFrameCallback((timeStamp) {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 50),
                                      curve: Curves.easeOut,
                                    );
                                  });
                                }
                              : null,
                          fillColor: Colors.yellowAccent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Text(
                              S.of(context).lap,
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: MetroAppBar(
                  height: 60,
                  primaryCommands: [
                    PrimaryCommand(
                      icon: Icons.refresh,
                      text: S.of(context).reset,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      onPressed: () {
                        final saveMeasure = PrefService.getInstance()
                                .sharedPrefs
                                .getBool(prefSaveMeasures) ??
                            true;
                        BlocProvider.of<MeasureBloc>(context).add(
                          MeasureFinishedEvent(saveMeasure: saveMeasure),
                        );

                        if (_controller.isCompleted) {
                          _controller.reverse();
                        } else {
                          _controller.forward();
                        }
                      },
                    ),
                    PrimaryCommand(
                      icon: Icons.list,
                      text: S.of(context).history,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const HistoryPage(
                              pageType: MeasureViewModel,
                              entityId: null,
                            ),
                          ),
                        );
                      },
                    ),
                    PrimaryCommand(
                      icon: Icons.settings,
                      text: S.of(context).settings,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                  secondaryCommands: <SecondaryCommand>[
                    SecondaryCommand(
                      text: S.of(context).review,
                      onPressed: () {
                        LaunchReview.launch(
                          androidAppId: 'com.garnetjuice.stopwatch',
                          iOSAppId: '585027354',
                        );
                      },
                    ),
                    SecondaryCommand(
                      text: S.of(context).about,
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => AboutPage(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await _disableWakelock();
    super.dispose();
  }

  Future<void> _vibrate() async {
    final vibration =
        PrefService.getInstance().sharedPrefs.getBool(prefVibration) ?? true;
    if (vibration) {
      if (_existsVibrator) {
        await Vibration.vibrate(duration: 50);
      }
    }
  }

  void _playSound(BuildContext context, int soundId) {
    final sound =
        PrefService.getInstance().sharedPrefs.getBool(prefSound) ?? true;

    if (sound) {
      final s = SoundWidget.of(context);
      s?.soundPool.play(s.sounds[soundId]);
    }
  }

  Future<void> _enableWakeLock() async {
    debugPrint('Start wakelock enabling!');

    if (PrefService.getInstance().sharedPrefs.getBool(prefKeepScreenAwake) ??
        false) {
      if (!(await Wakelock.enabled)) {
        await Wakelock.enable();
        debugPrint('Wakelock enabled!');
      }
    }
  }

  Future<void> _disableWakelock() async {
    debugPrint('Start wakelock disabling!');

    if (await Wakelock.enabled) {
      await Wakelock.disable();
      debugPrint('Wakelock disabled!');
    }
  }
}
