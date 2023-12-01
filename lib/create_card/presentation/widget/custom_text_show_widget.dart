import 'package:flutter/material.dart';

class CustomTextShowWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController?
      controller; // Add a TextEditingController parameter

  CustomTextShowWidget({
    required this.labelText,
    required this.hintText,
    this.controller, // Make it optional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: TextFormField(
        controller: controller, // Assign the controller here
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(186, 174, 174, 174),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(225, 67, 67, 67),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
