
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_review/launch_review.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_state.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/view/pages/about_page.dart';
import 'package:stopwatch/view/pages/history_page.dart';
import 'package:stopwatch/view/pages/settings_page.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:toast/toast.dart';



class SecondaryCommand { // TODO Переделать в Widget???
  final String commandName;
  final VoidCallback onPressed;
  final Widget child;

  SecondaryCommand({@required this.commandName, @required this.onPressed, @required this.child});
}

class PrimaryCommand extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData pic;
  final Color color;
  final String tooltip;

  const PrimaryCommand({
    Key key, @required this.onPressed, @required this.pic, this.color, @required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      //minHeight: 56,
      constraints: BoxConstraints(
        minHeight: 56,
        maxHeight: 56,
        maxWidth: 110
      ),
      child: FlatButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 28,
                child: Icon(pic, color: color)
            ),
            Text(tooltip, maxLines: 1, style: TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis,)
          ],
        ),
      ),
    );



     /* IconButton(
      icon: Icon(pic, color: color),
      color: color,
      tooltip: tooltip,
      //onPressed: onPressed,
    );*/
  }
}

/*
class MenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData pic;

  const MenuButton({
    Key key, this.onPressed, this.pic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal : 8.0),
      child: IconButton(
        icon: Icon(Icons.ac_unit),
        color: Colors.red,
        tooltip: 'View database',
        onPressed: () {
          final db = MyDatabase(); //This should be a singleton
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoorDbViewer(db)));
        },
      ),
    );
  }
}
 */