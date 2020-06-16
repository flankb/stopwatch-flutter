import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwords/bloc/measure_bloc/bloc.dart';
import 'package:learnwords/bloc/measure_bloc/measure_event.dart';
import 'package:learnwords/fake/fake_data_fabric.dart';
import 'package:learnwords/generated/l10n.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/util/time_displayer.dart';
import 'package:learnwords/widgets/measure_lap_item.dart';
import 'package:learnwords/widgets/sound_widget.dart';
import 'package:preferences/preference_service.dart';
import 'package:vibration/vibration.dart';

import 'buttons_bar.dart';

class StopwatchBody extends StatefulWidget {
  final MeasureBloc measureBloc;

  const StopwatchBody({Key key, this.measureBloc}) : super(key: key);

  @override
  _StopwatchBodyState createState() => _StopwatchBodyState();
}

class _StopwatchBodyState extends State<StopwatchBody> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    debugPrint("StopwatchBody build");

    List<LapViewModel> items = FakeDataFabric.mainPageLaps();

    //var measureBloc = BlocProvider.of<MeasureBloc>(context);
    return BlocBuilder<MeasureBloc, MeasureState>(builder: (BuildContext context, MeasureState state) {
      //state.measure.lastRestartedOverall = DateTime.now();

      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: StreamBuilder<int>(
                  initialData: 0,
                  stream: widget.measureBloc.tickStream,

                  //date2.difference(birthday).inDays;
                  builder: (context, snapshot) {
                    if (snapshot.data == -1) {
                      debugPrint("Hash code 2: ${state.measure.hashCode}");
                      debugPrint("StreamBuilder ok! Measure ${state.measure} LastRestarted ${state.measure.lastRestartedOverall}");
                    }

                    final delta1 = DateTime.now().difference(state.measure.lastRestartedOverall).inMilliseconds;
                    final delta2 = DateTime.now().difference(state.measure.lastRestartedOverall).inMilliseconds;

                    final overallDifference = state.measure.elapsed + delta1; // TODO elapsed не сбрасывается
                    final lapDifference = state.measure.elapsedLap + delta2;

                    final d1 = Duration(milliseconds: overallDifference);
                    final d2 = Duration(milliseconds: lapDifference);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: <Widget>[
                            Text(
                              "${TimeDisplayer.format2(d2)},",
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
                              "${TimeDisplayer.format2(d1)},",
                              style: TextStyle(fontSize: 44),
                            ),
                            Text(
                              TimeDisplayer.formatMills(d1),
                              style: TextStyle(fontSize: 32),
                            )
                          ],
                        )
                      ],
                    );
                  }),
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
                  child: MeasureLapItem(difference: "+${lap.differenceTime()},${lap.differenceMills()}", order: lap.order, overall: "${lap.overallTime()},${lap.overallMills()}" ,),
                );



                 /* return ListTile(
                    leading: SizedBox(width: 20, child: Text(lap.order.toString())),
                    title: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[Text("+${lap.differenceTime()},${lap.differenceMills()}"), Text("${lap.overallTime()},${lap.overallMills()}")],
                      ),
                    ));*/
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                      child: RawMaterialButton(
                        child: Padding(
                          padding: EdgeInsets.all(16),
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
                        fillColor: Colors.red,
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
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("Круг", style: TextStyle(fontSize: 28, color: Colors.black)),
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
                                    curve: Curves.easeOut,);
                                });


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
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: ButtonsBar(),
          )
        ],
      );
    });
  }

  _vibrate() async {
    final vibration = PrefService.getBool('vibration');
    if (vibration) {
      //if (await Vibration.hasVibrator()) { // TODO Куда-то впилить проверку (в InheritedWidget?)
        Vibration.vibrate(duration: 50);
      //}
    }
  }

  _playSound(BuildContext context, int soundId) {
    final sound = PrefService.getBool('sound');

    if (sound) {
      final s = SoundWidget.of(context);
      s.soundPool.play(s.sounds[soundId]);
    }
  }
}
