import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(onPressed: () {

    },
    child: Icon(Icons.keyboard_backspace),
    );
  }
}