import 'package:flutter/material.dart';
import 'package:furb_rabbit_mq_app/core/notifier/notification_notifier.dart';

class BaseWidget extends StatefulWidget {
  final Widget body;
  final AppBar? appBar;
  final VoidCallback? onRefresh;
  const BaseWidget({
    required this.body,
    this.onRefresh,
    this.appBar,
    super.key,
  });

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          appBar: widget.appBar,
          floatingActionButton: Visibility(
            visible: widget.onRefresh != null,
            child: FloatingActionButton(
              onPressed: widget.onRefresh,
              child: const Icon(Icons.refresh),
            ),
          ),
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
            bottom: value ? 24 : -size.height,
            child: SafeArea(
              child: Material(
                child: Container(
                  width: size.width * .9,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      messageNotificationNotifier.value,
                      style: const TextStyle(
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
