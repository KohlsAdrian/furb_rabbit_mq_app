import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:intl/intl.dart' as intl;

extension StringExtension on String {
  PersonType? get toPersonType => _toPersonType(this);
  PersonType? _toPersonType(String? value) {
    PersonType? personType;
    switch (value) {
      case 'teacher':
        personType = PersonType.teacher;
        break;
      case 'student':
        personType = PersonType.student;
        break;
      case 'parent':
        personType = PersonType.parent;
        break;
      case 'headship':
        personType = PersonType.headship;
        break;
    }
    return personType;
  }

  MqttTopics? get toTopicEnum => _toTopicEnum(this);
  MqttTopics? _toTopicEnum(String? value) {
    MqttTopics? topic;
    switch (value) {
      case 'event':
        topic = MqttTopics.event;
        break;
      case 'test':
        topic = MqttTopics.test;
        break;
      case 'rest':
        topic = MqttTopics.rest;
        break;
      default:
    }
    return topic;
  }

  String get dateTimeStringFormatted => _dateTimeStringFormatted(this);
  String _dateTimeStringFormatted(String dateTimeString) {
    final parsed = dateTimeString.replaceAll('T', ' ').split('.').first;
    final dateTime = intl.DateFormat().parse(parsed);
    final day = dateTime.day;
    final month = dateTime.month;
    final year = dateTime.year;
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    return '$day/$month/$year - $hour:$minute';
  }
}
