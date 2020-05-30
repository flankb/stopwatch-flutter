import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learnwords/fake/fake_data_fabric.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/view/dialogs/filter_dialog.dart';
import 'package:learnwords/widgets/stopwatch_item_widget.dart';

import 'entity_edit_page.dart';

class HistoryPage extends StatelessWidget {
  final Type pageType;
  final int entityId;

  // Передать сюда ValueKey
  const HistoryPage({Key key, this.pageType, this.entityId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List data = [];
    List<int> selectedIndexes;

    if (pageType == MeasureViewModel) {
      data = FakeDataFabric.measuresHistory();
    } else {
      data = FakeDataFabric.lapsHistory();
    }

    // Множественное выделение:
    // https://medium.com/flutterdevs/selecting-multiple-item-in-list-in-flutter-811a3049c56f

    // В данной статье интересный подход, где каждый элемент является Stateful виджетом

    return Scaffold(
      appBar: AppBar(
        title: Text("История измерений"),
      ),
      body: Stack(children: [
        Container(
          // TODO Реализовать Multiselect
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              BaseStopwatchEntity entity = data[index];
              final key = PageStorageKey<String>("entity_$index");

              return StopwatchItem(key : key, entity: entity, selectedEvent: (b) => { },);
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
