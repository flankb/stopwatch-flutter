import 'package:equatable/equatable.dart';

/// Фильтр
class Filter extends Equatable {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String query;

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

  @override
  List<Object?> get props => [dateFrom, dateTo, query];

  Filter copyWithNullable({DateTime? dateFrom, DateTime? dateTo}) {
    return Filter(query, dateFrom: dateFrom, dateTo: dateTo);
  }

  Filter copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? query,
  }) {
    return Filter(
      query ?? this.query,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
    );
  }
}
