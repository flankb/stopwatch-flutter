
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonsBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      height: 56,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Кнопка с подсказкой внизу:
            // https://api.flutter.dev/flutter/material/IconButton-class.html
            // Так же можно обернуть в InkWell

            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Сброс',
              onPressed: () {
              },
            ),

            IconButton(
              icon: Icon(Icons.list),
              tooltip: 'История',
              onPressed: () {
              },
            ),

            IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
              },
            ),

            IconButton(
              icon: Icon(Icons.more_horiz),
              tooltip: 'Menu',
              onPressed: () {
              },
            )
          ],
        ),
      ),
    );
  }
}