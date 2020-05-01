import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  @override
  StorageState get initialState => InitialStorageState();

  @override
  Stream<StorageState> mapEventToState(
    StorageEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
