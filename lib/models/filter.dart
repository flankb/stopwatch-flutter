
/// Фильтр
class Filter {
  final DateTime dateFrom;
  final DateTime dateTo;
  final String query;

  Filter(this.query, {this.dateFrom, this.dateTo}) : assert (query != null)
  {}

  factory Filter.defaultFilter() {
    return Filter("", dateFrom : DateTime.now().subtract(Duration(days: 30)), dateTo: DateTime.now());
  }
}