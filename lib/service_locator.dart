
import 'package:get_it/get_it.dart';
import 'package:learnwords/bloc/entity_bloc/bloc.dart';
import 'package:learnwords/bloc/storage_bloc/storage_bloc.dart';
import 'package:learnwords/resources/stopwatch_db_repository.dart';
import 'package:learnwords/util/csv_exporter.dart';
import 'package:learnwords/util/ticker.dart';

import 'bloc/measure_bloc/measure_bloc.dart';

final getIt = GetIt.instance;

const String MeasuresBloc = "MeasuresBloc";
const String LapsBloc = "LapsBloc";

setupLocators() {
  getIt.registerSingleton(StopwatchRepository());

  getIt.registerSingleton<StorageBloc>(StorageBloc(getIt.get<StopwatchRepository>()), instanceName: MeasuresBloc);
  getIt.registerSingleton<StorageBloc>(StorageBloc(getIt.get<StopwatchRepository>()), instanceName: LapsBloc);

  getIt.registerFactory<MeasureBloc>(() => MeasureBloc(Ticker3(), getIt.get<StopwatchRepository>()));
  getIt.registerFactory(() => EntityBloc(getIt.get<StopwatchRepository>()));

  getIt.registerFactory(() => CsvExporter(getIt.get<StopwatchRepository>()));
}