import 'package:flutter/material.dart';

class CustomTextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;

  CustomTextInputWidget({
    required this.controller,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: TextFormField(
        controller: controller,
        obscureText: false,
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
