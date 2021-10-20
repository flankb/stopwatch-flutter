import 'package:flutter/widgets.dart';

class PairLabelView extends StatelessWidget {
  final String caption;
  final String value;

  const PairLabelView({Key? key, required this.caption, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text("$caption:"),
        SizedBox(
          width: 6,
        ),
        Text(value)
      ],
    );
  }
}
