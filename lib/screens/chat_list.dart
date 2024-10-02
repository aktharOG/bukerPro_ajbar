import 'package:buktorgrow/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../controllers/chatList_controller.dart';
import '../controllers/login_controller.dart';
import 'chat_page.dart';

class ChatList extends StatefulWidget {
  const ChatList({
    super.key,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  // Initialize ChatListController and LoginController
  final ChatlistController chatListController = Get.put(ChatlistController());
  final LoginController authController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch the chat list when the page loads
      int organizationId = 3; // Example organization ID
      String userToken = authController.userToken.value;
    
      chatListController.loadChatList(organizationId, userToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff5473bb),
        title: Text(
          'Chats',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      drawer: const CustDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Name or Number',
                hintStyle: TextStyle(fontSize: 15),
                prefixIcon: Icon(Icons.search),
                enabledBorder: border,
                focusedBorder: border,
              ),
            ),
          ),
          // Use Obx to update the UI based on the ChatController state
          Expanded(
            child: Obx(() {
              // Show loading indicator while the data is being fetched
              if (chatListController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Show error message if there's an error
              if (chatListController.errorMessage.isNotEmpty) {
                return Center(
                    child: Text(chatListController.errorMessage.value));
              }

              // Display the chat list if data is available
              if (chatListController.chatList.value.data == null ||
                  chatListController.chatList.value.data!.data!.isEmpty) {
                return const Center(child: Text("No chats available."));
              }

              // If data is available, display the chat list
              return ListView.builder(
                itemCount:
                    chatListController.chatList.value.data!.data!.length,
                itemBuilder: (context, index) {
                  final chat = chatListController.chatList.value.data!.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        child: Text(chat.id.toString()), // Display chat ID or avatar
                      ),
                      title: Text(
                        chat.fullName ?? 'Unknown', // Display chat full name
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        chat.phone ?? 'No phone number', // Display phone number
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      trailing: Text(
                        DateFormat('hh:mm a').format(chat.latestChatCreatedAt!), // Display latest chat time
                        style: const TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        // Navigate to the ChatPage when tapped
                        Get.to(() => ChatPage(selectedUsers: chat));
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff5473bb),
        onPressed: () {
          // Handle FAB pressed action
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
