import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaff/models/chat_user.dart';
import 'package:gaff/screens/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: 80,
        height: 300,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  user.name,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: user.image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(Icons.person_outline),
                    ),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ViewProfileScreen(user: user)));
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    )))
          ],
        ),
      ),
    );
  }
}
