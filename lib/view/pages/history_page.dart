import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwords/bloc/storage_bloc/bloc.dart';
import 'package:learnwords/fake/fake_data_fabric.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/resources/stopwatch_db_repository.dart';
import 'package:learnwords/view/dialogs/filter_dialog.dart';
import 'package:learnwords/widgets/circular.dart';
import 'package:learnwords/widgets/stopwatch_item_widget.dart';

import 'entity_edit_page.dart';

class HistoryPage extends StatelessWidget {
  final Type pageType;
  final int entityId;
  StorageBloc _storageBloc;

  StreamController _selectedItemsStreamController;
  //StreamController _isSelectionConroller;
  List<BaseStopwatchEntity> _selectedEntities = List<BaseStopwatchEntity>();

  //int _selectedItems = 0;

  //Stream _electedItemsStream = Stream();

  // Передать сюда ValueKey
  HistoryPage({Key key, this.pageType, this.entityId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("buildState HistoryPage");

    List data = [];


    _selectedItemsStreamController = StreamController<int>.broadcast(); // StreamController<bool>.broadcast();
    //_isSelectionConroller = StreamController<bool>();

    _storageBloc = StorageBloc(StopwatchRepository(MyDatabase()));
    _storageBloc.add(OpenStorageEvent(pageType, measureId: entityId));

    if (pageType == MeasureViewModel) {
      data = FakeDataFabric.measuresHistory();
    } else {
      data = FakeDataFabric.lapsHistory();
    }

    // Множественное выделение:
    // https://medium.com/flutterdevs/selecting-multiple-item-in-list-in-flutter-811a3049c56f
    // В данной статье интересный подход, где каждый элемент является Stateful виджетом
    // Статья про эффективное использование BLoC
    // https://medium.com/flutterpub/effective-bloc-pattern-45c36d76d5fe
    return BlocProvider(
      create: (BuildContext context) {
        return _storageBloc;
      },
      child: Scaffold(
        // Вариант:
        //https://stackoverflow.com/questions/53733548/dynamic-appbar-of-flutter
        appBar: AppBar(
          title: StreamBuilder<int>(
              stream: _selectedItemsStreamController.stream,
              initialData: 0,
              builder: (context, snapshot) {
                return snapshot.data == 0 ? Text("История измерений") : Text(snapshot.data.toString());
              }),
          actions: <Widget>[
            StreamBuilder<int>(
              stream: _selectedItemsStreamController.stream,
              initialData: 0,
              builder: (context, snapshot) {
                return Row(
                  children: <Widget>[
                    snapshot.data == 1 ? IconButton(icon: Icon(Icons.edit), onPressed: () {
                    },) : SizedBox(),
                    snapshot.data >= 1 ? IconButton(icon: Icon(Icons.delete), onPressed: () {
                    },) : SizedBox()
                  ],
                );
              }
            )
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Если Выделенных элементов > 1, то снять выделение
              if (_selectedEntities.length >= 1) {
                //_isSelectionConroller.add(true);
                _selectedItemsStreamController.add(0);
                _selectedEntities.clear();
              }
              else {
                Navigator.pop(context);
              }
          },
          ),
        ),
        body: BlocBuilder<StorageBloc, StorageState>(
          builder: (BuildContext context, state) {
            if (!(state is AvailableListState)) {
              return CenterCircularWidget();
            } else {
              final availState = state as AvailableListState;

              return Stack(children: [
                Container(
                  // TODO Реализовать Multiselect
                  child:  ListView.builder(
                        itemCount: availState.allEntities.length,
                        itemBuilder: (BuildContext context, int index) {
                          BaseStopwatchEntity entity = availState.allEntities[index];
                          final key = PageStorageKey<String>("entity_$index");

                          return StopwatchItem(
                            key: key,
                            entity: entity,
                            selectionListController: _selectedItemsStreamController,
                            selectedEvent: (b) {
                              // Обновить менюшку...
                              if (b.item2) {
                                debugPrint("_selectedEntities add");
                                _selectedEntities.add(b.item1);
                              }
                              else {
                                debugPrint("_selectedEntities remove");
                                _selectedEntities.remove(b.item1);
                              }

                              _selectedItemsStreamController.add(_selectedEntities.length);
                              debugPrint("_selectedEntities.length ${_selectedEntities.length}");

                              // Добаввить или удалить из SelectedItems
                            },
                          );
                        },
                      )
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
                              Icon(
                                Icons.filter_list,
                                color: Colors.white,
                              ),
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
                    ))
              ]);
            }
          },
        ),
      ),
    );
  }
}
