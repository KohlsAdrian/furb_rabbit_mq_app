import 'dart:convert' as convert;

import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/extensions/string_extension.dart';
import 'package:furb_rabbit_mq_app/core/models/message_model.dart';
import 'package:furb_rabbit_mq_app/core/models/person_model.dart';
import 'package:http/http.dart' as http;

String? _token;

class Rest {
  final _host = 'http://localhost:8080';
  Rest._();
  static final instance = Rest._();

  Future<List<MqttTopics>> getTopics() async {
    final response = await http.get(Uri.parse('$_host/topics'));
    if (response.statusCode == 200) {
      final body = convert.json.decode(response.body);
      return (body as List).map((e) => e.toString().toTopicEnum!).toList();
    }
    return [];
  }

  Future<List<MqttTopics>> getMyTopics() async {
    final response = await http.get(
      Uri.parse('$_host/topics/me'),
      headers: {
        if (_token != null) 'Authorization': _token!,
      },
    );
    if (response.statusCode == 200) {
      final body = convert.json.decode(response.body);
      return (body as List).map((e) => e.toString().toTopicEnum!).toList();
    }
    return [];
  }

  Future<bool> updateTopics(List<MqttTopics> topics) async {
    final body = topics.map((e) => e.name.toString()).toList();
    final response = await http.patch(
      Uri.parse('$_host/topics'),
      body: convert.json.encode(body),
      headers: {
        if (_token != null) 'Authorization': _token!,
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_host/login'),
      body: convert.json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final body = convert.json.decode(response.body);
      _token = body?['jwt'];
      return _token != null;
    }
    return false;
  }

  Future<bool> create(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_host/persons'),
      body: convert.json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return response.body.toString() == 'true';
    }
    return false;
  }

  Future<PersonModel?> getPerson() async {
    final response = await http.get(
      Uri.parse('$_host/persons/me'),
      headers: {
        if (_token != null) 'Authorization': _token!,
      },
    );
    if (response.statusCode == 200) {
      final body = convert.json.decode(response.body);
      return PersonModel.fromJson(body);
    }
    return null;
  }

  Future<List<MessageModel>> getMessages() async {
    List<MessageModel> messages = [];

    final response = await http.get(
      Uri.parse('$_host/messages'),
      headers: {
        if (_token != null) 'Authorization': _token!,
      },
    );
    if (response.statusCode == 200) {
      final body = convert.json.decode(response.body);
      messages = (body as List).map((e) => MessageModel.fromJson(e)).toList();
    }

    return messages;
  }

  Future<bool> createMessage({
    required String message,
    required MqttTopics topic,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await http.post(
      Uri.parse('$_host/message'),
      body: convert.json.encode({
        'message': message,
        'type': topic.name,
        'date_start': startDate.toIso8601String(),
        'date_end': startDate.toIso8601String(),
      }),
      headers: {
        if (_token != null) 'Authorization': _token!,
      },
    );
    return response.statusCode <= 400;
  }
}
