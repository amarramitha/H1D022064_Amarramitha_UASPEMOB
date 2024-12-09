import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool enabled;
  final InputDecoration? decoration; // Make decoration optional

  const CustomInputField({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.enabled = true,
    this.decoration, // Allow external customization of decoration
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled, // Use the enabled parameter here
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            filled: true,
            fillColor: enabled
                ? Colors.white
                : Colors.grey[200], // Change color when disabled
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            labelStyle: TextStyle(
              fontFamily: 'Jakarta', // Assuming the Jakarta font is used
              fontWeight: FontWeight.bold,
              color: enabled
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : Colors.grey, // Label color changes when disabled
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 16), // Padding inside the input
          ),
    );
  }
}
