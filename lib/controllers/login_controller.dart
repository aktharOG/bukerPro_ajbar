import 'package:buktorgrow/services/api_services.dart';
import 'package:get/get.dart';

import '../screens/chat_list.dart';
import '../utilities/SharedPreferences.dart';
// Your AuthService location

class LoginController extends GetxController {
  var isLoading = false.obs;

  final ApiServices _authService = ApiServices();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      bool? result = await _authService.login(email, password);
      isLoading.value = false;

      if (result == true) {
        // Use Get.off() to navigate to ChatList and remove the login page from the stack
        Get.off(() => const ChatList());
        // Alternatively, use Get.offAll() to clear the entire stack
        // Get.offAll(() => const ChatList());
      } else {
        Get.snackbar('Error', 'Invalid login credentials');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to login: ${e.toString()}');
    }
  }

  var userToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadToken(); // Load the token when the controller is initialized
  }

  Future<String?> loadToken() async {
    String? savedToken = await SharedPrefs.getToken();
    if (savedToken != null) {
      userToken.value = savedToken;
      return userToken.value; // Update the observable token
    }
    return null;
  }
}
