import 'dart:developer';

import 'package:get/get.dart';

import '../models/chat_list_Model.dart';
import '../services/api_services.dart'; // Adjust path

class ChatlistController extends GetxController {
  // Observable variables for the chat list, loading state, and error message


  // initstate 



  var chatList = ChatListModel().obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final ApiServices _apiService = ApiServices();




  // Method to load the chat list
  Future<void> loadChatList(int organizationId, String userToken) async {
    log("body item : organizationId = $organizationId userToken = $userToken");
    try {
      // Set loading state to true
      isLoading.value = true;
      errorMessage.value = ''; // Clear previous errors

      // Fetch the chat list from the API
      ChatListModel? fetchedChatList =
          await _apiService.fetchChatList(organizationId, userToken);

      if (fetchedChatList != null) {
        // Update the chat list if data is successfully fetched
        chatList.value = fetchedChatList;
      } else {
        // Set an error message if something went wrong
        errorMessage.value = 'Failed to fetch chat list.';
      }
    } catch (e) {
      // Catch any exceptions and set the error message
      errorMessage.value = 'Error occurred: $e';
    } finally {
      // Set loading state to false
      isLoading.value = false;
    }

  }
}
