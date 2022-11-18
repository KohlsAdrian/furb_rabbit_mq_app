import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/components/base_widget.dart';
import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/extensions/date_time_extension.dart';
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
        actions: [
          ValueListenableBuilder<PersonModel?>(
            valueListenable: person,
            builder: (_, value, __) => Visibility(
              visible: person.value?.personType == PersonType.headship ||
                  person.value?.personType == PersonType.teacher,
              child: IconButton(
                onPressed: onCreateMessage,
                icon: const Icon(Icons.create),
              ),
            ),
          ),
        ],
        title: ValueListenableBuilder<PersonModel?>(
          valueListenable: person,
          builder: (_, value, __) => Text(
              'Bem-vindo ${value?.name} | ${value?.email} | ${value?.personType?.name}'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: _topics(),
                    ),
                    _calendar(),
                  ],
                ),
              ),
            ),
            _events(),
          ],
        ),
      ),
    );
  }

  Widget _calendar() => ValueListenableBuilder<DateTime>(
        valueListenable: selectedDateTime,
        builder: (_, dateTime, __) => TableCalendar(
          currentDay: dateTime,
          focusedDay: dateTime,
          firstDay: DateTime.now().subtract(const Duration(days: 365 * 10)),
          lastDay: DateTime.now().add(const Duration(days: 365 * 3)),
          eventLoader: eventLoader,
          onDaySelected: onDaySelected,
        ),
      );

  Widget _events() => ValueListenableBuilder<List<MessageModel>>(
        valueListenable: selectedMessageDateTime,
        builder: (_, messages, __) => Visibility(
          visible: messages.isNotEmpty,
          child: Column(
            children: messages
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: e.type == MqttTopics.event
                          ? Colors.amber
                          : e.type == MqttTopics.test
                              ? Colors.red
                              : Colors.indigo,
                    ),
                    child: Text(
                      '${e.message}\n'
                      'Início: ${e.startDate?.toFormatedString}\n'
                      'Fim: ${e.endDate?.toFormatedString}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );

  Widget _topics() => ValueListenableBuilder<List<MqttTopics>>(
        valueListenable: topics,
        builder: (_, topics, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        Text(
                          topic.name,
                          style: const TextStyle(color: Colors.white),
                        ),
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
