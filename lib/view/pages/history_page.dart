import 'package:extended_theme/extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:metro_appbar/metro_appbar.dart';
import 'package:multiselect_scope/multiselect_scope.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/models/filter.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/service_locator.dart';
import 'package:stopwatch/theme_data.dart';
import 'package:stopwatch/util/csv_exporter.dart';
import 'package:stopwatch/util/time_displayer.dart';
import 'package:stopwatch/view/dialogs/filter_dialog.dart';
import 'package:stopwatch/widgets/circular.dart';
import 'package:stopwatch/widgets/pair_label_view.dart';
import 'package:stopwatch/widgets/stopwatch_item_widget.dart';
import 'entity_edit_page.dart';

class HistoryPage extends StatefulWidget {
  final Type pageType;
  final BaseStopwatchEntity? entityId;

  HistoryPage({Key? key, required this.pageType, required this.entityId})
      : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late StorageBloc _storageBloc;
  //StreamController _selectedItemsStreamController;
  List<BaseStopwatchEntity> _selectedEntities = <BaseStopwatchEntity>[];

  Duration duration = Duration(milliseconds: 800);
  late AnimationController animationController;
  late Animation<double> animation;

  late MultiselectController _multiselectController;

  @override
  void initState() {
    super.initState();

    _multiselectController = MultiselectController();

    animationController = AnimationController(duration: duration, vsync: this);
    animation = Tween<double>(begin: 0.5, end: 1.0).animate(
        animationController); //ColorTween(begin: beginColor, end: endColor).animate(controller);

    _storageBloc = GetIt.I.get<StorageBloc>(
        instanceName:
            widget.pageType == MeasureViewModel ? MeasuresBloc : LapsBloc);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //animationController.reverse();
      }
    });

    animationController.forward();

    //_selectedItemsStreamController = StreamController<int>.broadcast();
    // https://github.com/felangel/bloc/issues/74
    // https://github.com/felangel/bloc/blob/master/packages/flutter_bloc/README.md

    debugPrint("History page: Init state");

    // Инициализировать фильтр
    var wasFiltered = false;
    Filter? previousFilter;

    debugPrint("${_storageBloc.state}");

    if (_storageBloc.state is AvailableListState) {
      final availState = _storageBloc.state as AvailableListState;
      wasFiltered = availState.filtered;
      previousFilter = availState.lastFilter;

      debugPrint("Last filter: $previousFilter");

      // Здесь сбрасываем состояние
      _storageBloc.add(ClearStorageEvent());
    }

    _storageBloc.add(LoadStorageEvent(widget.pageType,
        measureId: widget.entityId?.id ??
            null)); // TODO Более явно перезагружать состояние?

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
      value: _storageBloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<StorageBloc, StorageState>(
            builder: (BuildContext context, state) {
              if (!(state is AvailableListState)) {
                return CenterCircularWidget();
              } else {
                final availState = state;
                final pageIsLap = widget.pageType == LapViewModel;

                final overallElapsed = pageIsLap
                    ? TimeDisplayer.formatAllBeautifulFromMills(
                        (widget.entityId as MeasureViewModel).elapsed)
                    : "";
                final comment = pageIsLap
                    ? (widget.entityId as MeasureViewModel).comment
                    : "";
                final createDate = pageIsLap
                    ? TimeDisplayer.formatDate(
                        (widget.entityId as MeasureViewModel).dateStarted!,
                        context: context)
                    : "";

                final existsMeasures =
                    availState.entities.any((element) => true);

                return MultiselectScope<BaseStopwatchEntity>(
                  //itemsCount: availState.entities.length,
                  dataSource: availState.entities,
                  clearSelectionOnPop: true,
                  controller: _multiselectController,
                  onSelectionChanged: (indexes, items) {
                    debugPrint("Custom listener invoked! $indexes");
                    _selectedEntities = items;
                    // _multiselectController
                    //     .getSelectedItems(availState.entities);
                  },
                  child: Builder(builder: (context) {
                    debugPrint("build GreatMultiselect builder");
                    return Stack(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Заголовок
                          PageCaption(
                              caption: pageIsLap
                                  ? S.of(context).details
                                  : S.of(context).measures),
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
                                                  caption: S
                                                      .of(context)
                                                      .overall_time,
                                                  value: overallElapsed,
                                                ),
                                                PairLabelView(
                                                  caption:
                                                      S.of(context).comment,
                                                  value: comment ?? "",
                                                ),
                                                PairLabelView(
                                                  caption: S
                                                      .of(context)
                                                      .date_created,
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

                          if (pageIsLap &&
                              availState.entities.any((element) => true))
                            LapsCaption(),

                          existsMeasures
                              ? ListOfMeasures(availState: availState)
                              : widget.pageType == MeasureViewModel
                                  ? MessageNoMeasures()
                                  : SizedBox(),

                          MultiselectScope.controllerOf(context)
                                          .selectedIndexes
                                          .length !=
                                      1 &&
                                  pageIsLap
                              ? SizedBox()
                              : MetroAppBar(
                                  height: 60,
                                  primaryCommands: <Widget>[
                                    widget.pageType == MeasureViewModel
                                        ? _exportToCsvButtonPrimary(
                                            context, existsMeasures)
                                        : SizedBox(),
                                    widget.pageType == MeasureViewModel
                                        ? _exportToCsvButtonPrimary(
                                            context, existsMeasures,
                                            shareMode: ShareMode.File)
                                        : SizedBox(),
                                    MultiselectScope.controllerOf(context)
                                                .selectedIndexes
                                                .length ==
                                            1
                                        ? PrimaryCommand(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color,
                                            onPressed: () async {
                                              final entityToEdit =
                                                  _selectedEntities.single;

                                              await Navigator.push(context,
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return EntityEditPage(
                                                  entityType: widget.pageType,
                                                  entityId: entityToEdit.id!,
                                                  entity: entityToEdit,
                                                );
                                              }));

                                              _unselectItems(context);
                                            },
                                            icon: Icons.edit,
                                            text: S.of(context).edit_app_bar,
                                          )
                                        : SizedBox(),
                                    MultiselectScope.controllerOf(context)
                                                    .selectedIndexes
                                                    .length >=
                                                1 &&
                                            widget.pageType == MeasureViewModel
                                        ? PrimaryCommand(
                                            text: S.of(context).del_app_bar,
                                            icon: Icons.delete,
                                            onPressed: () {
                                              if (widget.pageType ==
                                                  LapViewModel) {
                                                Fluttertoast.showToast(
                                                  msg: S
                                                      .of(context)
                                                      .no_possible_delete_laps,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );

                                                return;
                                              }

                                              final entitiesForDelete =
                                                  <BaseStopwatchEntity>[];
                                              entitiesForDelete
                                                  .addAll(_selectedEntities);
                                              _unselectItems(context);
                                              _storageBloc.add(
                                                  DeleteStorageEvent(
                                                      entitiesForDelete));
                                            },
                                          )
                                        : SizedBox(),
                                  ],
                                  secondaryCommands: <SecondaryCommand>[],
                                ),
                        ],
                      ),
                      FilterButtons(
                          pageIsLap: pageIsLap,
                          availState: availState,
                          storageBloc: _storageBloc,
                          pageType: widget.pageType)
                    ]);
                  }),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  PrimaryCommand _exportToCsvButtonPrimary(BuildContext context, bool enabled,
      {ShareMode shareMode = ShareMode.Email}) {
    final icon =
        shareMode == ShareMode.Email ? Icons.share : Icons.insert_drive_file;
    final tooltip = shareMode == ShareMode.Email
        ? S.of(context).share_app_bar
        : S.of(context).to_csv_app_bar;
    final command = () async {
      var entitiesToExport = _selectedEntities;

      if (!entitiesToExport.any((element) => true)) {
        entitiesToExport =
            (BlocProvider.of<StorageBloc>(context).state as AvailableListState)
                .entities;
      }

      final exporter = GetIt.I.get<MeasuresExporter>();
      final entities =
          entitiesToExport.map((e) => e as MeasureViewModel).toList();

      final csv = shareMode == ShareMode.Email
          ? await exporter.convertToPlain(entities)
          : await exporter.convertToCsv(entities);
      _unselectItems(context);

      switch (shareMode) {
        case ShareMode.Email:
          await _share(csv);
          break;
        case ShareMode.File:
          await GetIt.I.get<MeasuresExporter>().shareFile(csv);
          break;
      }
    };

    return PrimaryCommand(
      text: tooltip,
      icon: icon,
      color: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: enabled ? command : () {},
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

  void _unselectItems(BuildContext context) {
    MultiselectScope.controllerOf(context).clearSelection();
  }
}

class LapsCaption extends StatelessWidget {
  const LapsCaption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).laps,
            style: TextStyle(fontSize: 22),
          )),
    );
  }
}

