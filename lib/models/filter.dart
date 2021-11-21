import 'package:equatable/equatable.dart';

/// Фильтр
class Filter extends Equatable {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String query;

  const Filter(this.query, {this.dateFrom, this.dateTo});

  factory Filter.defaultFilter() => Filter(
        '',
        dateFrom: DateTime.now().subtract(const Duration(days: 30)),
        dateTo: DateTime.now(),
      );

  factory Filter.empty() => const Filter('', dateFrom: null, dateTo: null);

  @override
  String toString() =>
      'Filter{dateFrom: $dateFrom, dateTo: $dateTo, query: $query}';

  @override
  List<Object?> get props => [dateFrom, dateTo, query];

  Filter copyWithNullable({DateTime? dateFrom, DateTime? dateTo}) =>
      Filter(query, dateFrom: dateFrom, dateTo: dateTo);

  Filter copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? query,
  }) =>
      Filter(
        query ?? this.query,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
      );
}
