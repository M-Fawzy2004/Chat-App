import 'package:chat/screen/login_screen.dart';
import 'package:chat/theme/theme_provider.dart';
import 'package:chat/widget/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          LottieBuilder.asset(
            'assets/Animation.json',
            reverse: true,
            repeat: false,
          ),
          LottieBuilder.asset(
            'assets/Animationwelcomechat.json',
            reverse: true,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xff063261),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                CupertinoSwitch(
                  activeColor: Colors.blueAccent,
                  trackColor: Colors.white,
                  thumbColor: Colors.purple,
                  value: Provider.of<ThemeAppProvider>(
                    context,
                    listen: false,
                  ).isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeAppProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
              ],
            ),
          ),
          CustomButton(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            text: 'Get Started',
          ),
        ],
      ),
    );
  }
}
