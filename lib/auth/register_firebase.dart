// ignore_for_file: use_build_context_synchronously

import 'package:chat/model/chat_user.dart';
import 'package:chat/helper/custom_show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

TextEditingController userNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passController = TextEditingController();

Future<void> signUp(BuildContext context) async {
  try {
    if (passController.text.length < 6) {
      // Show error animation for short password
      showLottieAnimation(context, 'assets/Animation - 1724183861790.json');
      return;
    }

    // Attempt to create a new user
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passController.text,
    );

    // Get user ID
    String uid = userCredential.user!.uid;
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // Create ChatUser object
    ChatUser newUser = ChatUser(
      image: 'default_image_url', // Default image URL
      about: 'Hello, I am using a chat app',
      name: userNameController.text, // User provided name
      createdAt: time,
      id: uid,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      email: emailController.text,
    );

    // Save user to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(newUser.toJson());

    // Show success animation and navigate to the chat screen
    showLottieAnimation(context, 'assets/Animation - 1724182155002.json',
        navigate: true);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      // Show error animation for existing email
      showLottieAnimation(context, 'assets/Animation - 1724183861790.json');
    } else if (e.code == 'weak-password') {
      // Show error animation for weak password
      showLottieAnimation(context, 'assets/Animation - 1724183861790.json');
    } else {
      // Show generic error animation
      showLottieAnimation(context, 'assets/Animation - 1724183861790.json');
    }
  } catch (e) {
    // Show generic error animation or message
    showLottieAnimation(context, 'assets/error_animation.json');
  }
}
