// import 'dart:math';
// import 'dart:developer' as developer;
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gaff/api/apis.dart';
import 'package:gaff/screens/profile_screen.dart';
import 'package:gaff/widgets/chat_user_card.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text("Gaff",style: TextStyle(fontFamily: 'SKATERDUDES'),),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>ProfileScreen(user:list[0])));
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 0,
          onPressed: () async {
            // await APIs.auth.signOut();
            // await GoogleSignIn().signOut();
          },
          child: Icon(
            Icons.add_comment,
            color: Colors.white,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),
      body: StreamBuilder(
          stream: APIs.firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              //waiting to load data
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

              //taking time to load data
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;

                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];

                if (list.isNotEmpty) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: list[index]);
                    },
                  );
                } else {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Go Talk to Someone",
                          style: TextStyle(
                              fontSize: 35,
                              color: Color.fromARGB(255, 11, 48, 255),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Press add button to connect with your friends",
                          style: TextStyle(
                              color: Color.fromARGB(255, 11, 48, 255),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}
