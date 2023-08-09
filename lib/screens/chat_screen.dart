import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: _appBar(),
          ),
          body: Column(
            children: [_chatInput()],
          )),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CachedNetworkImage(
              height: 45,
              width: 45,
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.person_2_rounded),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    fontFamily: 'Roboto'),
              ),
              Text(
                'Last seen at 12:00',
                style: TextStyle(fontSize: 13, fontFamily: 'Roboto'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.white30,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.blueAccent,
                      )),
                  Expanded(
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: "Type your Message....",
                        hintStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.blueAccent,
                      )),
                ],
              ),
            ),
          ),
          MaterialButton(
            elevation: 0,
            padding: EdgeInsets.only(top: 8,bottom: 8,right: 8,left: 8),
            minWidth: 0,
            color: Colors.green,
            onPressed: () {},
            shape: CircleBorder(),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
