import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/notifier/notification_notifier.dart';

class BaseWidget extends StatefulWidget {
  final Widget body;
  const BaseWidget({
    required this.body,
    super.key,
  });

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final padding = mq.padding;
    final size = mq.size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: widget.body,
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: showNotificationNotifier,
          builder: (_, value, __) => AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: value ? 0 : -padding.bottom * 3,
            child: SafeArea(
              child: Material(
                child: Container(
                  width: size.width * .9,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      messageNotificationNotifier.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
