import 'package:extended_theme/extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stopwatch/theme_data.dart';

class MeasureLapItem extends StatelessWidget {
  final int order;
  final String difference;
  final String overall;

  const MeasureLapItem(
      {Key key,
      @required this.order,
      @required this.difference,
      @required this.overall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
            width: 36,
            child: Text(
              "$order.",
              style: TextStyle(fontSize: 18),
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("$difference", style: TextStyle(fontSize: 18)),
            Text("$overall",
                style: TextStyle(
                    fontSize: 16,
                    color: ExtentedThemeProvider.of<AppTheme>(context)
                        .theme
                        .subtitleColor))
          ],
        )
      ],
    );
  }
}
