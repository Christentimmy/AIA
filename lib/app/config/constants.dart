import 'package:aia/app/modules/chat/data/models/chat_model.dart';
import 'package:get/get.dart';

class AppConstants {
  // Ring sizes
  static double ringWidth = Get.width * 0.78;
  static double ringHeight = Get.height * 0.359;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(seconds: 1);

  static final ChatModel defaultChatMessage = ChatModel(
    text: "Hello, I'm AIA. How can I assist you today?",
    isUser: false,
    timestamp: DateTime.now(),
    isFirstMessage: true,
    isStreaming: true.obs,
  );
}
