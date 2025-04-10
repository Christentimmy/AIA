import 'dart:async';
import 'package:aia/app/config/constants.dart';
import 'package:aia/app/core/utils/clipboard_helper.dart';
import 'package:aia/app/core/widgets/snack_bar.dart';
import 'package:aia/app/modules/chat/data/models/chat_model.dart';
import 'package:aia/app/modules/chat/data/service/chat_service.dart';
import 'package:aia/app/modules/chat/data/service/permission_handler.dart';
import 'package:aia/app/modules/chat/data/service/speech_to_text_service.dart';
import 'package:aia/app/modules/chat/data/service/text_to_speech_service.dart';
import 'package:aia/app/modules/chat/mixin/chat_animation_mixin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController
    with GetTickerProviderStateMixin, ChatAnimationMixin {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  final RxString message = ''.obs;
  final RxList<ChatModel> messages = <ChatModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isListening = false.obs;
  final RxBool autoScroll = true.obs;
  var userScrolledManually = false.obs;
  bool userScrolledUp = false;

  final speechService = SpeechToTextService();
  final ttsService = TextToSpeechService();
  final permissionService = PermissionService();

  @override
  void onInit() async {
    super.onInit();
    messages.add(AppConstants.defaultChatMessage);
    messages.listen((_) => scrollExtent());
    messages.last.isFirstMessage = false;
    messages.last.isStreaming.value = false;

    initAnimations(this);
  }

  void listenForUserScroll() {
    scrollController.addListener(() {
      final atBottom = scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50;
      if (!atBottom) {
        userScrolledUp = true;
      } else {
        userScrolledUp = false;
      }
      if (!userScrolledUp) {
        autoScroll.value = true;
      }
    });
  }

  Future<void> sendMessage(String text) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (text.trim().isEmpty) return;

    messageController.clear();
    message.value = "";

    await Future.delayed(const Duration(milliseconds: 100));
    autoScroll.value = true;

    final userMessage = ChatModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);

    scrollExtent();

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
          // scrollExtent();
          addedAIMessage = true;
        }

        aiMessage.streamingText.value += chunk;
        // scrollExtent();
      }

      aiMessage.text = aiMessage.streamingText.value;
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
    if (scrollController.hasClients && autoScroll.value && !userScrolledUp) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> speak(ChatModel message) async {
    try {
      message.isSpeaking.value = true;
      await ttsService.speak(text: message.text);
      message.isSpeaking.value = false;
    } catch (e) {
      debugPrint("TTS Error: ${e.toString()}");
    }
  }

  Future<void> stopSpeaking(ChatModel message) async {
    try {
      await ttsService.stop();
      message.isSpeaking.value = false;
    } catch (e) {
      debugPrint("TTS Stop Error: ${e.toString()}");
    }
  }

  Future<void> copyToClipboard(ChatModel message) async {
    if (message.isCopied.value) return;
    message.isCopied.value = true;

    await ClipboardHelper.copyToClipboard(message.text);

    Future.delayed(const Duration(seconds: 2), () {
      message.isCopied.value = false;
    });
  }

  Future<void> listen() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (messageController.text.isNotEmpty) {
      messageController.clear();
      message.value = "";
    }

    final hasPermission = await permissionService.requestMicrophonePermission();
    if (!hasPermission) return;

    if (!isListening.value) {
      final available = await speechService.initialize(
        onStatus: (status) {
          if (status == 'done') isListening.value = false;
        },
        onError: (error) {
          SnackbarHelper.showWarning(error.errorMsg);
          isListening.value = false;
        },
      );

      if (available) {
        isListening.value = true;
        speechService.listen((recognizedText) {
          messageController.text = recognizedText;
          message.value = recognizedText;
        });
      }
    } else {
      stopListening();
    }
  }

  void stopListening() {
    if (isListening.value) {
      isListening.value = false;
      speechService.stop();
    }
  }

  void newChat() {
    messages.clear();
    messages.add(AppConstants.defaultChatMessage);
  }

  @override
  void onClose() {
    ttsService.stop();
    messageController.dispose();
    focusNode.dispose();
    disposeAnimations();
    super.onClose();
  }
}
