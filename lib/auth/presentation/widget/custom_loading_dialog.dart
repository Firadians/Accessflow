import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingDialog extends StatelessWidget {
  const CustomLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          Lottie.asset(
            'assets/lottie/loading.json',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            frameRate: FrameRate(60),
            repeat: false,
            animate: true,
          ),
          SizedBox(width: 20),
          Text("Signing in..."),
        ],
      ),
    );
  }
}
