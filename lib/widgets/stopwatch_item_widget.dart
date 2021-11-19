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

  // Сделать данный класс Generic ?
  const StopwatchItem({
    required this.entity,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  _StopwatchItemState createState() => _StopwatchItemState();
}

class _StopwatchItemState extends State<StopwatchItem>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    debugPrint('initState ${widget.key}');
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    debugPrint('buildState ${widget.key}');

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
        ? '+${TimeDisplayer.formatAllBeautiful(Duration(milliseconds: difference))}'
        : null;

    final date = entityIsMeasure
        ? (widget.entity as MeasureViewModel).dateStarted
        : null;

    final controller =
        MultiselectScope.controllerOf(context); //MultiselectScope.of(context);

    final itemIsSelected = controller.isSelected(widget.index);

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
            Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HistoryPage(
                  pageType: LapViewModel,
                  entityId: widget.entity,
                ),
              ),
            )
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
              if (!entityIsMeasure)
                SizedBox(
                  width: 32,
                  child: Text(
                    '${(widget.entity as LapViewModel).order.toString()}. ',
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1,
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (difference != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        differenceString!,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1,
                        ),
                      ),
                    ),
                  Text(
                    elapsedString,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1,
                      color: entityIsMeasure
                          ? Theme.of(context).textTheme.bodyText1!.color
                          : ThemeHolder.of<AppTheme>(context)
                              .theme
                              .subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (widget.entity.comment != null)
                    Text(
                      widget.entity.comment ??
                          'Нет комментария', // ?? "Нет комментария",
                      style: TextStyle(
                        fontSize: 18,
                        height: 1,
                        color: widget.entity.comment == null
                            ? ThemeHolder.of<AppTheme>(context)
                                .theme
                                .subtitleColor
                            : Theme.of(context).textTheme.subtitle2!.color,
                      ),
                    ),
                  const SizedBox(height: 0),
                  if (date != null)
                    Text(
                      TimeDisplayer.formatDate(date, context: context),
                      style: TextStyle(
                        color: ThemeHolder.of<AppTheme>(context)
                            .theme
                            .subtitleColor,
                      ),
                    )
                ],
              ),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
