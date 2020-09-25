import 'dart:math';

import 'package:extended_theme/extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiselect_scope/multiselect_scope.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/util/time_displayer.dart';
import 'package:stopwatch/view/pages/history_page.dart';

import '../theme_data.dart';

class StopwatchItem extends StatefulWidget {
  final BaseStopwatchEntity entity;
  final int index;
  //final ValueChanged<Tuple2<BaseStopwatchEntity, bool>> selectedEvent;
  //final StreamController<int> selectionListController;

  // Сделать данный класс Generic ?
  const StopwatchItem({Key key, this.entity, this.index}) : super(key: key);

  @override
  _StopwatchItemState createState() {
    return _StopwatchItemState();
  }
}

class _StopwatchItemState extends State<StopwatchItem>
    with AutomaticKeepAliveClientMixin {
  //bool isSelected = false;
  //bool anybodySelected = false;

  @override
  void initState() {
    super.initState();
    _init();

    debugPrint("initState ${widget.key}");
    // TODO initState заново вызывается при прокрутке, нужно где-то хранить состояние выделенных элементов (Статический кэш)??
    // TODO С wantKeepAlive = true кэш не нужен
  }

  @override
  void reassemble() {
    super.reassemble();
    //_init();
  }

  _init() {
    // widget.selectionListController.stream.asBroadcastStream().listen((event) {
    //   if (event == 0) {
    //     if (this.mounted) {
    //       this.setState(() {
    //         isSelected = false;
    //         anybodySelected = false;
    //       });
    //     }
    //   }
    //   else{
    //     if (this.mounted) {
    //       this.setState(() {
    //         anybodySelected = true;
    //       });
    //     }
    //   }
    // });
  }

  static Random r = Random(42);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    debugPrint("buildState ${widget.key}");

    final entityIsMeasure = widget.entity is MeasureViewModel;

    final difference =
        !entityIsMeasure ? (widget.entity as LapViewModel).difference : null;
    final elapsed = entityIsMeasure
        ? (widget.entity as MeasureViewModel).elapsed
        : (widget.entity is LapViewModel)
            ? (widget.entity as LapViewModel).overall
            : 0;

    final elapsedString =
        TimeDisplayer.formatAllBeautiful(Duration(milliseconds: elapsed));
    final differenceString = difference != null
        ? "+${TimeDisplayer.formatAllBeautiful(Duration(milliseconds: difference))}"
        : null;

    final date = entityIsMeasure
        ? (widget.entity as MeasureViewModel).dateStarted
        : null;

    final controller =
        MultiselectScope.of(context); //MultiselectScope.of(context);

    final itemIsSelected = controller.indexIsSelected(widget.index);

    return InkWell(
      onLongPress: () => {
        if (mounted)
          {
            if (!controller.selectionAttached) {controller.select(widget.index)}
          }
      },
      onTap: () => {
        if (controller.selectionAttached)
          {
            if (mounted) {controller.select(widget.index)}
          }
        else if (widget.entity.runtimeType == MeasureViewModel)
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return HistoryPage(
                  pageType: LapViewModel, entityId: widget.entity);
            }))
          }
      },
      child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: itemIsSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              !entityIsMeasure
                  ? SizedBox(
                      width: 32,
                      child: Text(
                        "${(widget.entity as LapViewModel).order.toString()}. ",
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.0,
                        ),
                      ),
                    )
                  : SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (difference != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(differenceString,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.0,
                          )),
                    ),
                  Text(elapsedString,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.0,
                          color: entityIsMeasure
                              ? Theme.of(context).textTheme.bodyText1.color
                              : ExtentedThemeProvider.of<AppTheme>(context)
                                  .theme
                                  .subtitleColor)),
                  SizedBox(height: 6),
                  widget.entity.comment != null
                      ? Text(
                          widget.entity.comment, // ?? "Нет комментария",
                          style: TextStyle(
                              fontSize: 18,
                              height: 1.0,
                              color: widget.entity.comment == null
                                  ? ExtentedThemeProvider.of<AppTheme>(context)
                                      .theme
                                      .subtitleColor
                                  : Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .color),
                        )
                      : SizedBox(),
                  SizedBox(height: 0),
                  date != null
                      ? Text(
                          TimeDisplayer.formatDate(date, context: context),
                          style: TextStyle(
                              color: ExtentedThemeProvider.of<AppTheme>(context)
                                  .theme
                                  .subtitleColor),
                        )
                      : SizedBox()
                ],
              ),
            ],
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
