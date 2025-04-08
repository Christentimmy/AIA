import 'package:aia/app/modules/chat/data/models/chat_model.dart';
import 'package:aia/app/modules/chat/data/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  RxString message = ''.obs;
  final FocusNode focusNode = FocusNode();
  final RxList<ChatModel> messages = <ChatModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxDouble animationValue = 0.0.obs;
  late AnimationController pulseAnimationController;

  // Animation for background elements
  late AnimationController backgroundAnimController;
  final RxDouble backgroundAnimValue = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    // Welcome message
    messages.add(ChatModel(
      text: "Hello, I'm AIA. How can I assist you today?",
      isUser: false,
      timestamp: DateTime.now(),
      isFirstMessage: true,
    ));

    // Setup pulse animation for AI typing indicator
    pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    pulseAnimationController.addListener(() {
      animationValue.value = pulseAnimationController.value;
    });

    // Setup background animation
    backgroundAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    backgroundAnimController.addListener(() {
      backgroundAnimValue.value = backgroundAnimController.value;
    });

    await Future.delayed(const Duration(seconds: 2));

    messages.last.isFirstMessage = false; // Set the first message flag
  }

  Future<void> sendMessage(String text) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (text.trim().isEmpty) return;

    messageController.clear();

    // Add user message
    final userMessage = ChatModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);

    Stopwatch sw = Stopwatch()..start();
    isLoading.value = true;

    // Add temporary typing indicator
    final typingMessage = ChatModel(
      text: "",
      isUser: false,
      timestamp: DateTime.now(),
      isTyping: true,
    );
    messages.add(typingMessage);

    final responseStream = ChatService().getAIResponseStream(text);
    final buffer = StringBuffer();
    // String fullResponse = "";

    // Flag to track if typing indicator is removed
    bool typingRemoved = false;

    try {
      await for (final chunk in responseStream) {
        buffer.write(chunk);

        if (!typingRemoved) {
          messages.removeLast();
          messages.add(ChatModel(
            text: "",
            isUser: false,
            timestamp: DateTime.now(),
          ));
          typingRemoved = true;
        }

        final aiIndex = messages.length - 1;
        messages[aiIndex] = messages[aiIndex].copyWith(text: buffer.toString());
      }
    } catch (e) {
      print("Error streaming response: $e");

      // If typing wasn't removed yet, remove it now
      if (!typingRemoved && messages.last.isTyping) {
        messages.removeLast();
      }

      // Show fallback error message
      messages.add(ChatModel(
        text: "Sorry, something went wrong.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
      sw.stop();
      print("AI response time: ${sw.elapsedMilliseconds} ms");
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    focusNode.dispose();
    pulseAnimationController.dispose();
    backgroundAnimController.dispose();
    super.onClose();
  }
}
