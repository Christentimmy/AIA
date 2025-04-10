import 'package:aia/app/modules/chat/widgets/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../controller/chat_controller.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/background_effects.dart';
import '../widgets/input_area.dart';
import '../widgets/listening_overlay.dart';
import '../widgets/messages_list.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final FlutterTts flutterTts = FlutterTts();
  final controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    controller.listenForUserScroll();
    return Scaffold(
      backgroundColor: const Color(0xFF0A2239),
      resizeToAvoidBottomInset: false,
      drawer: const BuildDrawer(),
      body: Container(
        decoration: _backgroundDecoration(),
        child: Stack(
          children: [
            Obx(
              () => BackgroundEffects(
                animValue: controller.backgroundAnimValue.value,
              ),
            ),

            _buildChatComponents(context),

            // Listening overlay
            Obx(
              () => controller.isListening.value
                  ? ListeningOverlay(
                      onTap: controller.stopListening,
                    )
                  : const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChatComponents(BuildContext context) {
    // Get keyboard height when it's visible
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Obx(
      () => Opacity(
        opacity: controller.isListening.value ? 0.1 : 1.0,
        child: SafeArea(
          child: Column(
            children: [
              ChatAppBar(),
              Expanded(
                child: MessagesListView(
                  controller: controller,
                ),
              ),
              // Add bottom padding equal to keyboard height
              Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: ChatInputArea(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _backgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black,
          Color(0xFF0A2239),
        ],
      ),
    );
  }
}
