import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaff/api/apis.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 17, 255),
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    height: 180,
                    width: 180,
                    fit: BoxFit.fill,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person_2_rounded),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.user.email,
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 19),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    height: 70,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 0, 17, 255), width: 5)),
                    child: TextFormField(
                        initialValue: widget.user.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("About", style: TextStyle(fontSize: 17)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    height: 70,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 0, 17, 255), width: 5)),
                    child: TextFormField(
                        initialValue: widget.user.about,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.info,
                              color: Colors.black,
                            ))),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color.fromARGB(255, 89, 180, 255),
                      side: BorderSide.none, // Remove border
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton(
                    onPressed: () async {
                      await APIs.auth.signOut();
                      await GoogleSignIn().signOut();
                    },
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(255, 140, 179, 0),
                      side: BorderSide.none, // Remove border
                    ),
                    child: const Text(
                      "LogOut",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
