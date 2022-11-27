import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

extension TimeOfDayExtension on TimeOfDay {
  String get toFormatedString => _toFormatedString(this);
  String _toFormatedString(TimeOfDay value) {
    return intl.DateFormat('HH:mm').format(DateTime(
      1970,
      0,
      0,
      value.hour,
      value.minute,
    ));
  }
}
