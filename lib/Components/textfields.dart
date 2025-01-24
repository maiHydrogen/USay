import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
            Color.fromARGB(255, 31, 148, 160),
            Color.fromARGB(255, 28, 108, 198),
            Color.fromARGB(255, 175, 68, 239),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.grey[700],
                fontFamily: 'instrument_serif',
                wordSpacing: 5,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
