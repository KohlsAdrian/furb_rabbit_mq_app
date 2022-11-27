import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/components/base_widget.dart';
import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/extensions/date_time_extension.dart';
import 'package:furb_rabbit_mq_app/core/extensions/time_of_day_extension.dart';

import './create_message_view_model.dart';

class CreateMessageView extends CreateMessageViewModel {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      appBar: AppBar(title: const Text('Criar evento e avisar!')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 2, child: _dateTime()),
                Expanded(child: _topics()),
              ],
            ),
            _message(),
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topics() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tipo de mensagem'),
          Column(
            children: MqttTopics.values
                .map(
                  (e) => RadioListTile<MqttTopics>(
                    value: e,
                    title: Text(e.name),
                    groupValue: topic,
                    onChanged: (value) => setState(() => topic = value!),
                  ),
                )
                .toList(),
          ),
        ],
      );

  Widget _message() => Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: messageController,
              maxLines: 10,
              decoration: const InputDecoration(
                label: Text('Mensagem (10 caracteres no mínimo'),
              ),
            ),
          ],
        ),
      );

  Widget _dateTime() => Column(
        children: [
          Row(
            children: [
              const Text('Inicio:'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onChangeStartDate,
                child: Text(
                  startDate?.toFormatedString(showTime: false) ??
                      'Selecionar data de início',
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onChangeStartTime,
                child: Text(
                  startTime?.toFormatedString ?? 'Selecionar hora de início',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Text('Fim:'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onChangeEndDate,
                child: Text(
                  endDate?.toFormatedString(showTime: false) ??
                      'Selecionar data de fim',
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onChangeEndTime,
                child: Text(
                  endTime?.toFormatedString ?? 'Selecionar hora de fim',
                ),
              ),
            ],
          ),
        ],
      );
}
