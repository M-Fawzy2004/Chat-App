// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/model/chat_user.dart';
import 'package:chat/widget/custom_view_profile.dart';
import 'package:flutter/material.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ViewProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ViewProfileScreen> {
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Provide a default image URL if user.image is empty or null
    final imageUrl = widget.user.image.isNotEmpty ? widget.user.image : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.name,
          style: TextStyle(
            fontSize: 17,
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(size.height * .1),
                    child: CachedNetworkImage(
                      height: size.height * .2,
                      width: size.width * .43,
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
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  CustomViewProfile(
                    size: size,
                    title: 'Email : ',
                    subTitle: widget.user.email,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CustomViewProfile(
                    size: size,
                    title: 'About : ',
                    subTitle: widget.user.about,
                  ),
                  // CustomViewProfile(
                  //   size: size,
                  //   title: 'About : ',
                  //   subTitle: MyDataUtil.getLastMessageTime(
                  //     context: context,
                  //     time: widget.user.createdAt,
                  //     showYear: true,
                  //   ),
                  // ),
                  SizedBox(
                    height: size.height * 0.33,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
