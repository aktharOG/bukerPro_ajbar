import 'package:buktorgrow/screens/chat_list.dart';
import 'package:buktorgrow/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustDrawer extends StatelessWidget {
  const CustDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 100,
                      child: Image.network(
                          'https://media.istockphoto.com/id/1857528212/vector/beautiful-woman-doctor-in-a-lab-coat-with-a-stethoscope.jpg?s=2048x2048&w=is&k=20&c=vlm0peV18DM5Vt7qI-97x9GbkyhUORrp-LOTBcy0A3Q=')),
                  Text(
                    'book',
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              )),
          ListTile(
            leading: TextButton(
                onPressed: () {
                  Get.to(() => const ChatList());
                },
                child: Text(
                  'Chats',
                  style: Theme.of(context).textTheme.titleMedium,
                )),
          ),
          ListTile(
            leading: TextButton(
                onPressed: () {},
                child: Text(
                  'calls',
                  style: Theme.of(context).textTheme.titleMedium,
                )),
          ),
          ListTile(
            leading: TextButton(
                onPressed: () async {
                  Get.to(() => LoginPage());
                  Get.to(LoginPage());
                },
                child: Text(
                  'logout',
                  style: Theme.of(context).textTheme.titleMedium,
                )),
          )
        ],
      ),
    );
  }
}
