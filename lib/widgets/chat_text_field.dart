import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:voice_message_package/voice_message_package.dart';
import '../controllers/chatcontroller.dart';
import 'popup.dart'; // Adjust based on your popup import path

class ChatTextField extends StatelessWidget {
  ChatTextField({super.key, required TextEditingController msgcontroller})
      : _msgcontroller = msgcontroller;

  final TextEditingController _msgcontroller;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                ],
              ),
              child: Obx(() {
                if (!chatController.isRecording.value &&
                    chatController.filePath.isEmpty) {
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.face,
                          color: Color(0xff5473bb),
                        ),
                        onPressed: () {
                          // Add any functionality for face/emojis here
                        },
                      ),
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          focusNode: _focusNode,
                          onChanged: (text) {
                            chatController.updateTextFieldStatus(text);
                          },
                          controller: _msgcontroller,
                          decoration: const InputDecoration(
                            hintText: "Message...",
                            hintStyle: TextStyle(color: Color(0xff5473bb)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.photo_camera,
                          color: Color(0xff5473bb),
                        ),
                        onPressed: () {
                          _focusNode.requestFocus();
                          chatController.sendImageFromCamera(
                              true, DateTime.now());
                          _focusNode.unfocus();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file,
                            color: Color(0xff5473bb)),
                        onPressed: () {
                          _focusNode.requestFocus();
                          _showIconPopup(context);
                          _focusNode.unfocus();
                        },
                      ),
                    ],
                  );
                } else if (chatController.isRecording.isTrue) {
                  // Show the recording timer here
                  return Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Obx(() {
                            // Convert the duration into minutes and seconds format
                            final minutes =
                                (chatController.recordingDuration.value ~/ 60)
                                    .toString()
                                    .padLeft(2, '0');
                            final seconds =
                                (chatController.recordingDuration.value % 60)
                                    .toString()
                                    .padLeft(2, '0');
                            return Center(
                              child: Text(
                                " Recording    $minutes:$seconds",
                                style: const TextStyle(
                                    color: Color(0xff5473bb),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                textAlign: TextAlign.left,
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  );
                } else if (chatController.filePath.isNotEmpty &&
                    !chatController.isRecording()) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 28,
                        icon: const CircleAvatar(
                            child: Center(
                                child:
                                    Icon(Icons.delete, color: Colors.black))),
                        onPressed: () async {
                          chatController.deleteRecordedAudio();
                        },
                      ),
                      VoiceMessageView(
                        //size: ,
                        activeSliderColor: Colors.green,
                        circlesColor: Colors.black,
                        controller: VoiceController(
                          maxDuration: const Duration(minutes: 5),
                          isFile: true,
                          audioSrc: chatController.filePath.value,
                          onComplete: () {},
                          onPause: () {},
                          onPlaying: () {},
                          onError: (err) {},
                        ),
                        innerPadding: 12,
                        cornerRadius: 20,
                      ),
                      IconButton(
                        iconSize: 28,
                        icon: const CircleAvatar(
                            child: Center(
                                child: Icon(Icons.send, color: Colors.black))),
                        onPressed: () async {
                          chatController.sendMessage(null, true, DateTime.now(),
                              filePath: chatController.filePath.value);
                        },
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ),
          const SizedBox(width: 5),
          Obx(() {
            return GestureDetector(
              onTap: () {
                if (chatController.isTextFieldEmpty.value) {
                  chatController.onTapHandler();
                } else {
                  if (_msgcontroller.text.trim().isNotEmpty) {
                    chatController.sendMessage(
                        _msgcontroller.text, true, DateTime.now());

                    _msgcontroller.clear();
                    chatController.updateTextFieldStatus('');
                  }
                }
              },
              onLongPress: () {
                if (chatController.isTextFieldEmpty.value) {
                  chatController.onLongPressHandler();
                }
              },
              onLongPressUp: () {
                chatController.stopRecording();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: chatController.isRecording.value
                    ? const EdgeInsets.all(
                        20.0) // Larger padding when recording
                    : const EdgeInsets.all(15.0), // Normal padding
                decoration: const BoxDecoration(
                    color: Color(0xff5473bb), shape: BoxShape.circle),
                child: Icon(
                  chatController.isTextFieldEmpty.value
                      ? Icons.mic
                      : Icons.send,
                  color: Colors.white,
                  size: chatController.isRecording.value
                      ? 40 // Larger icon when recording
                      : 24, // Normal icon size
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showIconPopup(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return IconPopup();
      },
    );
  }
}
