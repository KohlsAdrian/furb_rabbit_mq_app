import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/extensions/string_extension.dart';

class PersonModel {
  String? name;
  String? email;
  PersonType? personType;
  List<MqttTopics?> topics;
  PersonModel({
    this.name,
    this.email,
    this.personType,
    this.topics = const [],
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
        name: json['name'],
        email: json['email'],
        personType: json['type'].toString().toPersonType,
        topics: (json['topics'] as List)
            .map((e) => e.toString().toTopicEnum)
            .toList(),
      );
}
