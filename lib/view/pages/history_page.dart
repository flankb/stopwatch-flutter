import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get_it/get_it.dart';
import 'package:share/share.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';
import 'package:stopwatch/fake/fake_data_fabric.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/filter.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/service_locator.dart';
import 'package:stopwatch/util/csv_exporter.dart';
import 'package:stopwatch/util/time_displayer.dart';
import 'package:stopwatch/view/dialogs/filter_dialog.dart';
import 'package:stopwatch/widgets/buttons_bar.dart';
import 'package:stopwatch/widgets/circular.dart';
import 'package:stopwatch/widgets/inherited/app_theme_notified.dart';
import 'package:stopwatch/widgets/metro_app_bar.dart';
import 'package:stopwatch/widgets/pair_label_view.dart';
import 'package:stopwatch/widgets/stopwatch_item_widget.dart';
import 'package:preferences/preferences.dart';
import 'package:toast/toast.dart';

import 'entity_edit_page.dart';

class HistoryPage extends StatefulWidget {
  final Type pageType;
  final BaseStopwatchEntity entityId;

  HistoryPage({Key key, this.pageType, this.entityId}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  StorageBloc _storageBloc;
  StreamController _selectedItemsStreamController;
  List<BaseStopwatchEntity> _selectedEntities = List<BaseStopwatchEntity>();

  Duration duration = Duration(milliseconds: 800);
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(vsync: this, duration: duration);
    animation = Tween<double>(begin: 0.5, end: 1.0)
        .animate(animationController); //ColorTween(begin: beginColor, end: endColor).animate(controller);

    _storageBloc =
        GetIt.I.get<StorageBloc>(instanceName: widget.pageType == MeasureViewModel ? MeasuresBloc : LapsBloc);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //animationController.reverse();
      }
    });

    animationController.forward();
    //animationController.forward();

    _selectedItemsStreamController = StreamController<int>.broadcast();
    // https://github.com/felangel/bloc/issues/74
    // https://github.com/felangel/bloc/blob/master/packages/flutter_bloc/README.md

    debugPrint("History page: Init state");

    // Инициализировать фильтр
    var wasFiltered = false;
    Filter previousFilter;

    debugPrint("${_storageBloc.state}");

    if (_storageBloc.state is AvailableListState) {
      final availState = _storageBloc.state as AvailableListState;
      wasFiltered = availState.filtered;
      previousFilter = availState.lastFilter;

      debugPrint("Last filter: $previousFilter");

      // Здесь сбрасываем состояние
      _storageBloc.add(ClearStorageEvent());
    }

    _storageBloc.add(
        LoadStorageEvent(widget.pageType, measureId: widget.entityId?.id)); // TODO Более явно перезагружать состояние?

    // Сразу же отфильтруем в случае необходимости
    if (wasFiltered) {
      _storageBloc.add(FilterStorageEvent(widget.pageType, previousFilter));
    }
  }

  @override
  void dispose() {
    //animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("buildState HistoryPage");

    // Множественное выделение:
    // https://medium.com/flutterdevs/selecting-multiple-item-in-list-in-flutter-811a3049c56f
    // В данной статье интересный подход, где каждый элемент является Stateful виджетом
    // Статья про эффективное использование BLoC
    // https://medium.com/flutterpub/effective-bloc-pattern-45c36d76d5fe
    return BlocProvider.value(
      /*create: (BuildContext context) {
        return _storageBloc;
      },*/
      value: _storageBloc,
      child: Scaffold(
        // Вариант:
        //https://stackoverflow.com/questions/53733548/dynamic-appbar-of-flutter
        body: SafeArea(
          child: BlocBuilder<StorageBloc, StorageState>(
            builder: (BuildContext context, state) {
              if (!(state is AvailableListState)) {
                return CenterCircularWidget();
              } else {
                final availState = state as AvailableListState;
                final pageIsLap = widget.pageType == LapViewModel;

                final overallElapsed = pageIsLap
                    ? TimeDisplayer.formatAllBeautifulFromMills((widget.entityId as MeasureViewModel).elapsed)
                    : "";
                final comment = pageIsLap ? (widget.entityId as MeasureViewModel).comment : "";
                final createDate = pageIsLap
                    ? TimeDisplayer.formatDate((widget.entityId as MeasureViewModel).dateStarted, context: context)
                    : "";

                final existsMeasures = availState.entities.any((element) => true);

                // TODO Анимашка
                // https://github.com/flutter/samples/blob/master/animations/lib/src/basics/05_animated_builder.dart
                return Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Заголовок
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          BackButton(),
                          Text(
                            pageIsLap ? S.of(context).details : S.of(context).measures,
                            style: TextStyle(fontSize: 36),
                          )
                        ],
                      ),

                      pageIsLap
                          ? AnimatedBuilder(
                              animation: animation,
                              builder: (context, snapshot) {
                                return Transform.scale(
                                  scale: animation.value,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            PairLabelView(
                                              caption: S.of(context).overall_time,
                                              value: overallElapsed,
                                            ),
                                            PairLabelView(
                                              caption: S.of(context).comment,
                                              value: comment ?? "",
                                            ),
                                            PairLabelView(
                                              caption: S.of(context).date_created,
                                              value: createDate,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : SizedBox(),

                      if (pageIsLap && availState.entities.any((element) => true))
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                S.of(context).laps,
                                style: TextStyle(fontSize: 22),
                              )),
                        ),

                      existsMeasures
                          ? Expanded(
                              child: Container(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: ListView.separated(
                                    physics: ClampingScrollPhysics(),
                                    itemCount: availState.entities.length + 1,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (index < availState.entities.length) {
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
                                      } else {
                                        return PurchaseBanner();
                                      }
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return Divider(
                                        height: 0,
                                      );
                                    },
                                  )),
                            )
                          : widget.pageType == MeasureViewModel
                              ? Expanded(
                                  child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    S.of(context).no_measures,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: InheritedThemeNotifier.of(context).themeData.subtitleColor,
                                        fontSize: 18),
                                  ),
                                ))
                              : SizedBox(),

                      StreamBuilder<int>(
                          stream: _selectedItemsStreamController.stream,
                          initialData: 0,
                          builder: (context, snapshot) {
                            if (snapshot.data != 1 && pageIsLap) {
                              return SizedBox();
                            } else {
                              return MetroAppBar(
                                primaryCommands: <Widget>[
                                  widget.pageType == MeasureViewModel
                                      ? _exportToCsvButtonPrimary(context, existsMeasures)
                                      : SizedBox(),
                                  widget.pageType == MeasureViewModel
                                      ? _exportToCsvButtonPrimary(context, existsMeasures, shareMode: ShareMode.File)
                                      : SizedBox(),
                                  snapshot.data == 1
                                      ? PrimaryCommand(
                                          onPressed: () async {
                                            final entityToEdit = _selectedEntities.single;

                                            await Navigator.push(context,
                                                MaterialPageRoute(builder: (BuildContext context) {
                                              return EntityEditPage(
                                                entityType: widget.pageType,
                                                entityId: entityToEdit.id,
                                                entity: entityToEdit,
                                              );
                                            }));

                                            _unselectItems();
                                          },
                                          pic: Icons.edit,
                                          tooltip: S.of(context).edit_app_bar,
                                        )
                                      : SizedBox(),
                                  snapshot.data >= 1 && widget.pageType == MeasureViewModel
                                      ? PrimaryCommand(
                                          tooltip: S.of(context).del_app_bar,
                                          pic: Icons.delete,
                                          onPressed: () {
                                            if (widget.pageType == LapViewModel) {
                                              Toast.show(S.of(context).no_possible_delete_laps, context,
                                                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                                              return;
                                            }

                                            final entitiesForDelete = List<BaseStopwatchEntity>();
                                            entitiesForDelete.addAll(_selectedEntities);
                                            _unselectItems();
                                            _storageBloc.add(DeleteStorageEvent(entitiesForDelete));
                                          },
                                        )
                                      : SizedBox(),
                                ],
                                secondaryCommands: <SecondaryCommand>[],
                              );
                            }
                          })
                    ],
                  ),
                  StreamBuilder<int>(
                      initialData: 0,
                      stream: _selectedItemsStreamController.stream,
                      builder: (context, snapshot) {
                        return Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: snapshot.data != 1 && pageIsLap ? 12 : 62, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  availState.filtered
                                      ? RawMaterialButton(
                                          child: Icon(Icons.clear),
                                          onPressed: () {
                                            _storageBloc.add(CancelFilterEvent(widget.pageType));
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                          elevation: 2.0,
                                          fillColor: Theme.of(context).bottomAppBarColor,
                                          padding: const EdgeInsets.all(5.0),
                                        )
                                      : SizedBox(),
                                  availState.filtered
                                      ? SizedBox(
                                          width: 12,
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 62,
                                    height: 62,
                                    child: RawMaterialButton(
                                      onPressed: () async {
                                        debugPrint("Last filter in history page ${availState.lastFilter}");
                                        final result = await showDialog(
                                            context: context,
                                            builder: (context) => FilterDialog(
                                                  filter: availState.lastFilter,
                                                ));

                                        if (result != null) {
                                          _storageBloc.add(FilterStorageEvent(widget.pageType, result));
                                        }
                                      },
                                      child: Padding(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.filter_list,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                                      ),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(31.0)),
                                      elevation: 6.0,
                                      fillColor: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }),
                ]);
              }
            },
          ),
        ),
      ),
    );
  }

  PrimaryCommand _exportToCsvButtonPrimary(BuildContext context, bool enabled,
      {ShareMode shareMode = ShareMode.Email}) {
    final icon = shareMode == ShareMode.Email ? Icons.share : Icons.insert_drive_file;
    final tooltip = shareMode == ShareMode.Email ? S.of(context).share_app_bar : S.of(context).to_csv_app_bar;
    final command = () async {
      var entitiesToExport = _selectedEntities;

      if (!entitiesToExport.any((element) => true)) {
        entitiesToExport = (BlocProvider.of<StorageBloc>(context).state as AvailableListState).entities;
      }

      final csv =
          await GetIt.I.get<CsvExporter>().convertToCsv(entitiesToExport.map((e) => e as MeasureViewModel).toList());
      _unselectItems();

      switch (shareMode) {
        case ShareMode.Email:
          await _share(csv);
          break;
        case ShareMode.File:
          await GetIt.I.get<CsvExporter>().shareFile(csv);
          break;
      }
    };

    return PrimaryCommand(
      tooltip: tooltip,
      pic: icon,
      onPressed: enabled ? command : null,
    );
  }

  /*_sendEmail(String body) async {
    // Вычислим адрес из настроек
    final emailAddress = PrefService.getString('email');

    final Email email = Email(
      body: body,
      subject: 'Измерения от ${DateTime.now()}',
      recipients: [emailAddress],
      //cc: ['cc@example.com'],
      //bcc: ['bcc@example.com'],
      //attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }*/

  _share(String body) {
    Share.share(body, subject: '${S.current.measures} ${DateTime.now()}');
  }

  void _unselectItems() {
    _selectedItemsStreamController.add(0);
    _selectedEntities.clear();
  }
}

class PurchaseBanner extends StatelessWidget {
  const PurchaseBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        //height: 150,
        child: Card(
          color: Colors.yellow,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Column(
              children: [
                Text(
                    "В обычной версии можно хранить только три измерения! "
                        "Приобретите Pro-пакет, чтобы снять ограничение. Стоимость 49 руб.",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                Align(
                  alignment: Alignment.centerRight,
                  child: RawMaterialButton(onPressed: () {

                  },
                    fillColor: Colors.black,
                    child: Text("Купить",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ShareMode { Email, File }

class ExportToCsvButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
