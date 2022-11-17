import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/components/base_widget.dart';
import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/models/person_model.dart';

import './home_view_model.dart';

class HomeView extends HomeViewModel {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      onRefresh: initialize,
      appBar: AppBar(
        title: ValueListenableBuilder<PersonModel?>(
          valueListenable: person,
          builder: (_, value, __) => Text(
              'Bem-vindo ${value?.name} | ${value?.email} | ${value?.personType?.name}'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _topics(),
          ],
        ),
      ),
    );
  }

  Widget _topics() => ValueListenableBuilder<List<MqttTopics>>(
        valueListenable: topics,
        builder: (_, topics, __) => Column(
          children: topics
              .map(
                (topic) => ValueListenableBuilder<Map<MqttTopics, bool>>(
                  valueListenable: checkedTopics,
                  builder: (_, checked, __) => InkWell(
                    onTap: () => onChangedTopic(
                      !(checked[topic] ?? true),
                      topic,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(topic.name),
                        Checkbox(
                          value: checked[topic],
                          onChanged: (value) => onChangedTopic(value, topic),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
}
