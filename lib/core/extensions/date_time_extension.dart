import 'package:intl/intl.dart' as intl;

extension DateTimeExtension on DateTime {
  String get toFormatedString => _toFormatedString(this);
  String _toFormatedString(DateTime value) {
    return intl.DateFormat('dd/MM/yyyy - HH:mm:ss').format(value);
  }
}
