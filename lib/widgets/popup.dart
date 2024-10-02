import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import '../controllers/chatcontroller.dart'; // Ensure the correct ChatController import

class IconPopup extends StatefulWidget {
  const IconPopup({super.key});

  @override
  State<IconPopup> createState() => _IconPopupState();
}

class _IconPopupState extends State<IconPopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ChatController>().onClear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return Wrap(
      children: [
        Container(
          // height: 278,
          // width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Card(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconCreation(Icons.insert_drive_file_outlined,
                          Colors.indigo, 'Document', () {
                        chatController.sendFile(true, DateTime.now());
                        Navigator.pop(context);
                      }),
                      const SizedBox(
                        width: 30,
                      ),
                      iconCreation(
                          Icons.camera_alt_outlined, Colors.pink, 'Camera', () {
                        chatController.sendImageFromCamera(
                            true, DateTime.now());
                        Navigator.pop(context);
                      }),
                      const SizedBox(
                        width: 30,
                      ),
                      iconCreation(
                          Icons.insert_photo_outlined, Colors.purple, 'Gallery',
                          () {
                        chatController.sendFromGallery(true, DateTime.now());
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconCreation(
                          Icons.headset_outlined, Colors.orange, 'Audio', () {
                        chatController.sendAudio(true, DateTime.now());
                        Navigator.pop(context);
                      }),
                      const SizedBox(
                        width: 30,
                      ),
                      iconCreation(Icons.person_outlined, Colors.blue,
                          'Contacts', () {}),
                      const SizedBox(
                        width: 30,
                      ),
                      iconCreation(
                          Icons.location_pin, Colors.blue, 'Contacts', () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget iconCreation(IconData icon, Color color, String text, Function ontap) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          ontap();
        },
        child: CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: Icon(
            color: Colors.white,
            icon,
            size: 29,
          ),
        ),
      ),
      Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      )
    ],
  );
}
