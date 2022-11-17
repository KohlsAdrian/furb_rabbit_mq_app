import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/components/base_widget.dart';
import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/models/message_model.dart';
import 'package:furb_rabbit_mq_app/core/models/person_model.dart';
import 'package:table_calendar/table_calendar.dart';

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: _topics(),
            ),
            Expanded(
              child: ValueListenableBuilder<DateTime>(
                valueListenable: selectedDateTime,
                builder: (_, dateTime, __) =>
                    ValueListenableBuilder<List<MessageModel>>(
                  valueListenable: selectedMessageDateTime,
                  builder: (_, messages, __) => Column(
                    children: [
                      TableCalendar(
                        currentDay: dateTime,
                        focusedDay: dateTime,
                        firstDay: DateTime.now()
                            .subtract(const Duration(days: 365 * 10)),
                        lastDay:
                            DateTime.now().add(const Duration(days: 365 * 3)),
                        eventLoader: eventLoader,
                        onDaySelected: onDaySelected,
                      ),
                      _events(messages),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _events(List<MessageModel> messages) => Visibility(
        visible: messages.isNotEmpty,
        child: Column(
          children: messages
              .map(
                (e) => Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.indigo,
                  ),
                  child: Text(
                    '${e.type.toString()} | ${e.message}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );

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
