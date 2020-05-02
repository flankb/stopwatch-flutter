
import 'package:csv/csv.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';

class CsvExporter{
  static String convertToCsv(List<MeasureViewModel> measures) {
    String csv = const ListToCsvConverter().convert([]);
    return csv;
  }
}