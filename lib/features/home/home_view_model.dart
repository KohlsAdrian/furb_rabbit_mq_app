import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/models/person_model.dart';
import 'package:furb_rabbit_mq_app/core/mqtt.dart';
import 'package:furb_rabbit_mq_app/core/rest/rest.dart';

import './home.dart';

abstract class HomeViewModel extends State<Home> {
  final person = ValueNotifier<PersonModel?>(null);
  final topics = ValueNotifier<List<MqttTopics>>([]);
  final checkedTopics = ValueNotifier<Map<MqttTopics, bool>>({});
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

    await Rest.instance.getMyTopics().then((value) {
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
    });
  }

  void onChangedTopic(bool? value, MqttTopics topic) {
    checkedTopics.value[topic] = value ?? false;
    checkedTopics.value = {...checkedTopics.value};
    final checkeds = checkedTopics.value.keys
        .where((element) => checkedTopics.value[element] ?? false)
        .toList();
    Rest.instance.updateTopics(checkeds);
  }
}
