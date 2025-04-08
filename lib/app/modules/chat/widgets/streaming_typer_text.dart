import 'dart:async';
import 'package:aia/app/modules/chat/controller/chat_controller.dart';
import 'package:aia/app/modules/chat/data/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StreamingTypewriterText extends StatefulWidget {
  final RxString streamingText;
  final TextStyle textStyle;
  final ChatModel messageModel;

  const StreamingTypewriterText({
    super.key,
    required this.streamingText,
    required this.textStyle,
    required this.messageModel,
  });

  @override
  State<StreamingTypewriterText> createState() =>
      _StreamingTypewriterTextState();
}

class _StreamingTypewriterTextState extends State<StreamingTypewriterText> {
  String _displayText = '';
  Timer? _timer;
  int _typingPosition = 0;
  final Duration _typingSpeed = const Duration(milliseconds: 10);
  final chatController = Get.find<ChatController>();

  late final Worker _worker;

  @override
  void initState() {
    super.initState();
    _worker = ever(widget.streamingText, _onTextUpdated);
    _onTextUpdated(widget.streamingText.value);
  }

  void _onTextUpdated(String newText) {
    if (_typingPosition >= newText.length) return;

    _timer?.cancel();
    _timer = Timer.periodic(_typingSpeed, (timer) {
      if (_typingPosition < newText.length) {
        setState(() {
          _displayText += newText[_typingPosition];
          _typingPosition++;
        });
        // Add periodic scrolling - only every few characters to reduce scroll calls
        if (_typingPosition % 10 == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            chatController.scrollExtent();
          });
        }
        // chatController.scrollExtent();
      } else {
        timer.cancel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          chatController.scrollExtent();
        });
        widget.messageModel.isStreaming.value = false;
      }
    });
  }

  @override
  void dispose() {
    _worker.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.textStyle,
    );
  }
}
