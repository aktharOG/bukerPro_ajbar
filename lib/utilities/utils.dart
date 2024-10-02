import 'package:flutter/material.dart';

class TextFieldTest extends StatelessWidget {
  const TextFieldTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(15.0),
        height: 61,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                        icon: const Icon(
                          Icons.face,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {}),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Type Something...",
                            hintStyle: TextStyle(color: Colors.blueAccent),
                            border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo_camera,
                          color: Colors.blueAccent),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file,
                          color: Colors.blueAccent),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: const BoxDecoration(
                  color: Colors.blueAccent, shape: BoxShape.circle),
              child: InkWell(
                child: const Icon(
                  Icons.keyboard_voice,
                  color: Colors.white,
                ),
                onLongPress: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
