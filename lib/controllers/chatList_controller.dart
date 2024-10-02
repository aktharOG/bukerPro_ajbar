import 'dart:developer';

import 'package:get/get.dart';

import '../models/chat_list_Model.dart';
import '../services/api_services.dart'; // Adjust path

class ChatlistController extends GetxController {
  var chatList = ChatListModel().obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentPage = 1; // Track the current page
  var hasMoreData = true.obs; // Flag to check if more data is available
  final int itemsPerPage = 20; // Number of items to load per page

  final ApiServices _apiService = ApiServices();

  // Method to load the first page of chat list
  Future<void> loadChatList(int organizationId, String userToken) async {
    currentPage = 1; // Reset page number for a fresh load
    hasMoreData.value = true; // Reset the flag
    chatList.value = ChatListModel(); // Clear previous data
    await _fetchChatList(organizationId, userToken, currentPage,false);
  }

  // Method to load more chat list items (pagination)
  Future<void> loadChatListMore(int organizationId, String userToken) async {
    if (!hasMoreData.value || isLoading.value) return; // Stop if no more data or already loading
    currentPage++; // Increment page for the next set of data
    await _fetchChatList(organizationId, userToken, currentPage,true);
  }

  // Helper method to fetch chat list data
  Future<void> _fetchChatList(int organizationId, String userToken, int page,hideLoading) async {
    log("Fetching page $page for organizationId = $organizationId with userToken = $userToken");

    try {
      if(!hideLoading){
isLoading.value = true;
      }
      
      errorMessage.value = ''; // Clear previous errors

      // Fetch the chat list from the API
      ChatListModel? fetchedChatList =
          await _apiService.fetchChatList(organizationId, userToken, page);

      if (fetchedChatList != null && fetchedChatList.data != null) {
        if (fetchedChatList.data!.data!.isEmpty) {
          hasMoreData.value = false; // No more data to load
        } else {
          // Append new data to the existing list
          if (page == 1) {
            chatList.value = fetchedChatList; // For the first page, replace the list
          } else {
            // Append new data for subsequent pages
            chatList.update((val) {
              val?.data?.data?.addAll(fetchedChatList.data!.data!);
            });
          }
        }
      } else {
        errorMessage.value = 'Failed to fetch chat list.';
        hasMoreData.value = false; // Stop further pagination on error
      }
    } catch (e) {
      errorMessage.value = 'Error occurred: $e';
      hasMoreData.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
