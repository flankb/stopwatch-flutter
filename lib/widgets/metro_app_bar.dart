import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'buttons_bar.dart';

class MetroAppBar extends StatefulWidget {
  final List<PrimaryCommand> primaryCommands;
  final List<SecondaryCommand> secondaryCommands;

  const MetroAppBar({Key key, @required this.primaryCommands, @required this.secondaryCommands}) : super(key: key);

  @override
  _MetroAppBarState createState() => _MetroAppBarState();
}

class _MetroAppBarState extends State<MetroAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.redAccent,
      height: 56,
      decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).bottomAppBarColor,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff3F3C3C),
              blurRadius: 1.0,
              spreadRadius: 0.0,
              offset: Offset(0.3, 0.3), // shadow direction: bottom right
            )
          ],
          borderRadius: new BorderRadius.horizontal(
            left: new Radius.circular(0.0),
            right: new Radius.circular(0.0),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            for (var pc in widget.primaryCommands) pc,
            PopupMenuButton<String>(
              onSelected: (command) {
                // Определить нужную команду
                final cmd = widget.secondaryCommands.singleWhere((element) => element.commandName == command);
                cmd.onPressed();
              },
              itemBuilder: (BuildContext context) {
                return widget.secondaryCommands.map((e) {
                  return PopupMenuItem<String>(
                    value: e.commandName,
                    child: e.child,);
                }).toList();
              },
            )
          ],
        ),
      ),
    );
  }
}
