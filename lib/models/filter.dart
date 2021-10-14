/// Фильтр
class Filter {
  DateTime? dateFrom;
  DateTime? dateTo;
  String query;

  Filter(this.query, {this.dateFrom, this.dateTo});
  factory Filter.defaultFilter() {
    return Filter("",
        dateFrom: DateTime.now().subtract(Duration(days: 30)),
        dateTo: DateTime.now());
  }

  @override
  String toString() {
    return 'Filter{dateFrom: $dateFrom, dateTo: $dateTo, query: $query}';
  }
}
