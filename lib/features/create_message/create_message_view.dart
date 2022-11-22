import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/components/base_widget.dart';

import './create_message_view_model.dart';

class CreateMessageView extends CreateMessageViewModel {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      appBar: AppBar(title: const Text('Criar evento e avisar!')),
      body: Column(
        children: [],
      ),
    );
  }
}
