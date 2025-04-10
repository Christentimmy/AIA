// import 'dart:async';
// import 'package:aia/app/modules/chat/controller/chat_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
// import 'package:record/record.dart';

// class SpeechController extends GetxController {
//   late Deepgram _speechToText;
//   var recognizedText = ''.obs;
//   final String deepgramApiKey = '251a3d7152e520f16835ccb45ae82512654fbeae';
//   StreamSubscription<DeepgramListenResult>? _streamSubscription;
//   Stream<List<int>>? _micStream;
//   // final chatController = Get.find<ChatController>();

//   @override
//   void onInit() {
//     super.onInit();
//     _speechToText = Deepgram(deepgramApiKey);
//   }

//   Future<String?> startListening() async {
//     recognizedText.value = '';
//     try {
//       _micStream = await AudioRecorder().startStream(const RecordConfig(
//         encoder: AudioEncoder.pcm16bits,
//         sampleRate: 16000,
//         numChannels: 1,
//       ));
//       Stream<DeepgramListenResult> stream =
//           _speechToText.listen.live(_micStream!);
//       _streamSubscription = stream.listen((res) {
//         print(res.transcript);
//         recognizedText.value += res.transcript ?? "";
//       }, onError: (e) {
//         debugPrint(e.toString());
//       }, onDone: () {
//         debugPrint('Stream closed');
//         _streamSubscription?.cancel();
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//     return null;
//   }

//   void stopListening() async {
//     try {
//       await AudioRecorder().stop();
//       await _streamSubscription?.cancel();
//       chatController.isListening.value = false;
//       chatController.messageController.text = recognizedText.value;
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   @override
//   void onClose() {
//     super.onClose();
//     stopListening();
//   }
// }
