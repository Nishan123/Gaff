import 'dart:io';
import 'dart:developer' as developer;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:gaff/helper/my_date_util.dart';
import 'package:gaff/models/message.dart';
import 'package:gaff/screens/view_profile_screen.dart';
import 'package:gaff/widgets/message_card.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing messages
  List<Message> _list = [];

  final _textController = TextEditingController();
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //waiting to load data
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();

                          //taking time to load data
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;

                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                reverse: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: _list.length,
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index]);
                                },
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "Say Hi! 👋",
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }
                        }
                      }),
                ),
                // if (_isUploading)
                //   const Align(
                //     alignment: Alignment.centerRight,
                //     child: Padding(
                //       padding:
                //           EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                //       child: CircularProgressIndicator(
                //         strokeWidth: 1,
                //       ),
                //     ),
                //   ),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: 270,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
              children: [
                const SizedBox(width: 60),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    height: 45,
                    width: 45,
                    imageUrl:
                        list.isNotEmpty ? list[0].image : widget.user.image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person_2_rounded),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _list.isNotEmpty ? list[0].name : widget.user.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontFamily: 'Roboto',
                          color: Colors.white),
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          color: Colors.white),
                    ),
                  ],
                )
              ],
            );
          },
        ));
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.white30,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: Icon(
                        IconsaxOutline.emoji_normal,
                        color: Colors.blueAccent,
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    maxLines: null,
                    onTap: () {
                      setState(() {
                        if (_showEmoji) _showEmoji = !_showEmoji;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        hintText: "Type your Message....",
                        hintStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none),
                  )),

                  //for multi image picking feature
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);
                      for (var i in images) {
                        setState(() {
                        });
                        developer.log('Image Path: ${i.path}');
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() {
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                  ),

                  //for camera image sending feature
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        developer.log('Image Path: ${image.path}');

                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() {
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            elevation: 0,
            padding: EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 8),
            minWidth: 0,
            color: Colors.green,
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);

                _textController.text = "";
              }
            },
            shape: CircleBorder(),
            child: Icon(
              IconsaxOutline.send_1,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
