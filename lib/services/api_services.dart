import 'package:buktorgrow/services/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat_list_Model.dart';
import '../utilities/SharedPreferences.dart';

class ApiServices {
  final String apiUrl = Apis.login;
  String? _token;

  // Login method to authenticate and store the Bearer token
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${keys.key}',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _token = responseData['user_token'];

        // Store the token using SharedPrefsHelper
        await SharedPrefs.saveToken(_token!);

        print("Bearer Token: $_token saved to SharedPreferences");
        return true;
      } else {
        print("Login failed with status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error during login: $e");
      return false;
    }
  }

  // Logout method to clear the token
  Future<void> logout() async {
    await SharedPrefs.removeToken(); // Remove the token using SharedPrefsHelper
    _token = null;
    print("Logged out. Token removed from SharedPreferences.");
  }

  // Fetch chat list method
  Future<ChatListModel?> fetchChatList(
      int organizationId, String userToken,page) async {
    try {
      const String chatApi = Apis.chats;
      final response = await http.post(
        Uri.parse(chatApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${keys.key}', // Use stored token
        },
        body: jsonEncode({
          'organization_id': organizationId,
          "user_token": userToken,
          "page":page
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return chatListModelFromJson(response.body);
      } else {
        print("Failed to fetch chat list: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error during API call: $e");
      return null;
    }
  }


  Future<ChatListModel?> fetchChatListMore(
      int organizationId, String userToken,int page) async {
    try {
      const String chatApi = Apis.chats;
      final response = await http.post(
        Uri.parse(chatApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${keys.key}', // Use stored token
        },
        body: jsonEncode({
          'organization_id': organizationId,
          "user_token": userToken,
          "page":page
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return chatListModelFromJson(response.body);
      } else {
        print("Failed to fetch chat list: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error during API call: $e");
      return null;
    }
  }
}
