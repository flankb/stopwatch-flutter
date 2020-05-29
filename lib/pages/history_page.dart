import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learnwords/fake/fake_data_fabric.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';

import 'entity_edit_page.dart';

class HistoryPage extends StatelessWidget {
  final Type pageType;
  final int entityId;

  // Передать сюда ValueKey
  const HistoryPage({Key key, this.pageType, this.entityId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List data = [];

    if (pageType == MeasureViewModel) {
      data = FakeDataFabric.measuresHistory();
    } else {
      data = FakeDataFabric.lapsHistory();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("История измерений"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            BaseStopwatchEntity entity = data[index];

            return InkWell(
              onLongPress: () => {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return EntityEditPage(entityType: pageType, entityId: entity.id);
                }))
              },
              onTap: () => {
                if (pageType == MeasureViewModel)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return HistoryPage(pageType: LapViewModel, entityId: entity.id);
                    }))
                  }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                    child: Text(
                  entity.comment,
                  style: TextStyle(fontSize: 18),
                )),
              ),
            );
          },
        ),
      ),
    );
  }
}
