// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/auth/api.dart';
import 'package:chat/model/chat_user.dart';
import 'package:chat/helper/custom_show_dialog.dart';
import 'package:chat/widget/custom_button.dart';
import 'package:chat/widget/custom_edit_image.dart';
import 'package:chat/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> globalKey = GlobalKey();
  String? _image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Provide a default image URL if user.image is empty or null
    final imageUrl = widget.user.image.isNotEmpty ? widget.user.image : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Stack(
                  children: [
                    _image != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(size.height * 0.1),
                            child: Image.file(
                              File(_image!),
                              width: size.width * 0.40,
                              height: size.height * 0.2,
                              fit: BoxFit.fill,
                            ),
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(size.height * 0.1),
                            child: CachedNetworkImage(
                              width: size.width * 0.40,
                              height: size.height * 0.2,
                              fit: BoxFit.fill,
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
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: MaterialButton(
                        shape: const CircleBorder(),
                        color: Theme.of(context).colorScheme.inversePrimary,
                        elevation: 5,
                        onPressed: () {
                          _showBottomSheet(context);
                        },
                        child: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Text(
                  widget.user.email,
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                CustomTextFormField(
                  onSaved: (val) => APIs.me.name = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Requierd Field',
                  labelText: 'userName',
                  initialValue: widget.user.name,
                  prefixIcon: Icons.person,
                  isPassword: false,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                CustomTextFormField(
                  onSaved: (val) => APIs.me.about = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Requierd Field',
                  labelText: 'About',
                  prefixIcon: Icons.info,
                  initialValue: widget.user.about,
                  isPassword: false,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                CustomButton(
                  onTap: () {
                    if (globalKey.currentState!.validate()) {
                      globalKey.currentState!.save();
                      APIs().updateUserInfo();
                    }
                    showLottieAnimation(
                      context,
                      'assets/Animation - 1724182155002.json',
                    );
                  },
                  text: 'Update',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // showBottomSheet
  void _showBottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: size.height * 0.15,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Center(
                child: Text(
                  'Pick Profile Picture',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomEditImage(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        setState(() {
                          _image = image.path;
                        });
                        await APIs().updateProfilePicture(File(_image!));
                      }
                    },
                    image: 'assets/picture.png',
                  ),
                  CustomEditImage(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (image != null) {
                        setState(() {
                          _image = image.path;
                        });
                        await APIs().updateProfilePicture(File(_image!));
                      }
                    },
                    image: 'assets/camera.png',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
