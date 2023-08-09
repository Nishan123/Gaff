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
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : __blueMessage();
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
}
