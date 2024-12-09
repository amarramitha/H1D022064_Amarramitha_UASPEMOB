import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uaspemob/views/login_view.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController =
      TextEditingController(); // Added username controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  // Register user with email, password, name, and username
  Future<void> registerWithEmailPassword() async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get the user object
      User? user = userCredential.user;

      if (user != null) {
        // Update the user's display name
        await user.updateDisplayName(_nameController.text);

        // Save the user's data to Firestore, including the username
        await _firestore.collection('users').doc(user.uid).set({
          'name': _nameController.text,
          'username': _usernameController.text, // Save username
          'email': _emailController.text,
          'bio':
              '', // You can set the initial bio as an empty string or provide default
        });

        // Show a success alert after registration
        Get.snackbar(
          'Berhasil',
          'Akun kamu berhasil dibuat!',
          snackPosition: SnackPosition.TOP,
        );

        // Navigate to the login screen using GetX
        Get.off(() => Login()); // Replace Navigator.pop() with Get.off()
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32),
                  const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jakarta',
                    ),
                  ),

                  SizedBox(height: 16),

                  // Email TextField
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontFamily: 'Jakarta'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),

                  // Password TextField
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontFamily: 'Jakarta'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),

                  // Register Button
                  ElevatedButton(
                    onPressed: registerWithEmailPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 137, 202, 255),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        fontFamily: 'Jakarta',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Error Message Display
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 16),

                  // Login Option
                  Text(
                    "Sudah punya akun?",
                    style: TextStyle(fontFamily: 'Jakarta'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to the login screen using GetX
                      Get.to(() => Login());
                    },
                    child: Text(
                      "Masuk",
                      style: TextStyle(
                        fontFamily: 'Jakarta',
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
