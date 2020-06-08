import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/util/time_displayer.dart';
import 'package:learnwords/view/pages/entity_edit_page.dart';
import 'package:learnwords/view/pages/history_page.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

class StopwatchItem extends StatefulWidget {
  final BaseStopwatchEntity entity;
  final ValueChanged<Tuple2<BaseStopwatchEntity, bool>> selectedEvent;
  final StreamController<int> selectionListController;

  // Сделать данный класс Generic ?

  const StopwatchItem({Key key, this.entity, this.selectedEvent, this.selectionListController}) : super(key: key);

  @override
  _StopwatchItemState createState() {
    return _StopwatchItemState();
  }
}

class _StopwatchItemState extends State<StopwatchItem> with AutomaticKeepAliveClientMixin {
  bool isSelected = false;

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

  _init(){
    widget.selectionListController.stream.asBroadcastStream().listen((event) {
      if (event == 0) {
        this.setState(() {
          isSelected = false;
        });
      }
    });
  }

  static Random r = Random(42);

  @override
  Widget build(BuildContext context) {
    debugPrint("buildState ${widget.key}");

    final elapsed =  (widget.entity is MeasureViewModel)
        ? (widget.entity as MeasureViewModel).elapsed
        : (widget.entity is LapViewModel) ? (widget.entity as LapViewModel).difference : 0;

    final elapsedString = TimeDisplayer.formatAllBeautiful(Duration(milliseconds : elapsed));

    final date =  (widget.entity is MeasureViewModel)
        ?  (widget.entity as MeasureViewModel).dateCreated : null;

    final rand = r.nextInt(4);
    final num = pow(3, rand);

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 32,
                child: Text("${num.toString()}. ",
                style: TextStyle(fontSize: 18),),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.entity.comment ?? "Нет комментария",
                    style: TextStyle(fontSize: 18, color: widget.entity.comment == null ? Colors.black12 : Colors.black),
                  ),
                  SizedBox(height: 6),
                  Text(
                    elapsedString,
                      style: TextStyle(fontSize: 18)
                  ),
                  SizedBox(height: 3),
                  date != null ?
                      Text(DateFormat("dd-MM-yyyy").format(date), style: TextStyle(color: Colors.black54),) : SizedBox()
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