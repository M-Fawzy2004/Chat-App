// ignore_for_file: use_build_context_synchronously

import 'package:chat/screen/setting_screen.dart';
import 'package:chat/widget/custom_drawer_tile.dart';
import 'package:chat/helper/custom_show_dialog_logout.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, this.onTapProfile});

  final void Function()? onTapProfile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // icon header
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Image.asset(
              'assets/whatsapp.png',
              height: 90,
              width: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // icon home
          CustomDrawerTile(
            onTap: () {
              Navigator.pop(context);
            },
            text: 'Home',
            icon: Icons.home,
          ),

          // icon profile
          CustomDrawerTile(
            onTap: onTapProfile,
            text: 'Profile',
            icon: Icons.person,
          ),

          // icon setting
          CustomDrawerTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
                ),
              );
            },
            text: 'Setting',
            icon: Icons.settings,
          ),

          // spacer
          const Spacer(),

          // icon logout
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CustomDrawerTile(
              onTap: () {
                showLogoutConfirmationDialog(context);
              },
              text: 'Logout',
              icon: Icons.logout,
            ),
          ),
        ],
      ),
    );
  }
}
