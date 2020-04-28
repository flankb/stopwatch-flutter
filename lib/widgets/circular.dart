import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CenterCircularWidget extends StatelessWidget {
  const CenterCircularWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}