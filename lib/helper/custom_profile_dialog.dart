import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/model/chat_user.dart';
import 'package:chat/screen/view/view_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final imageUrl = widget.user.image.isNotEmpty ? widget.user.image : null;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.user.name,
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewProfileScreen(user: widget.user),
                ),
              );
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      content: CachedNetworkImage(
        height: size.height * .3,
        width: size.width * .1,
        fit: BoxFit.cover,
        imageUrl: imageUrl!,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.person,
          size: 150,
        ),
      ),
    );
  }
}
