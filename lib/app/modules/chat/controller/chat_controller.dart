import 'package:aia/app/modules/chat/data/models/chat_model.dart';
import 'package:aia/app/modules/chat/data/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class ChatController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
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
      isStreaming: true.obs,
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
    messages.last.isStreaming.value = false;
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

    // Add temporary typing indicator
    final typingMessage = ChatModel(
      text: "",
      isUser: false,
      timestamp: DateTime.now(),
      isTyping: true,
    );
    messages.add(typingMessage);

    final responseStream = ChatService().getAIResponseStream(text);

    final aiMessage = ChatModel(
      text: "",
      isUser: false,
      timestamp: DateTime.now(),
      isStreaming: true.obs,
      streamingText: ''.obs,
    );

    bool addedAIMessage = false;

    try {
      await for (final chunk in responseStream) {
        if (!addedAIMessage) {
          if (messages.isNotEmpty && messages.last.isTyping) {
            messages.removeLast();
          }
          messages.add(aiMessage);
          addedAIMessage = true;
        }

        aiMessage.streamingText?.value += chunk;
        scrollExtent();
      }

      // Finalize AI message
      aiMessage.text = aiMessage.streamingText?.value ?? "";
      aiMessage.isStreaming.value = false;
    } catch (e) {
      messages.add(ChatModel(
        text: "Sorry, something went wrong.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
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

  Future<void> speak(ChatModel message) async {
    try {
      flutterTts.setCompletionHandler(() {
        message.isSpeaking.value = false;
      });
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      message.isSpeaking.value = true;
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(message.text, focus: true);
      message.isSpeaking.value = false;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> stopSpeaking(ChatModel message) async {
    try {
      await flutterTts.stop();
      message.isSpeaking.value = false;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> copyToClipboard(ChatModel message) async {
    if (message.isCopied.value) return;
    message.isCopied.value = true;
    await Clipboard.setData(
      ClipboardData(text: message.text),
    );
    Future.delayed(const Duration(seconds: 2), () {
      message.isCopied.value = false;
    });
  }

  @override
  void onClose() {
    flutterTts.stop();
    messageController.dispose();
    focusNode.dispose();
    pulseAnimationController.dispose();
    backgroundAnimController.dispose();
    super.onClose();
  }
}
