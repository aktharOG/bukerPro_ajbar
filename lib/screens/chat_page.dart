import 'dart:io';
import 'package:buktorgrow/widgets/chat_text_field.dart';
import 'package:buktorgrow/widgets/voicemessagebubble.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:open_file/open_file.dart';
import '../models/conversationModel.dart';

import '../controllers/chatcontroller.dart'; // Ensure the correct import

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
    required this.selectedUsers,
  });

  final selectedUsers;

  @override
  Widget build(BuildContext context) {
    final TextEditingController msgcontroller = TextEditingController();
    final ChatController chatController = Get.find<ChatController>();

    // Request microphone permission when the page starts
    chatController.checkAndRequestPermission();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedUsers.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: const Color(0xff5473bb),
        actions: [
          IconButton(
            onPressed: () {
              chatController.makePhoneCall('+919633624558');
            },
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {
              chatController.makePhoneCall('+919633624558');
            },
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          // Error handling (show Snackbar when there's an error)
          Obx(() {
            if (chatController.errorMessage.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(chatController.errorMessage.value),
                    backgroundColor: Colors.red,
                  ),
                );
                chatController.clearError(); // Clear the error after showing it
              });
            }
            return Container(); // Return an empty container if no error
          }),

          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return const Center(
                  child: Text(
                    "No messages yet",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  reverse: true,
                  itemCount: chatController.messages.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  itemBuilder: (context, index) {
                    final message = chatController
                        .messages[chatController.messages.length - 1 - index];
                    return _buildMessageBubble(message, context);
                  },
                );
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 20, 40),
            child: ChatTextField(msgcontroller: msgcontroller),
          ),
        ],
      ),
    );
  }
}

Widget _buildMessageBubble(ChatMessage message, BuildContext context) {
  if (message.filePath != null) {
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: _buildFileWidget(message, context),
      ),
    );
  }

  // For audio message
  return message.audiofile != null
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: VoiceMessageBubble(
            audioSrc: message.audiofile ?? '',
            dateTime: message.dateTime,
            isSentByMe: message.isSentByMe,
          ),
        )
      : Align(
          alignment:
              message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color:
                  message.isSentByMe ? const Color(0xff5473bb) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width *
                          0.7, // Set max width to 70% of the screen width
                    ),
                    child: Text(
                      message.message ?? "",
                      style: TextStyle(
                        color: message.isSentByMe ? Colors.white : Colors.black,
                        fontSize: 15,
                      ),
                      softWrap: true, // Allow text to wrap onto multiple lines
                      overflow: TextOverflow
                          .visible, // Ensure overflow is handled correctly
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('hh:mm a').format(message.dateTime),
                      style: TextStyle(
                        color: message.isSentByMe ? Colors.white : Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
}

Widget _buildFileWidget(ChatMessage message, context) {
  if (message.fileType == FileType.image && message.filePath != null) {
    return GestureDetector(
      onTap: () {
        final imageProvider = FileImage(File(message.filePath!));
        showImageViewer(context, imageProvider, onViewerDismissed: () {});
      },
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xff5473bb),
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.file(
                File(message.filePath!),
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
              Text(
                DateFormat('hh:mm a').format(message.dateTime),
                style: const TextStyle(color: Colors.black, fontSize: 10),
              ),
            ],
          ),
        ),
      ]),
    );
  } else if (message.fileType == FileType.audio && message.filePath != null) {
    return VoiceMessageBubble(
      audioSrc: message.filePath ?? '',
      dateTime: message.dateTime,
      isSentByMe: message.isSentByMe,
    );
  } else {
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isSentByMe ? const Color(0xff5473bb) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_file, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  message.fileName ?? 'Unknown file',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            TextButton(
                onPressed: () async {
                  final result = await OpenFile.open(message.filePath!);
                  if (result.message != 'The file is opened.') {
                    // Handle error or show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Opening file: ${message.fileName}')),
                    );
                  }
                },
                child: const Text('Open File')),
          ],
        ),
      ),
    );
  }
}
