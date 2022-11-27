import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/constants.dart';
import 'package:furb_rabbit_mq_app/core/rest/rest.dart';

import './create_message.dart';

abstract class CreateMessageViewModel extends State<CreateMessage> {
  final messageController = TextEditingController();

  DateTime? get startDate => _startDate;
  TimeOfDay? get startTime => _startTime;

  DateTime? get endDate => _endDate;
  TimeOfDay? get endTime => _endTime;

  DateTime? _startDate;
  DateTime? _endDate;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  MqttTopics topic = MqttTopics.event;

  void onSave() async {
    final message = messageController.text;
    if (message.length < 10) return;
    if (startDate == null ||
        startTime == null ||
        endDate == null ||
        endTime == null) return null;
    final success = await Rest.instance.createMessage(
      message: message,
      topic: topic,
      startDate: DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTime!.hour,
        startTime!.minute,
      ),
      endDate: DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
        endTime!.hour,
        endTime!.minute,
      ),
    );
    if (success) if (mounted) Navigator.of(context).pop();
  }

  void onChangeStartDate() async {
    _startDate = await _onDatePicker() ?? _startDate;
    setState(() {});
  }

  void onChangeEndDate() async {
    _endDate = await _onDatePicker() ?? _endDate;
    setState(() {});
  }

  void onChangeStartTime() async {
    _startTime = await _onTimePicker() ?? _startTime;
    setState(() {});
  }

  void onChangeEndTime() async {
    _endTime = await _onTimePicker() ?? _endTime;
    setState(() {});
  }

  Future<DateTime?> _onDatePicker() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    return dateTime;
  }

  Future<TimeOfDay?> _onTimePicker() async {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
    );
    return timeOfDay;
  }
}
