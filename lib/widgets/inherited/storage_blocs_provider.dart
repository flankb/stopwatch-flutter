import 'package:flutter/material.dart';
import 'package:stopwatch/bloc/storage_bloc/bloc.dart';

class StorageBlocsProvider extends InheritedWidget {
  final StorageBloc measuresBloc;
  final StorageBloc lapsBloc;

  const StorageBlocsProvider({
    required this.measuresBloc,
    required this.lapsBloc,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static StorageBlocsProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StorageBlocsProvider>()!;
}
