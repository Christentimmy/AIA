import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:aia/app/modules/chat/controller/chat_controller.dart';
import 'package:aia/app/modules/chat/data/models/chat_model.dart';
import 'package:aia/app/modules/chat/widgets/chat_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      drawer: const BuildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF0A2239), // Dark blue background
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background effects
            Positioned.fill(
              child: Obx(
                () => _buildBackgroundEffects(
                    controller.backgroundAnimValue.value),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // App bar
                  _buildAppBar(),

                  // Chat messages
                  Expanded(
                    child: _buildMessagesList(controller),
                  ),

                  // Input area
                  _buildInputArea(controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundEffects(double animValue) {
    return CustomPaint(
      size: Size.infinite,
      painter: ChatBackgroundPainter(
        progress: animValue,
        primaryColor: const Color(0xFF4FACFE),
        secondaryColor: const Color(0xFF00F2FE),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // Back button
          Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            );
          }),

          const Spacer(),

          // Title
          Text(
            "AIA",
            style: GoogleFonts.orbitron(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(ChatController controller) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        itemCount: controller.messages.length,
        reverse: false,
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          return _buildMessageItem(
            message,
            controller,
            ValueKey(message.timestamp.toString()),
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(
    ChatModel message,
    ChatController controller,
    Key key,
  ) {
    if (message.isTyping) {
      return _buildTypingIndicator(controller);
    }

    return KeyedSubtree(
      key: key,
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: message.isUser
                ? const Color(0xFF4FACFE)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
            boxShadow: message.isUser
                ? [
                    BoxShadow(
                      color: const Color(0xFF4FACFE).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message text
                (!message.isUser && message.isStreaming) ||
                        message.isFirstMessage
                    ? StreamingTypewriterText(
                        text: message.text,
                        messageModel: message,
                        textStyle: GoogleFonts.rajdhani(
                          textStyle: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      )
                    : Text(
                        message.text,
                        style: GoogleFonts.rajdhani(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),

                const SizedBox(height: 4),

                // Timestamp
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white.withOpacity(0.7)
                          : Colors.white.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ChatController controller) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Obx(() {
        final animValue = controller.animationValue.value;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              final delay = index * 0.2;
              final offset = (animValue + delay) % 1.0;
              final size = 4 + 4 * sin(offset * pi);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: const Color(0xFF4FACFE)
                      .withOpacity(0.6 + 0.4 * sin(offset * pi)),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildInputArea(ChatController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // Text field in a glass container
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Attachment button as prefixIcon
                      IconButton(
                        icon: Icon(
                          Icons.attach_file,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        onPressed: () {},
                      ),

                      // Text field
                      Expanded(
                        child: TextField(
                          controller: controller.messageController,
                          focusNode: controller.focusNode,
                          onChanged: (value) =>
                              controller.message.value = value,
                          style: GoogleFonts.rajdhani(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                          ),
                          cursorColor: const Color(0xFF4FACFE),
                          maxLines: 3,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          // expands: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Smart button (Mic / Loading / Send)
          Obx(() {
            final isTextEmpty = controller.message.isEmpty;
            final isLoading = controller.isLoading.value;
            Icon icon;
            VoidCallback? onPressed;

            if (isLoading) {
              icon = const Icon(Icons.hourglass_bottom, color: Colors.white);
              onPressed = null;
            } else if (isTextEmpty) {
              icon = Icon(Icons.mic, color: Colors.white.withOpacity(0.8));
              onPressed = () {};
            } else {
              icon = const Icon(Icons.send, color: Colors.white);
              onPressed = () {
                controller.sendMessage(controller.messageController.text);
              };
            }

            return Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                ),
                boxShadow: [
                  if (isLoading)
                    BoxShadow(
                      color: const Color(0xFF4FACFE).withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: IconButton(
                icon: icon,
                onPressed: onPressed,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 7, 6, 6),
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 20,
        ),
        children: [
          const SizedBox(height: 20),
          // Title
          Row(
            children: [
              Text(
                "AIA",
                style: GoogleFonts.orbitron(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),

          ListTile(
            leading: const Icon(
              Icons.chat_bubble,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'AI Session 1',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'AI Session 2',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class StreamingTypewriterText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final ChatModel messageModel;

  const StreamingTypewriterText({
    super.key,
    required this.text,
    required this.textStyle,
    required this.messageModel,
  });

  @override
  _StreamingTypewriterTextState createState() =>
      _StreamingTypewriterTextState();
}

class _StreamingTypewriterTextState extends State<StreamingTypewriterText> {
  String _displayText = '';
  String lastText = '';
  Timer? _timer;
  int _typingPosition = 0;
  final Duration _typingSpeed = const Duration(milliseconds: 5);
  final chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(StreamingTypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _startTyping();
    } else {
      widget.messageModel.isStreaming = false;
    }
  }

  void _startTyping() {
    lastText = widget.text;
    _timer?.cancel();

    // If we're already typing, continue from where we left off
    if (_typingPosition < widget.text.length) {
      _timer = Timer.periodic(_typingSpeed, (timer) {
        setState(() {
          if (_typingPosition < widget.text.length) {
            _displayText = widget.text.substring(0, _typingPosition + 1);
            _typingPosition++;

            chatController.scrollExtent();
          } else {
            _timer?.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
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
