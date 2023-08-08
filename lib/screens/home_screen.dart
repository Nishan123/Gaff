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
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    APIs.getSelfInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Username or Email",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                autofocus: true,
                style: TextStyle(color: Colors.white),
                onChanged: (val) {
                  //search Logic
                  _searchList.clear();

                  for (var i in _list) {
                    if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                        i.email.toLowerCase().contains(val.toLowerCase())) {
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                },
              )
            : Text(
                "Gaff",
                style: TextStyle(fontFamily: 'SKATERDUDES'),
              ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(_isSearching ? Icons.clear_rounded : Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIs.me)));
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
          stream: APIs.getAllUsers(),
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

                _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];

                if (_list.isNotEmpty) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _isSearching? _searchList.length : _list.length,
                    itemBuilder: (context, index) {
                      return ChatUserCard(user:_isSearching?_searchList[index]: _list[index]);
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
