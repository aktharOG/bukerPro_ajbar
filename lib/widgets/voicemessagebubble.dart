import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voice_message_package/voice_message_package.dart';

class VoiceMessageBubble extends StatelessWidget {
  final String audioSrc;
  final DateTime dateTime;
  final bool isSentByMe;

  const VoiceMessageBubble({
    super.key,
    required this.audioSrc,
    required this.dateTime,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(alignment: Alignment.bottomRight, children: [
            VoiceMessageView(
              playIcon: const Icon(
                Icons.play_arrow,
                size: 30,
              ),
              backgroundColor: const Color(0xff5473bb),
              circlesColor: Colors.green,
              activeSliderColor: Colors.green,
              controller: VoiceController(
                maxDuration: const Duration(minutes: 5),
                isFile: true,
                audioSrc: audioSrc,
                onComplete: () {
                  // Do something on complete
                },
                onPause: () {
                  // Do something on pause
                },
                onPlaying: () {
                  // Do something on playing
                },
                onError: (err) {
                  // Do something on error
                },
              ),
              innerPadding: 12,
              cornerRadius: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat('hh:mm a').format(dateTime),
                style: const TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
