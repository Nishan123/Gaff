import 'dart:developer' as developer;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaff/api/apis.dart';
import 'package:gaff/helper/my_date_util.dart';

import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : __blueMessage(),
    );
  }

//Sender message
  Widget __blueMessage() {
    //update last read message
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      developer.log('Message read updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        ),
                        imageUrl: widget.message.msg,
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image,
                          size: 50,
                        ),
                      ),
                    )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(
            MyDateUtil.getFromattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

//User message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              if (widget.message.read.isNotEmpty) const Icon(Icons.done),
              const SizedBox(width: 3),
              Text(
                MyDateUtil.getFromattedTime(
                    context: context, time: widget.message.sent),
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green.shade400,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25))),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 50,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  //bottomsheet for message actions
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20, bottom: 60),
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 100),
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: Icon(
                        Icons.copy,
                        color: Colors.blue,
                      ),
                      name: "Copy",
                      onTap: () {})
                  : _OptionItem(
                      icon: Icon(
                        Icons.download,
                        color: Colors.blue,
                      ),
                      name: "Save image",
                      onTap: () {}),
            

              if(widget.message.type==Type.text && isMe)
              _OptionItem(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.red,
                  ),
                  name: "Edit",
                  onTap: () {}),

                  if(isMe)
              _OptionItem(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  name: "Delete",
                  onTap: () {}),
              const Divider(
                indent: 20,
                endIndent: 20,
                height: 10,
                color: Colors.black54,
              ),
              _OptionItem(
                  icon: Icon(
                    Icons.done_all,
                    color: Colors.blue,
                  ),
                  name: "Send At:",
                  onTap: () {}),
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.red,
                  ),
                  name: "Read At:",
                  onTap: () {}),
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 9, top: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: TextStyle(fontSize: 18),
            ))
          ],
        ),
      ),
    );
  }
}
