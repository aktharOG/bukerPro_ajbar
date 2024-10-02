import 'dart:async';
import 'dart:io';
import 'package:buktorgrow/models/chatModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/conversationModel.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var messages = <ChatMessage>[].obs; // RxList of messages
  final AudioPlayer _audioPlayer = AudioPlayer(); // Just Audio player
  final AudioRecorder _audioRecorder =
      AudioRecorder(); // For audio recording on mobile
  var filePath = Rx<String>(''); // File path of the audio or file message
  var isRecording = false.obs; // To track recording status
  var isPlaying = false.obs; // To track playback status
  var errorMessage = ''.obs; // To handle errors
  var chatModel = <ChatModel>[].obs;
  final ImagePicker _picker = ImagePicker();
  var selectedChatModel = Rxn<ChatModel>();
  var isPermissionDenied = false.obs;
  var isTextFieldEmpty = true.obs;
  var recordingDuration = 0.obs;
  Timer? _timer;
  // Initially true

  // Update based on text field input changes

  // List of chat models

  // Handle chat and messages
  void setSelectedChat(ChatModel chatModel) {
    selectedChatModel.value = chatModel;
  }

  void setChat(List<ChatMessage> messages) {
    this.messages.assignAll(messages);
  }

  void clearError() {
    errorMessage.value = '';
  }

  void updateTextFieldStatus(String input) {
    isTextFieldEmpty.value = input.trim().isEmpty;
  }

  // Send image from the camera
  Future<void> sendImageFromCamera(bool isSentByMe, DateTime dateTime) async {
    if (kIsWeb) {
      errorMessage.value = 'Camera access is not supported on web.';
    } else {
      try {
        final XFile? capturedImage =
            await _picker.pickImage(source: ImageSource.camera);
        if (capturedImage != null) {
          String? filePath = capturedImage.path;
          String fileName = capturedImage.name;
          FileType fileType = _determineFileType('jpg');

          messages.add(ChatMessage(
            message: '',
            isSentByMe: isSentByMe,
            filePath: filePath,
            fileName: fileName,
            fileType: fileType,
            dateTime: dateTime,
          ));
          errorMessage.value = '';
        } else {
          errorMessage.value = 'No image selected.';
        }
      } catch (e) {
        errorMessage.value = 'Failed to capture image: $e';
      }
    }
  }

  // Pick image from gallery
  Future<void> sendFromGallery(bool isSentByMe, DateTime dateTime) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        String filename = result.files.single.name;
        FileType filetype = _determineFileType('jpg');

        messages.add(ChatMessage(
          message: '',
          isSentByMe: isSentByMe,
          filePath: filePath,
          fileName: filename,
          fileType: filetype,
          dateTime: dateTime,
        ));
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick image from gallery: $e';
    }
  }

  // Send files (works across platforms)
  Future<void> sendFile(bool isSentByMe, DateTime dateTime) async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        String filename = result.files.single.name;
        FileType fileType = _determineFileType(result.files.single.extension);
        messages.add(ChatMessage(
          message: '',
          isSentByMe: isSentByMe,
          filePath: filePath,
          fileName: filename,
          fileType: fileType,
          dateTime: dateTime,
        ));
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick file: $e';
    }
  }

  // Send audio (web handles file picking, mobile handles recording)
  Future<void> sendAudio(bool isSentByMe, DateTime dateTime) async {
    if (!kIsWeb) {
      // Handle audio file upload for the web
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.audio,
        );
        if (result != null && result.files.single.path != null) {
          String filePath = result.files.single.path!;
          String filename = result.files.single.name;
          FileType fileType = _determineFileType(result.files.single.extension);
          messages.add(ChatMessage(
            message: '',
            isSentByMe: isSentByMe,
            filePath: filePath,
            fileName: filename,
            fileType: fileType,
            dateTime: dateTime,
          ));
        }
      } catch (e) {
        errorMessage.value = 'Failed to pick audio file: $e';
      }
    } else {
      // Handle audio recording for mobile platforms
      errorMessage.value = 'Audio  access is not supported on web.';
    }
  }

  // Send a message (text, file, or audio)
  void sendMessage(String? message, bool isSentByMe, DateTime dateTime,
      {String? filePath}) {
    messages.add(ChatMessage(
      audiofile: filePath,
      message: message,
      isSentByMe: isSentByMe,
      dateTime: dateTime,
    ));

    // Simulate a response if a message is sent
    if (isSentByMe && filePath == null) {
      _simulateResponse(dateTime);
    }

    // Reset file path if a file is sent
    if (filePath != null) {
      this.filePath.value = '';
      updateTextFieldStatus('');
    }
  }

  // Simulate an auto-response for demo purposes
  void _simulateResponse(DateTime dateTime) {
    Future.delayed(const Duration(seconds: 2), () {
      messages.add(ChatMessage(
        message: "Automated response",
        isSentByMe: false,
        dateTime: dateTime,
      ));
    });
  }

  // Request Microphone Permission

  // Audio recording logic for Android/iOS
  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return false; // No need to request on web
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  Future<void> checkAndRequestPermission() async {
    var status = await Permission.microphone.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      // Update permission status
      isPermissionDenied.value = true;
      // Request permission
      await Permission.microphone.request();
      // Re-check the permission status
      status = await Permission.microphone.status;
      isPermissionDenied.value = status.isDenied;
    } else {
      isPermissionDenied.value = false;
    }
  }

  Future<void> startRecording() async {
    if (kIsWeb) {
      errorMessage.value = 'Audio recording is not supported on web.';
      return;
    }

    // Ensure permission is granted before starting recording
    if (await _audioRecorder.hasPermission()) {
      String? directoryPath;
      if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        directoryPath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      }

      String filePath = directoryPath ?? ''; // Assign the path

      try {
        await _audioRecorder.start(const RecordConfig(),
            path: filePath); // Start recording
        isRecording.value = true;
        recordingDuration.value = 0; // Reset timer

        // Start a timer to count seconds
        _timer = Timer.periodic(const Duration(seconds: 01), (timer) {
          recordingDuration.value++; // Increment timer every second
        }); // Update recording status
      } catch (e) {
        errorMessage.value = 'Failed to start recording: $e';
      }
    } else {
      errorMessage.value = 'Microphone permission denied';
    }
  }

  void onLongPressHandler() async {
    // Only start recording if permission has already been granted
    if (await _audioRecorder.hasPermission()) {
      startRecording();
    } else {
      errorMessage.value = 'Microphone permission denied or not requested.';
    }
  }

  void onTapHandler() async {
    // Request permission separately before allowing recording on long press
    await checkAndRequestPermission();
  }
  // Stop Recording

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    try {
      final path = await _audioRecorder.stop();
      if (path != null) {
        filePath.value = path;
        // sendMessage(null, true, DateTime.now(), filePath: filePath.value);
      }
      isRecording.value = false;

      _timer?.cancel();
    } catch (e) {
      errorMessage.value = 'Failed to stop recording: $e';
    }
  }

  // Audio playback (works across platforms)
  Future<void> playAudio(String audioFilePath) async {
    try {
      isPlaying.value = true;
      await _audioPlayer.setFilePath(audioFilePath);
      _audioPlayer.play();
    } catch (e) {
      errorMessage.value = 'Failed to play audio: $e';
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      isPlaying.value = false;
      // _timer?.cancel();
    } catch (e) {
      errorMessage.value = 'Failed to stop audio: $e';
    }
  }

  void deleteRecordedAudio() {
    if (filePath.value.isNotEmpty) {
      try {
        // Delete the audio file from the system if it exists
        File(filePath.value).deleteSync();
        filePath.value = ''; // Clear the file path
        isRecording.value = false; // Reset recording status
        errorMessage.value = 'Recorded audio has been deleted.';
      } catch (e) {
        errorMessage.value = 'Failed to delete audio: $e';
      }
    } else {
      errorMessage.value = 'No audio recorded to delete.';
    }
  }

  // Clear audio data
  void onClear() {
    filePath.value = '';
    errorMessage.value = '';
    stopRecording();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _audioRecorder.dispose();

    super.onClose();
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Handle error when the phone call cannot be made
      errorMessage('Could not launch $launchUri');
    }
  }
}

// Determine file type based on file extension (works across platforms)
FileType _determineFileType(String? extension) {
  if (extension == null) return FileType.any;
  if (['jpg', 'jpeg', 'png', 'gif'].contains(extension.toLowerCase())) {
    return FileType.image;
  }
  if (['mp3', 'wav', 'm4a', 'opus'].contains(extension.toLowerCase())) {
    return FileType.audio;
  }
  return FileType.any;
}
