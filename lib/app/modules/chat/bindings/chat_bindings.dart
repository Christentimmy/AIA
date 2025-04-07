import 'package:aia/app/modules/chat/controller/chat_controller.dart';
import 'package:get/get.dart';

class ChatBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
  }
}