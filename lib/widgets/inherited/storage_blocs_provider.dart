import 'package:flutter/material.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';

class StorageBlocsProvider extends InheritedWidget {
  final StorageBloc measuresBloc;
  final StorageBloc lapsBloc;

  StorageBlocsProvider({
    Key? key,
    required this.measuresBloc,
    required this.lapsBloc,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static StorageBlocsProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StorageBlocsProvider>()!;
  }
}
