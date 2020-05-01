import 'package:equatable/equatable.dart';

abstract class StorageState extends Equatable {
  const StorageState();
}

class InitialStorageState extends StorageState {
  @override
  List<Object> get props => [];
}
