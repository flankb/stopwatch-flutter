import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/view/pages/entity_edit_page.dart';
import 'package:learnwords/view/pages/history_page.dart';
import 'package:tuple/tuple.dart';

class StopwatchItem extends StatefulWidget {
  final BaseStopwatchEntity entity;
  final ValueChanged<Tuple2<BaseStopwatchEntity, bool>> selectedEvent;
  final StreamController<int> selectionListController;

  const StopwatchItem({Key key, this.entity, this.selectedEvent, this.selectionListController}) : super(key: key);

  @override
  _StopwatchItemState createState() {
    return _StopwatchItemState();
  }
}

class _StopwatchItemState extends State<StopwatchItem> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _init();

    debugPrint("initState ${widget.key}");
  }

  @override
  void reassemble() {
    super.reassemble();
    //_init();
  }

  _init(){
    widget.selectionListController.stream.asBroadcastStream().listen((event) {
      if (event == 0) {
        this.setState(() {
          isSelected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("buildState ${widget.key}");

    return InkWell(
      onLongPress: () => {
        this.setState(() {
            isSelected = !isSelected;
            widget.selectedEvent(Tuple2(widget.entity, isSelected));
        })

        /* Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return EntityEditPage(entityType: widget.entity.runtimeType, entityId: widget.entity.id);
        }))*/
      },
      onTap: () => {
        if (widget.entity.runtimeType == MeasureViewModel)
          {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return HistoryPage(pageType: LapViewModel, entityId: widget.entity.id);
            }))
          }
      },
      child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          color: isSelected ? Colors.deepOrange : Colors.transparent,
          child: Text(
            widget.entity.comment ?? "Нет комментария",
            style: TextStyle(fontSize: 18),
          )),
    );
  }
}