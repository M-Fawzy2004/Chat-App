// ignore_for_file: use_build_context_synchronously

import 'package:chat/auth/login_firebase.dart';
import 'package:chat/auth/register_firebase.dart';
import 'package:chat/screen/register_screen.dart';
import 'package:chat/widget/custom_button.dart';
import 'package:chat/widget/custom_text_form_field.dart';
import 'package:chat/auth/sign_in_with_google.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              // logo
              Center(
                child: Image.asset(
                  'assets/whatsapp.png',
                  height: 100,
                  width: 150,
                ),
              ),

              SizedBox(
                height: size.height * 0.04,
              ),

              // message app
              const Text(
                'W E L C O M E !',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),

              SizedBox(
                height: size.height * 0.06,
              ),

              // email textField
              CustomTextFormField(
                controller: emailController,
                hintText: 'Email',
                isPassword: false,
                prefixIcon: Icons.email,
              ),

              SizedBox(
                height: size.height * 0.02,
              ),

              // password textField
              CustomTextFormField(
                controller: passController,
                hintText: 'Password',
                isPassword: true,
                prefixIcon: Icons.password_outlined,
              ),

              SizedBox(
                height: size.height * 0.02,
              ),

              SizedBox(
                height: size.height * 0.02,
              ),

              // button login
              CustomButton(
                onTap: () => signIn(context),
                text: 'Sign In',
              ),

              SizedBox(
                height: size.height * 0.02,
              ),

              // text not have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already Not Have Account? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      ' Sign Up',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff027afd),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: size.height * 0.03,
              ),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      indent: 10,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    ' OR SIGN IN WITH ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      endIndent: 10,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: size.height * 0.03,
              ),

              const SignInWithGoogle(),
            ],
          ),
        ),
      ),
    );
  }
}
