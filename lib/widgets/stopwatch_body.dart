import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnwords/fake/fake_data_fabric.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/util/time_displayer.dart';

import 'buttons_bar.dart';

class StopwatchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<LapViewModel> items = FakeDataFabric.mainPageLaps();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "00:00",
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  "00:00",
                  style: TextStyle(fontSize: 34),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final lap = items[index];

              return ListTile(leading: Text(lap.order.toString()),
                  title: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("+${lap.differenceTime()}"),
                        Text(lap.overallTime())
                      ],
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
                        child: Text("Старт", style: TextStyle(
                          fontSize: 22, color: Colors.white
                        ),),
                      ),
                      onPressed: () {},
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
                        child: Text("Круг", style: TextStyle(
                            fontSize: 22, color: Colors.black
                        )),
                      ),
                      onPressed: () {},
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
  }
}
