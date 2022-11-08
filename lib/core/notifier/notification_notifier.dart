import 'package:flutter/material.dart';

final showNotificationNotifier = ValueNotifier<bool>(false);
final messageNotificationNotifier = ValueNotifier<String>('');
void callNotificationNotifier(String message) {
  messageNotificationNotifier.value = message;
  showNotificationNotifier.value = true;
  Future.delayed(const Duration(seconds: 3))
      .then((value) => showNotificationNotifier.value = false);
}
