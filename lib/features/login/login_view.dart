import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/components/base_widget.dart';

import './login_view_model.dart';

class LoginView extends LoginViewModel {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Senha'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onLogin,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: onCreate,
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
