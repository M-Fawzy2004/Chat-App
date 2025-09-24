import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/auth/api.dart';
import 'package:chat/helper/my_data_util.dart';
import 'package:chat/model/message_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class CustomChatBubble extends StatefulWidget {
  const CustomChatBubble({super.key, required this.message});

  final Message message;

  @override
  State<CustomChatBubble> createState() => _CustomChatBubbleState();
}

class _CustomChatBubbleState extends State<CustomChatBubble> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs().user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(context);
      },
      child: isMe ? _sendMessage() : _receiveMessages(),
    );
  }

  Widget _sendMessage() {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ChatBubble(
          margin: const EdgeInsets.only(left: 15, top: 5, right: 10, bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          backGroundColor: const Color(0xff2d1c8c),
          alignment: Alignment.centerRight,
          clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
          child: widget.message.type == Type.text
              ? Text(
                  widget.message.msg,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[100],
                    fontWeight: FontWeight.bold,
                  ),
                )
              : CachedNetworkImage(
                  height: size.height * 0.25,
                  width: size.width * 0.6,
                  fit: BoxFit.cover,
                  imageUrl: widget.message.msg,
                  placeholder: (context, url) => const Center(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  MyDataUtil.getFormatedTime(
                    context: context,
                    time: widget.message.sent,
                  ),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.01),
              Icon(
                Icons.done_all_rounded,
                color: widget.message.read.isEmpty
                    ? Colors.grey.shade400
                    : Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _receiveMessages() {
    if (widget.message.read.isEmpty) {
      APIs().updateReadMessage(widget.message);
      log('message update');
    }
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ChatBubble(
          margin: const EdgeInsets.only(left: 10, top: 5, right: 15, bottom: 5),
          alignment: Alignment.centerLeft,
          backGroundColor: const Color(0xff363636),
          clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
          child: widget.message.type == Type.text
              ? Text(
                  widget.message.msg,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[100],
                    fontWeight: FontWeight.bold,
                  ),
                )
              : CachedNetworkImage(
                  height: size.height * 0.25,
                  width: size.width * 0.6,
                  fit: BoxFit.cover,
                  imageUrl: widget.message.msg,
                  placeholder: (context, url) => const Center(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              MyDataUtil.getFormatedTime(
                context: context,
                time: widget.message.sent,
              ),
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

// showBottomSheet
  void _showBottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMe = APIs().user.uid == widget.message.fromId;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            Divider(
              indent: 120,
              color: Theme.of(context).colorScheme.tertiary,
              thickness: 5,
              endIndent: 120,
            ),
            widget.message.type == Type.text
                ? OptionItem(
                    onTap: () {},
                    icon: Icons.copy,
                    colorIcon: Colors.white,
                    text: 'Copy Text',
                  )
                : OptionItem(
                    onTap: () {},
                    icon: Icons.download,
                    colorIcon: Colors.white,
                    text: 'Save Image',
                  ),
            Divider(
              indent: 70,
              color: Theme.of(context).colorScheme.primary,
              endIndent: 70,
            ),
            if (widget.message.type == Type.text && isMe)
              OptionItem(
                onTap: () {},
                icon: Icons.edit_outlined,
                colorIcon: Colors.white,
                text: 'Edit Message',
              ),
            OptionItem(
              onTap: () {},
              icon: Icons.delete,
              colorIcon: Colors.red,
              text: 'Delete Message',
            ),
            Divider(
              indent: 70,
              color: Theme.of(context).colorScheme.primary,
              endIndent: 70,
            ),
            OptionItem(
              onTap: () {},
              icon: Icons.remove_red_eye,
              colorIcon: Colors.grey,
              text: 'Sent At : ',
            ),
            OptionItem(
              onTap: () {},
              icon: Icons.remove_red_eye,
              colorIcon: Colors.blue,
              text: 'Read At : ',
            ),
          ],
        );
      },
    );
  }
}

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    required this.colorIcon,
  });

  final IconData icon;
  final Color colorIcon;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 13, bottom: 13),
        child: Row(
          children: [
            Icon(icon, size: 25, color: colorIcon),
            SizedBox(
              width: size.width * .03,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
