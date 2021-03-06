import 'package:flutter/widgets.dart';
import 'package:soundpool/soundpool.dart';

class SoundWidget extends InheritedWidget {
  final Soundpool soundPool;
  final List<int> sounds;

  const SoundWidget({
    required this.soundPool,
    required this.sounds,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(SoundWidget oldWidget) => true;

  static SoundWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SoundWidget>();
}
