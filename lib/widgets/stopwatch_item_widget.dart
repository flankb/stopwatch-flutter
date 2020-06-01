import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/view/pages/entity_edit_page.dart';
import 'package:learnwords/view/pages/history_page.dart';

class StopwatchItem extends StatefulWidget {
  final BaseStopwatchEntity entity;
  final ValueChanged<bool> selectedEvent;

  const StopwatchItem({Key key, this.entity, this.selectedEvent}) : super(key: key);

  @override
  _StopwatchItemState createState() {
    return _StopwatchItemState();
  }
}

class _StopwatchItemState extends State<StopwatchItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => {
        this.setState(() {
            isSelected = !isSelected;
            widget.selectedEvent(isSelected);
        })

        /*
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Container(
            color: isSelected ? Colors.deepOrange : Colors.transparent,
            child: Text(
              widget.entity.comment,
              style: TextStyle(fontSize: 18),
            )),
      ),
    );
  }
}