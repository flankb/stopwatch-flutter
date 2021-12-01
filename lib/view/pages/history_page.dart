import 'package:extended_theme/extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:metro_appbar/metro_appbar.dart';
import 'package:multiselect_scope/multiselect_scope.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/models/filter.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/theme_data.dart';
import 'package:stopwatch/util/csv_exporter.dart';
import 'package:stopwatch/util/time_displayer.dart';
import 'package:stopwatch/view/dialogs/filter_dialog.dart';
import 'package:stopwatch/widgets/circular.dart';
import 'package:stopwatch/widgets/inherited/storage_blocs_provider.dart';
import 'package:stopwatch/widgets/pair_label_view.dart';
import 'package:stopwatch/widgets/stopwatch_item_widget.dart';
import 'entity_edit_page.dart';

class HistoryPage extends StatefulWidget {
  final Type pageType;
  final BaseStopwatchEntity? entityId;

  const HistoryPage({
    required this.pageType,
    required this.entityId,
    Key? key,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late StorageBloc _storageBloc;
  bool loaded = false;
  List<BaseStopwatchEntity> _selectedEntities = <BaseStopwatchEntity>[];

  Duration duration = const Duration(milliseconds: 800);
  late AnimationController animationController;
  late Animation<double> animation;

  late MultiselectController _multiselectController;

  void _initStorage() {
    final storageBlocsProvider = StorageBlocsProvider.of(context);

    _storageBloc = widget.pageType == MeasureViewModel
        ? storageBlocsProvider.measuresBloc
        : storageBlocsProvider.lapsBloc;

    //_selectedItemsStreamController = StreamController<int>.broadcast();
    // https://github.com/felangel/bloc/issues/74
    // https://github.com/felangel/bloc/blob/master/packages/flutter_bloc/README.md

    debugPrint('History page: Init state');

    // Инициализировать фильтр
    var wasFiltered = false;
    Filter? previousFilter;

    debugPrint('${_storageBloc.state}');

    if (_storageBloc.state is AvailableListState) {
      final availState = _storageBloc.state as AvailableListState;
      wasFiltered = availState.filtered;
      previousFilter = availState.lastFilter;

      debugPrint('Last filter: $previousFilter');

      // Здесь сбрасываем состояние
      _storageBloc.add(ClearStorageEvent());
    }

    _storageBloc.add(
      LoadStorageEvent(widget.pageType, measureId: widget.entityId?.id),
    );

    // Сразу же отфильтруем в случае необходимости
    if (wasFiltered) {
      _storageBloc.add(FilterStorageEvent(widget.pageType, previousFilter));
    }

    loaded = true;
  }

  @override
  void initState() {
    super.initState();

    _multiselectController = MultiselectController();

    animationController = AnimationController(duration: duration, vsync: this);
    animation = Tween<double>(begin: 0.5, end: 1).animate(
      animationController,
    );

    animationController
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //animationController.reverse();
        }
      })
      ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!loaded) {
      _initStorage();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('buildState HistoryPage');

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
              if (state is! AvailableListState) {
                return const CenterCircularWidget();
              } else {
                final availState = state;
                final pageIsLap = widget.pageType == LapViewModel;

                final overallElapsed = pageIsLap
                    ? formatAllBeautifulFromMills(
                        (widget.entityId as MeasureViewModel?)?.elapsed ?? 0,
                      )
                    : '';
                final comment = pageIsLap
                    ? (widget.entityId as MeasureViewModel?)?.comment ?? ''
                    : '';
                final createDate = pageIsLap
                    ? formatDate(
                        (widget.entityId as MeasureViewModel?)!.dateStarted!,
                        context: context,
                      )
                    : '';

                final existsMeasures =
                    availState.entities.any((element) => true);

                return MultiselectScope<BaseStopwatchEntity>(
                  dataSource: availState.entities,
                  clearSelectionOnPop: true,
                  controller: _multiselectController,
                  onSelectionChanged: (indexes, items) {
                    debugPrint('Custom listener invoked! $indexes');
                    _selectedEntities = items;
                  },
                  child: Builder(
                    builder: (context) {
                      debugPrint('build GreatMultiselect builder');
                      return Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Заголовок
                              PageCaption(
                                caption: pageIsLap
                                    ? S.of(context).details
                                    : S.of(context).measures,
                              ),
                              if (pageIsLap)
                                AnimatedBuilder(
                                  animation: animation,
                                  builder: (context, snapshot) =>
                                      Transform.scale(
                                    scale: animation.value,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: <Widget>[
                                              PairLabelView(
                                                caption:
                                                    S.of(context).overall_time,
                                                value: overallElapsed,
                                              ),
                                              PairLabelView(
                                                caption: S.of(context).comment,
                                                value: comment,
                                              ),
                                              PairLabelView(
                                                caption:
                                                    S.of(context).date_created,
                                                value: createDate,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              if (pageIsLap &&
                                  availState.entities.any((element) => true))
                                const LapsCaption(),

                              if (existsMeasures)
                                ListOfMeasures(availState: availState)
                              else
                                widget.pageType == MeasureViewModel
                                    ? const MessageNoMeasures()
                                    : const SizedBox(),

                              if (MultiselectScope.controllerOf(context)
                                          .selectedIndexes
                                          .length !=
                                      1 &&
                                  pageIsLap)
                                const SizedBox()
                              else
                                MetroAppBar(
                                  height: 60,
                                  primaryCommands: <Widget>[
                                    if (widget.pageType == MeasureViewModel)
                                      _exportToCsvButtonPrimary(
                                        context,
                                        existsMeasures,
                                      )
                                    else
                                      const SizedBox(),
                                    if (widget.pageType == MeasureViewModel)
                                      _exportToCsvButtonPrimary(
                                        context,
                                        existsMeasures,
                                        shareMode: ShareMode.file,
                                      )
                                    else
                                      const SizedBox(),
                                    if (MultiselectScope.controllerOf(context)
                                            .selectedIndexes
                                            .length ==
                                        1)
                                      PrimaryCommand(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                        onPressed: () async {
                                          final entityToEdit =
                                              _selectedEntities.single;

                                          _unselectItems(context);

                                          await Navigator.push<void>(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EntityEditPage(
                                                entityType: widget.pageType,
                                                entityId: entityToEdit.id!,
                                                entity: entityToEdit,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icons.edit,
                                        text: S.of(context).edit_app_bar,
                                      )
                                    else
                                      const SizedBox(),
                                    if (MultiselectScope.controllerOf(context)
                                            .selectedIndexes
                                            .isNotEmpty &&
                                        widget.pageType == MeasureViewModel)
                                      PrimaryCommand(
                                        text: S.of(context).del_app_bar,
                                        icon: Icons.delete,
                                        onPressed: () {
                                          if (widget.pageType == LapViewModel) {
                                            Fluttertoast.showToast(
                                              msg: S
                                                  .of(context)
                                                  .no_possible_delete_laps,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                            );

                                            return;
                                          }

                                          final entitiesForDelete =
                                              <BaseStopwatchEntity>[
                                            ..._selectedEntities
                                          ];
                                          _unselectItems(context);
                                          _storageBloc.add(
                                            DeleteStorageEvent(
                                              entitiesForDelete,
                                            ),
                                          );
                                        },
                                      )
                                    else
                                      const SizedBox(),
                                  ],
                                  secondaryCommands: const <SecondaryCommand>[],
                                ),
                            ],
                          ),
                          FilterButtons(
                            pageIsLap: pageIsLap,
                            availState: availState,
                            storageBloc: _storageBloc,
                            pageType: widget.pageType,
                          )
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  PrimaryCommand _exportToCsvButtonPrimary(
    BuildContext context,
    bool enabled, {
    ShareMode shareMode = ShareMode.email,
  }) {
    final icon =
        shareMode == ShareMode.email ? Icons.share : Icons.insert_drive_file;
    final tooltip = shareMode == ShareMode.email
        ? S.of(context).share_app_bar
        : S.of(context).to_csv_app_bar;
    Future<void> command() async {
      var entitiesToExport = _selectedEntities;

      if (!entitiesToExport.any((element) => true)) {
        entitiesToExport =
            (BlocProvider.of<StorageBloc>(context).state as AvailableListState)
                .entities;
      }

      final exporter =
          MeasuresExporter(RepositoryProvider.of<StopwatchRepository>(context));
      final entities =
          entitiesToExport.map((e) => e as MeasureViewModel).toList();

      final csv = shareMode == ShareMode.email
          ? await exporter.convertToPlain(entities)
          : await exporter.convertToCsv(entities);
      _unselectItems(context);

      switch (shareMode) {
        case ShareMode.email:
          await _share(csv);
          break;
        case ShareMode.file:
          await exporter.shareFile(csv);
          break;
      }
    }

    return PrimaryCommand(
      text: tooltip,
      icon: icon,
      color: Theme.of(context).textTheme.bodyText1!.color,
      onPressed: enabled ? command : () {},
    );
  }

  Future<void> _share(String body) =>
      Share.share(body, subject: '${S.current.measures} ${DateTime.now()}');

  void _unselectItems(BuildContext context) {
    MultiselectScope.controllerOf(context).clearSelection();
  }
}

class LapsCaption extends StatelessWidget {
  const LapsCaption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).laps,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      );
}

class ListOfMeasures extends StatelessWidget {
  const ListOfMeasures({
    required this.availState,
    Key? key,
  }) : super(key: key);

  final AvailableListState availState;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.only(top: 6),
          child: ListView.separated(
            physics: const ClampingScrollPhysics(),
            itemCount: availState.entities.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < availState.entities.length) {
                final entity = availState.entities[index];
                final key = PageStorageKey<String>('entity_$index');

                return StopwatchItem(key: key, entity: entity, index: index);
              } else {
                return const SizedBox.shrink();
              }
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 0,
            ),
          ),
        ),
      );
}

class MessageNoMeasures extends StatelessWidget {
  const MessageNoMeasures({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            S.of(context).no_measures,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: ThemeHolder.themeOf<AppTheme>(context).subtitleColor,
              fontSize: 18,
            ),
          ),
        ),
      );
}

class FilterButtons extends StatelessWidget {
  const FilterButtons({
    required this.pageIsLap,
    required this.availState,
    required StorageBloc storageBloc,
    required this.pageType,
    Key? key,
  })  : _storageBloc = storageBloc,
        super(key: key);

  final bool pageIsLap;
  final AvailableListState availState;
  final StorageBloc _storageBloc;
  final Type pageType;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(
            bottom:
                MultiselectScope.controllerOf(context).selectedIndexes.length !=
                            1 &&
                        pageIsLap
                    ? 12
                    : 62,
            right: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (availState.filtered)
                RawMaterialButton(
                  onPressed: () {
                    _storageBloc.add(CancelFilterEvent(pageType));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                  fillColor: Theme.of(context).bottomAppBarColor,
                  padding: const EdgeInsets.all(5),
                  child: const Icon(Icons.clear),
                )
              else
                const SizedBox(),
              if (availState.filtered)
                const SizedBox(
                  width: 12,
                )
              else
                const SizedBox(),
              SizedBox(
                width: 62,
                height: 62,
                child: RawMaterialButton(
                  onPressed: () async {
                    debugPrint(
                      'Last filter in history page ${availState.lastFilter}',
                    );
                    final result = await showDialog<Filter>(
                      context: context,
                      builder: (context) => FilterDialog(
                        entityType: pageType,
                        filter: availState.lastFilter == Filter.empty()
                            ? Filter.defaultFilter()
                            : availState.lastFilter,
                      ),
                    );

                    if (result != null) {
                      _storageBloc.add(FilterStorageEvent(pageType, result));
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(31),
                  ),
                  elevation: 6,
                  fillColor: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class PageCaption extends StatelessWidget {
  const PageCaption({
    required this.caption,
    Key? key,
  }) : super(key: key);

  final String caption;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const BackButton(),
            Text(
              caption,
              style: const TextStyle(fontSize: 36),
            )
          ],
        ),
      );
}

class PurchaseBanner extends StatelessWidget {
  const PurchaseBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          //height: 150,
          child: Card(
            color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                children: [
                  Text(
                    S.current.purchase_banner,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RawMaterialButton(
                      onPressed: () {
                        //requestPurchase(PRO_PACKAGE);
                      },
                      fillColor: const Color(0xFF3e403f),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        S.current.purchase,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

enum ShareMode { email, file }

class ExportToCsvButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}
