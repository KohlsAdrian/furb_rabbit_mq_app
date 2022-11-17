import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/notifier/notification_notifier.dart';
import 'package:furb_rabbit_mq_app/core/rest/rest.dart';
import 'package:furb_rabbit_mq_app/features/home/home.dart';

import './login.dart';

abstract class LoginViewModel extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void onLogin() {
    final email = emailController.text;
    final password = passwordController.text;
    Rest.instance.login(email, password).then((value) {
      if (value) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const Home())));
      } else {
        callNotificationNotifier('Não existe, tente criar!');
      }
    });
  }

  void onCreate() {
    final email = emailController.text;
    final password = passwordController.text;
    Rest.instance.create(email, password).then((value) {
      if (value) {
        onLogin();
      } else {
        callNotificationNotifier('Usuário já existe');
      }
    });
  }
}
