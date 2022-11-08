import 'package:intl/intl.dart' as intl;

const host = 'jackal.rmq.cloudamqp.com';
const username = 'lnixlvfr:lnixlvfr';
const password = 'eRX8pkRaL99ai9FmgIlKLcjP_hjyb_Vw';

enum MqttTopics { event, test, rest }

enum PersonType { teacher, student, parent, headship }

String dateTimeStringFormatted(String dateTimeString) {
  final parsed = dateTimeString.replaceAll('T', ' ').split('.').first;
  final dateTime = intl.DateFormat().parse(parsed);
  final day = dateTime.day;
  final month = dateTime.month;
  final year = dateTime.year;
  final hour = dateTime.hour;
  final minute = dateTime.minute;

  return '$day/$month/$year - $hour:$minute';
}
