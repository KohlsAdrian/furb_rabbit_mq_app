import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/components/base_widget.dart';

import './login_view_model.dart';

class LoginView extends LoginViewModel {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 24),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Senha'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: onLogin,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: onCreate,
              child: Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
