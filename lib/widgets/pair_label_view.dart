import 'package:flutter/widgets.dart';

class PairLabelView extends StatelessWidget {
  final String caption;
  final String value;

  const PairLabelView({
    required this.caption,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Text('$caption:'),
          const SizedBox(
            width: 6,
          ),
          Text(value)
        ],
      );
}
