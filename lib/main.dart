import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/chatcontroller.dart';
import 'controllers/login_controller.dart';
import 'screens/chat_list.dart';
import 'screens/login.dart';
import 'utilities/SharedPreferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController authController = Get.put(LoginController());
    if (!kIsWeb) {
      Get.put(ChatController()); // Only put ChatController if not on web
    }
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
        fontFamily: 'Roboto Condensed',
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          titleLarge: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ),
      home: FutureBuilder<bool>(
        future: _checkToken(), // Check for token on app startup
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking for the token
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            // If the token exists, navigate to ChatList
            return const ChatList();
          } else {
            // If no token found, show the LoginPage
            return LoginPage();
          }
        },
      ),
    );
  }

  // Method to check if a token exists in SharedPreferences
  Future<bool> _checkToken() async {
    String? token = await SharedPrefs.getToken(); // Use the SharedPrefsHelper
    return token != null; // Return true if token exists, false otherwise
  }
}
