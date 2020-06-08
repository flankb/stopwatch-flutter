import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class EntityBloc extends Bloc<EntityEvent, EntityState> {
  @override
  EntityState get initialState => InitialEntityState();

  @override
  Stream<EntityState> mapEventToState(
    EntityEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
