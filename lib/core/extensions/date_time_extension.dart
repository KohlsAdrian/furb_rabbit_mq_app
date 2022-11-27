import 'package:intl/intl.dart' as intl;

extension DateTimeExtension on DateTime {
  String toFormatedString({bool showTime = true}) =>
      _toFormatedString(this, showTime: showTime);
  String _toFormatedString(DateTime value, {required bool showTime}) {
    if (!showTime) return intl.DateFormat('dd/MM/yyyy').format(value);
    return intl.DateFormat('dd/MM/yyyy - HH:mm:ss').format(value);
  }
}
