import 'package:intl/intl.dart';

class DateHelper {
  static final _format = DateFormat('yyyy-MM-dd');

  static DateTime toDateKeyFromDateTime(DateTime date) {
    final parts = _format.format(date).split('-');
    return DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  static DateTime toDateKeyFromString(String date) {
    final parts = date.split('-');
    return DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  static String toStringDateFromDateTime(DateTime date) {
    return _format.format(date);
  }
}
