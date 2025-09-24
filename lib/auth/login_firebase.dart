// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:chat/auth/register_firebase.dart';
import 'package:chat/helper/custom_show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void signIn(BuildContext context) async {
  try {
    // ignore: unused_local_variable
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passController.text,
    );

    showLottieAnimation(
      context,
      'assets/Animation - 1724182155002.json',
      navigate: true,
    );
  } on FirebaseAuthException catch (e) {
    print('FirebaseAuthException code: ${e.code}');
    print('FirebaseAuthException message: ${e.message}');
    showLottieAnimation(
      context,
      'assets/Animation - 1724183861790.json',
    );
  } catch (e) {
    print('Error: $e');
    showLottieAnimation(
      context,
      'assets/Animation - 1724183861790.json',
    );
  }
}
