import 'package:aia/app/modules/chat/data/models/chat_model.dart';
import 'package:aia/app/modules/chat/data/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
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
    messages.listen((e) {
      if (e.isNotEmpty) {
        scrollExtent();
      }
    });
    messages.last.isFirstMessage = false;
  }

  Future<void> sendMessage(String text) async {
    Stopwatch sw = Stopwatch()..start();
    Stopwatch responseStreamSw = Stopwatch();

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
    print("User message added. Time: ${sw.elapsedMilliseconds}ms");

    isLoading.value = true;

    // Add temporary typing indicator
    final typingMessage = ChatModel(
      text: "",
      isUser: false,
      timestamp: DateTime.now(),
      isTyping: true,
    );
    messages.add(typingMessage);

    print("Typing indicator added. Time: ${sw.elapsedMilliseconds}ms");

    final responseStream = ChatService().getAIResponseStream(text);
    final buffer = StringBuffer();

    // Flag to track if typing indicator is removed
    bool typingRemoved = false;

    // Start response stream stopwatch
    responseStreamSw.start();

    try {
      await for (final chunk in responseStream) {
        print("Received chunk: $chunk");
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

        // Update the message content as each chunk arrives
        final aiIndex = messages.length - 1;
        messages[aiIndex] = messages[aiIndex].copyWith(
          text: buffer.toString(),
          isStreaming: true,
        );

        // Print the time taken to update the message (optional)
        print("AI message updated. Time: ${sw.elapsedMilliseconds}ms");
      }
    } catch (e) {
      print("Error streaming response: $e");

      if (!typingRemoved && messages.last.isTyping) {
        messages.removeLast();
      }

      messages.add(ChatModel(
        text: "Sorry, something went wrong.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      responseStreamSw.stop();
      isLoading.value = false;
      sw.stop();
      print("Total sendMessage execution time: ${sw.elapsedMilliseconds}ms");
    }
  }

  void scrollExtent() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
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
