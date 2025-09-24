import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/auth/api.dart';
import 'package:chat/helper/custom_profile_dialog.dart';
import 'package:chat/helper/my_data_util.dart';
import 'package:chat/model/chat_user.dart';
import 'package:chat/model/message_user.dart';
import 'package:chat/screen/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatScreenCard extends StatefulWidget {
  const ChatScreenCard({super.key, required this.user});

  final ChatUser user;

  @override
  State<ChatScreenCard> createState() => _ChatScreenCardState();
}

class _ChatScreenCardState extends State<ChatScreenCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              user: widget.user,
            ),
          ),
        );
      },
      child: StreamBuilder(
        stream: APIs().getLastMessage(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;

          final list =
              data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

          if (list.isNotEmpty) {
            _message = list[0];
          }

          return Slidable(
            endActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const DrawerMotion(),
              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (val) {},
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              leading: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ProfileDialog(user: widget.user),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    width: size.width * 0.11,
                    height: size.height * 0.055,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
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
              ),
              title: Text(
                widget.user.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              subtitle: Text(
                _message != null
                    ? _message!.type == Type.image
                        ? 'Image'
                        : _message!.msg
                    : widget.user.about,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty &&
                          _message!.fromId != APIs().user.uid
                      ? Container(
                          height: size.height * 0.01,
                          width: size.width * 0.02,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green[400],
                          ),
                        )
                      : Text(
                          MyDataUtil.getLastMessageTime(
                            context: context,
                            time: _message!.sent,
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }
}
