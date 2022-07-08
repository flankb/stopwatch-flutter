import 'package:flutter/material.dart';

class CenterCircularWidget extends StatelessWidget {
  const CenterCircularWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
