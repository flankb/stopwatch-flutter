import 'package:flutter/widgets.dart';
import 'package:soundpool/soundpool.dart';

class SoundWidget extends InheritedWidget {
  /*final Soundpool soundPool;
  final List<int> sounds;
  final Widget child;*/

  SoundWidget(Soundpool soundPool, List<int> sounds, Widget child, {Key key}) : super(child: child, key: key);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
