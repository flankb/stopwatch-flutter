import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'buttons_bar.dart';

class MetroAppBar extends StatefulWidget {
  final List<Widget> primaryCommands;
  final List<SecondaryCommand> secondaryCommands;

  const MetroAppBar({Key key, @required this.primaryCommands, @required this.secondaryCommands}) : super(key: key);

  @override
  _MetroAppBarState createState() => _MetroAppBarState();
}

class _MetroAppBarState extends State<MetroAppBar> with SingleTickerProviderStateMixin {
  //AnimationController _animationController;
  //Animation _animation;

  @override
  void initState() {
    super.initState();

    //_animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2750));
    //_animation = Tween<double>(begin: 0, end: 24).animate(_animationController);

    //_animationController.forward();
  }


  /*
  SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
   */

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
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xff3F3C3C) : const Color(0xffd3d3d3),
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

                widget.secondaryCommands.any((element) => true) ?
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
                ) : SizedBox()
              ],
            ),
          ),
        );

  }
}