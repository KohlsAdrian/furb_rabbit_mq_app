import 'package:flutter/material.dart';
import './create_message_view.dart';

class CreateMessage extends StatefulWidget {
  static const route = '/CreateMessage/';
  const CreateMessage({Key? key}) : super(key: key);
  
  @override
  CreateMessageView createState() =>  CreateMessageView();
}
  
