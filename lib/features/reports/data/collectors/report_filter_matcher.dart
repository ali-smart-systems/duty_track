import 'package:duty_track/features/reports/data/models/report_filter.dart';

class ReportFilterMatcher {
  const ReportFilterMatcher._();

  static bool matchesDateRange(
    ReportFilter filter, {
    DateTime? date,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    if (date != null) {
      return _isWithinRange(date, filter.fromDate, filter.toDate);
    }

    if (fromDate == null && toDate == null) {
      return true;
    }

    final starts = fromDate ?? toDate;
    final ends = toDate ?? fromDate;

    if (starts == null || ends == null) {
      return true;
    }

    return !ends.isBefore(_startOfDay(filter.fromDate)) &&
        !starts.isAfter(_endOfDay(filter.toDate));
  }

  static bool matchesNullable(String? filterValue, String value) {
    return filterValue == null || filterValue.isEmpty || filterValue == value;
  }

  static DateTime _startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime _endOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day, 23, 59, 59, 999);
  }

  static bool _isWithinRange(
    DateTime value,
    DateTime fromDate,
    DateTime toDate,
  ) {
    return !value.isBefore(_startOfDay(fromDate)) &&
        !value.isAfter(_endOfDay(toDate));
  }
}
