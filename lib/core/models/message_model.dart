import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/extensions/string_extension.dart';

class MessageModel {
  String? id;
  String? message;
  DateTime? createdAt;
  DateTime? startDate;
  DateTime? endDate;
  MqttTopics? type;
  MessageModel({
    this.id,
    this.message,
    this.createdAt,
    this.startDate,
    this.endDate,
    this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'].toString(),
        message: json['message'],
        type: json['type'].toString().toTopicEnum,
        createdAt: json['created_at'].toString().toDateTime,
        startDate: json['date_start'].toString().toDateTime,
        endDate: json['date_end'].toString().toDateTime,
      );
}
