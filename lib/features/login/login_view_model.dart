import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/notifier/notification_notifier.dart';
import 'package:furb_rabbit_mq_app/core/rest/rest.dart';

import './login.dart';

abstract class LoginViewModel extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void onLogin() {
    final email = emailController.text;
    final password = passwordController.text;
    Rest.instance.login(email, password).then((value) {
      if (value) {
      } else {
        callNotificationNotifier('Não existe, tente criar!');
      }
    });
  }

  void onCreate() {}
}
