import 'package:chat/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLottieAnimation(BuildContext context, String animationPath,
    {bool navigate = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          height: 100,
          width: 100,
          child: Lottie.asset(animationPath, height: 50, width: 50),
        ),
      );
    },
  );

  Future.delayed(const Duration(milliseconds: 1500), () async {
    Navigator.of(context).pop(); // Close the dialog

    if (navigate) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  });
}
