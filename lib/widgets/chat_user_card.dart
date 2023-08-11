import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaff/api/apis.dart';
import 'package:gaff/helper/my_date_util.dart';
import 'package:gaff/models/message.dart';
import 'package:gaff/screens/chat_screen.dart';
import 'package:gaff/widgets/dialogs/profile_dialogs.dart';

import '../models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 2),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              tileColor: Color.fromARGB(135, 209, 220, 226),
              leading: InkWell(
                onTap: () {
                  showDialog(context: context, builder: (_)=>ProfileDialog(user:widget.user,));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    height: 55,
                    width: 55,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person_2_rounded),
                  ),
                ),
              ),
              title: Text(
                widget.user.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              subtitle: Text(
                _message != null
                    ? _message!.type == Type.image
                        ? "Image...."
                        : _message!.msg
                    : widget.user.about,
                maxLines: 1,
              ),
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                      ? Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      : Text(
                          MyDateUtil.getLastMessageTime(
                              context: context, time: _message!.sent),
                          style: TextStyle(color: Colors.black45),
                        ),
            );
          },
        ),
      ),
    );
  }
}
