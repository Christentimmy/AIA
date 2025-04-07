
import 'dart:math';

import 'package:aia/app/modules/chat/models/chat_model.dart';
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
  void onInit() {
    super.onInit();
    
    // Welcome message
    messages.add(ChatModel(
      text: "Hello, I'm AIA. How can I assist you today?",
      isUser: false,
      timestamp: DateTime.now(),
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
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    // Clear text field
    messageController.clear();
    
    // Add user message
    final userMessage = ChatModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    
    // Show AI is typing
    final typingMessage = ChatModel(
      text: "",
      isUser: false,
      timestamp: DateTime.now(),
      isTyping: true,
    );
    messages.add(typingMessage);
    
    // Simulate AI thinking
    isLoading.value = true;
    
    // Simulate AI response delay
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(2000)));
    
    // Remove typing indicator
    messages.removeLast();
    
    // Add AI response
    final aiResponse = ChatModel(
      text: await _generateAIResponse(text),
      isUser: false,
      timestamp: DateTime.now(),
    );
    messages.add(aiResponse);
    
    isLoading.value = false;
  }
  
  Future<String> _generateAIResponse(String userMessage) async {
    // This would connect to your actual AI service
    // For now we'll use mock responses
    
    final lowercaseMessage = userMessage.toLowerCase();
    
    if (lowercaseMessage.contains("hello") || lowercaseMessage.contains("hi")) {
      return "Hello! How can I help you today?";
    } else if (lowercaseMessage.contains("help")) {
      return "I'm here to assist you with information, tasks, or just conversation. What would you like to know?";
    } else if (lowercaseMessage.contains("thank")) {
      return "You're welcome! Feel free to ask if you need anything else.";
    } else if (lowercaseMessage.contains("feature") || lowercaseMessage.contains("do")) {
      return "I can answer questions, provide information, generate creative content, have thoughtful discussions, and assist with many other tasks. What are you interested in?";
    } else {
      return "That's an interesting point. Would you like me to elaborate more on this topic or is there something specific you're curious about?";
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
