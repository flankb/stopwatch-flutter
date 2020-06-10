import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:learnwords/bloc/storage_bloc/bloc.dart';
import 'package:learnwords/fake/fake_data_fabric.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/resources/stopwatch_db_repository.dart';
import 'package:learnwords/service_locator.dart';
import 'package:learnwords/view/dialogs/filter_dialog.dart';
import 'package:learnwords/widgets/circular.dart';
import 'package:learnwords/widgets/stopwatch_item_widget.dart';
import 'package:toast/toast.dart';

import 'entity_edit_page.dart';

class HistoryPage extends StatefulWidget {
  final Type pageType;
  final int entityId;

  HistoryPage({Key key, this.pageType, this.entityId}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  StorageBloc _storageBloc;
  StreamController _selectedItemsStreamController;
  List<BaseStopwatchEntity> _selectedEntities = List<BaseStopwatchEntity>();

  @override
  void initState() {
    super.initState();

    _selectedItemsStreamController = StreamController<int>.broadcast();
    _storageBloc = GetIt.I.get<StorageBloc>(instanceName: widget.pageType == MeasureViewModel ? MeasuresBloc : LapsBloc);

    // TODO Инициализировать фильтр
    var lastFilter = (_storageBloc.state as AvailableListState)?.lastFilter;
    if (lastFilter != null) {
      final wasFiltered = (_storageBloc.state as AvailableListState).filtered;

      /*if (wasFiltered) {
        lastFilter =
      }*/
    }

    _storageBloc.add(LoadStorageEvent(widget.pageType, measureId: widget.entityId));

    // Сразу же отфильтруем в случае необходимости
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("buildState HistoryPage");

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
                      snapshot.data == 1
                          ? IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                final entityToEdit = _selectedEntities.single;

                                await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return EntityEditPage(
                                    entityType: widget.pageType,
                                    entityId: entityToEdit.id,
                                    entity: entityToEdit,
                                  );
                                }));

                                _unselectItems();
                              },
                            )
                          : SizedBox(),
                      snapshot.data >= 1
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                if (widget.pageType == LapViewModel) {
                                  Toast.show("Круги нельзя удалять!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                                  return;
                                }

                                final entitiesForDelete = List<BaseStopwatchEntity>();
                                entitiesForDelete.addAll(_selectedEntities);
                                _unselectItems();
                                _storageBloc.add(DeleteStorageEvent(entitiesForDelete));

                                //_unselectItems();
                              },
                            )
                          : SizedBox()
                    ],
                  );
                })
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Если Выделенных элементов > 1, то снять выделение
              if (_selectedEntities.length >= 1) {
                //_isSelectionConroller.add(true);
                _unselectItems();
              } else {
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
                    child: ListView.builder(
                  itemCount: availState.entities.length,
                  itemBuilder: (BuildContext context, int index) {
                    BaseStopwatchEntity entity = availState.entities[index];
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
                        } else {
                          debugPrint("_selectedEntities remove");
                          _selectedEntities.remove(b.item1);
                        }

                        _selectedItemsStreamController.add(_selectedEntities.length);
                        debugPrint("_selectedEntities.length ${_selectedEntities.length}");

                        // Добаввить или удалить из SelectedItems
                      },
                    );
                  },
                )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        availState.filtered
                            ? RawMaterialButton(
                                child: Icon(Icons.clear),
                                onPressed: () {
                                  _storageBloc.add(CancelFilterEvent(widget.pageType));
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                elevation: 2.0,
                                fillColor: Colors.white,
                                padding: const EdgeInsets.all(5.0),
                              )
                            : SizedBox(),
                        availState.filtered ? SizedBox(width: 12,) : SizedBox(),
                        SizedBox(
                          width: 150,
                          child: RawMaterialButton(
                            onPressed: () async {
                              final result = await showDialog(context: context, builder: (context) => FilterDialog());

                              if (result != null) {
                                _storageBloc.add(FilterStorageEvent(widget.pageType, result));
                              }

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
                        ),
                      ],
                    ))
              ]);
            }
          },
        ),
      ),
    );
  }

  void _unselectItems() {
    _selectedItemsStreamController.add(0);
    _selectedEntities.clear();
  }
}