class ListOfMeasures extends StatelessWidget {
  const ListOfMeasures({
    Key? key,
    required this.availState,
  }) : super(key: key);

  final AvailableListState availState;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.only(top: 6),
          child: ListView.separated(
            physics: ClampingScrollPhysics(),
            itemCount: availState.entities.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < availState.entities.length) {
                BaseStopwatchEntity entity = availState.entities[index];
                final key = PageStorageKey<String>("entity_$index");

                return StopwatchItem(key: key, entity: entity, index: index);
              } else {
                return SizedBox.shrink();
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 0,
              );
            },
          )),
    );
  }
}

class MessageNoMeasures extends StatelessWidget {
  const MessageNoMeasures({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        S.of(context).no_measures,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: ThemeHolder.themeOf<AppTheme>(context).subtitleColor,
            fontSize: 18),
      ),
    ));
  }
}

class FilterButtons extends StatelessWidget {
  const FilterButtons({
    Key? key,
    required this.pageIsLap,
    required this.availState,
    required StorageBloc storageBloc,
    required this.pageType,
  })  : _storageBloc = storageBloc,
        super(key: key);

  final bool pageIsLap;
  final AvailableListState availState;
  final StorageBloc _storageBloc;
  final Type pageType;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MultiselectScope.controllerOf(context)
                              .selectedIndexes
                              .length !=
                          1 &&
                      pageIsLap
                  ? 12
                  : 62,
              right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              availState.filtered
                  ? RawMaterialButton(
                      child: Icon(Icons.clear),
                      onPressed: () {
                        _storageBloc.add(CancelFilterEvent(pageType));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
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
                    //getIt.get<PurchaserBloc>().queryPurchases(filterIds : {PRO_PACKAGE});

                    debugPrint(
                        "Last filter in history page ${availState.lastFilter}");
                    final result = await showDialog(
                        context: context,
                        builder: (context) => FilterDialog(
                              entityType: pageType,
                              filter: availState.lastFilter ??
                                  Filter.defaultFilter(),
                            ));

                    if (result != null) {
                      _storageBloc.add(FilterStorageEvent(pageType, result));
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(31.0)),
                  elevation: 6.0,
                  fillColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ));
  }
}

class PageCaption extends StatelessWidget {
  const PageCaption({
    Key? key,
    required this.caption,
  }) : super(key: key);

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          BackButton(),
          Text(
            caption,
            style: TextStyle(fontSize: 36),
          )
        ],
      ),
    );
  }
}

class PurchaseBanner extends StatelessWidget {
  const PurchaseBanner({
    Key? key,
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
                  S.current.purchase_banner,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RawMaterialButton(
                    onPressed: () {
                      //getIt.get<PurchaserBloc>().requestPurchase(PRO_PACKAGE);
                    },
                    fillColor: const Color(0xFF3e403f),
                    child: Text(S.current.purchase,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
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
