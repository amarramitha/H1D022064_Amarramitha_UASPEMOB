import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'routes/routes.dart';
import 'controller/login_controller.dart'; // Import the LoginController

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register LoginController before runApp
  Get.put(LoginController());

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  // Set initial route based on user authentication status
  String initialRoute = user != null ? '/dashboard' : '/login';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'POS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Jakartamedium',
            fontSize: 20,
          ),
        ),
      ),
      initialRoute: initialRoute,
      getPages: AppRoutes.pages, // Assuming you have routes set up here
    );
  }
}
