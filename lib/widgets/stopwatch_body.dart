import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwords/bloc/measure_bloc/bloc.dart';
import 'package:learnwords/bloc/measure_bloc/measure_event.dart';
import 'package:learnwords/fake/fake_data_fabric.dart';
import 'package:learnwords/generated/l10n.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/util/time_displayer.dart';

import 'buttons_bar.dart';

class StopwatchBody extends StatelessWidget {
  final MeasureBloc measureBloc;

  const StopwatchBody({Key key, this.measureBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<LapViewModel> items = FakeDataFabric.mainPageLaps();
    //var measureBloc = BlocProvider.of<MeasureBloc>(context);

    return BlocBuilder<MeasureBloc, MeasureState>(builder: (BuildContext context, MeasureState state) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: StreamBuilder<int>(
                initialData: 0,
                stream: measureBloc.tickStream,
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: <Widget>[
                          Text(
                            snapshot.data.toString(),
                            /*measureBloc.state.measure.elapsedTime()[0],*/
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            snapshot.data.toString(),
                            /*measureBloc.state.measure.elapsedTime()[1],*/
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: <Widget>[
                          Text(
                            "00:00,",
                            style: TextStyle(fontSize: 44),
                          ),
                          Text(
                            "00",
                            style: TextStyle(fontSize: 26),
                          )
                        ],
                      )
                    ],
                  );
                }
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.measure.laps.length,
              itemBuilder: (BuildContext context, int index) {
                final lap = state.measure.laps[index];

                return ListTile(
                    leading: SizedBox(
                        width: 20,
                        child: Text(lap.order.toString())),
                    title: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[Text("+${lap.differenceTime()}"), Text(lap.overallTime())],
                      ),
                    ));
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                    child: SizedBox(
                      height: 150,
                      child: RawMaterialButton(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            state is MeasureStartedState ? S.of(context).pause : S.of(context).start,
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          if (state is MeasureReadyState || state is MeasurePausedState){
                            measureBloc.add(MeasureStartedEvent());
                          } else if (state is MeasureStartedState) {
                            measureBloc.add(MeasurePausedEvent());
                          }
                        },
                        fillColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                    child: SizedBox(
                      height: 150,
                      child: RawMaterialButton(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("Круг", style: TextStyle(fontSize: 28, color: Colors.black)),
                        ),
                        onPressed: state is MeasureStartedState ? () {
                          measureBloc.add(LapAddedEvent());
                        } : null,
                        fillColor: Colors.white30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
          ButtonsBar()
        ],
      );
    });
  }
}
