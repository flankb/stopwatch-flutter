import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learnwords/fake/fake_data_fabric.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/view/dialogs/filter_dialog.dart';

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
      body: Stack(children: [
        Container(
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
        Align(
            alignment: Alignment.bottomCenter,

            child: SizedBox(
              width: 150,
              child: RawMaterialButton(
                onPressed: () async {
                  final result = await showDialog(context: context, builder: (context) => FilterDialog());
                  // Для получения результата: Navigator.pop(context, _controller.text);
                },
                child: Padding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.filter_list, color: Colors.white,),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Фильтр",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                elevation: 2.0,
                fillColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(5.0),
              ),
            )
        )
      ]),
    );
  }
}
