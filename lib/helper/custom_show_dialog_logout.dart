// ignore_for_file: use_build_context_synchronously

import 'package:chat/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> setUserOffline() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
      {
        'is_online': false,
        'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }
}

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text('L O G O U T')),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await setUserOffline();

              final googleSignIn = GoogleSignIn();
              final user = FirebaseAuth.instance.currentUser;

              // Check if the user is signed in with Google
              if (user != null && await googleSignIn.isSignedIn()) {
                await googleSignIn.signOut();
              }

              // Sign out from Firebase Auth
              await FirebaseAuth.instance.signOut();

              Navigator.of(context).pop();

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}
