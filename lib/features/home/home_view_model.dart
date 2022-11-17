import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/models/message_model.dart';
import 'package:furb_rabbit_mq_app/core/models/person_model.dart';
import 'package:furb_rabbit_mq_app/core/mqtt.dart';
import 'package:furb_rabbit_mq_app/core/rest/rest.dart';

import './home.dart';

abstract class HomeViewModel extends State<Home> {
  final person = ValueNotifier<PersonModel?>(null);
  final topics = ValueNotifier<List<MqttTopics>>([]);
  final messages = ValueNotifier<List<MessageModel>>([]);
  final checkedTopics = ValueNotifier<Map<MqttTopics, bool>>({});
  final messagesDateTime =
      <int, Map<int, Map<int, List<MessageModel>>>>{}; // year, month, day

  final selectedDateTime = ValueNotifier<DateTime>(DateTime.now());
  final selectedMessageDateTime = ValueNotifier<List<MessageModel>>([]);

  @override
  void initState() {
    Rest.instance.getTopics().then((value) {
      topics.value = value;
      final values = <MqttTopics, bool>{};
      for (var element in MqttTopics.values) {
        values[element] = false;
      }
      checkedTopics.value = values;
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final values = <MqttTopics, bool>{};
      for (var element in MqttTopics.values) {
        values[element] = false;
      }
      initialize();
    });
  }

  void initialize() async {
    await Rest.instance.getPerson().then((value) => person.value = value);

    await Rest.instance.getMyTopics().then(
      (value) {
        final values = <MqttTopics, bool>{};
        for (var element in value) {
          values[element] = true;
        }
        if (values.isNotEmpty) {
          checkedTopics.value = {
            ...checkedTopics.value,
            ...values,
          };
        }
        resubscribe();
      },
    );
    await getMessages();
  }

  Future<void> getMessages() async {
    await Rest.instance.getMessages().then((value) {
      messages.value = value;
      messagesDateTime.clear();
      for (final message in messages.value) {
        final createdAt = message.createdAt;
        if (createdAt != null) {
          final year = createdAt.year;
          final month = createdAt.month;
          final day = createdAt.day;
          messagesDateTime[year] ??= {};
          messagesDateTime[year]![month] ??= {};
          messagesDateTime[year]![month]![day] ??= [];
          messagesDateTime[year]![month]![day]!.add(message);
        }
      }
      setState(() {});
    });
  }

  void onChangedTopic(bool? value, MqttTopics topic) {
    checkedTopics.value[topic] = value ?? false;
    checkedTopics.value = {...checkedTopics.value};
    final checkeds = checkedTopics.value.keys
        .where((element) => checkedTopics.value[element] ?? false)
        .toList();
    Rest.instance.updateTopics(checkeds);
    getMessages()
        .then((value) => onDaySelected(selectedDateTime.value, DateTime.now()));
  }

  List<dynamic> eventLoader(DateTime dateTime) {
    final messagesOfDay =
        messagesDateTime[dateTime.year]?[dateTime.month]?[dateTime.day];
    if (messagesOfDay != null) {
      return messagesOfDay
          .map((value) => {
                'type': value.type?.name,
                'message': value.message,
              })
          .toList();
    }
    return [];
  }

  void onDaySelected(DateTime dateTime, DateTime _) {
    selectedDateTime.value = dateTime;
    final year = dateTime.year;
    final month = dateTime.month;
    final day = dateTime.day;
    messagesDateTime[year] ??= {};
    messagesDateTime[year]![month] ??= {};
    messagesDateTime[year]![month]![day] ??= [];
    selectedMessageDateTime.value = messagesDateTime[year]![month]![day]!;
  }
}
