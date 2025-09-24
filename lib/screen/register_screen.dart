import 'package:chat/auth/register_firebase.dart';
import 'package:chat/screen/login_screen.dart';
import 'package:chat/widget/custom_button.dart';
import 'package:chat/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                'W E L C O M E  \nB A C K!',
                style: TextStyle(
                  fontSize: 27,
                ),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              // username textField
              CustomTextFormField(
                controller: userNameController,
                hintText: 'UserName',
                isPassword: false,
                prefixIcon: Icons.person,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              // email textField
              CustomTextFormField(
                controller: emailController,
                hintText: 'Email',
                isPassword: false,
                prefixIcon: Icons.email,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              // password textField
              CustomTextFormField(
                controller: passController,
                hintText: 'Password',
                isPassword: true,
                prefixIcon: Icons.password_outlined,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              // button sign up
              CustomButton(
                onTap: () => signUp(context),
                text: 'Sign Up',
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              // text not have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already Have Account? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      ' Sign In',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff027afd),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
