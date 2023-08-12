// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as developer;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaff/api/apis.dart';
import 'package:gaff/helper/dialogs.dart';
import 'package:gaff/screens/auth/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        
        backgroundColor: Color.fromARGB(118, 122, 112, 100),
        appBar: AppBar(
          title: const Text("Profile",),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      //for profile picture
                      _image != null
                          ? Container(
                              decoration: BoxDecoration(
                                
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  File(_image!),
                                  height: 180,
                                  width: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(130),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(130),
                                child: CachedNetworkImage(
                                  height: 180,
                                  width: 180,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.person_2_rounded),
                                ),
                              ),
                            ),

                      Positioned(
                        bottom: 5,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 151, 149, 255),
                              borderRadius: BorderRadius.circular(40)),
                          child: IconButton(
                            onPressed: () {
                              _showBottomSheet();
                            },
                            icon: const Icon(
                              IconsaxBold.edit,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 19,color: Colors.white),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Name",
                          style: TextStyle(fontSize: 17,color: Color.fromARGB(255, 142, 142, 142)),

                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        height: 70,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 4)),
                        child: Center(
                          child: TextFormField(
                            initialValue: widget.user.name,
                            onSaved: (val) => APIs.me.name = val ?? '',
                            validator: (val) => val != null && val.isNotEmpty
                                ? null
                                : "Required Field",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                prefixIcon: Icon(
                                  IconsaxBold.profile_circle,
                                  color: Colors.white,
                                  size: 30,
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("About", style: TextStyle(fontSize: 17,color: Color.fromARGB(255, 142, 142, 142))),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 70,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 4)),
                        child: Center(
                          child: TextFormField(
                            onSaved: (val) => APIs.me.about = val ?? '',
                            validator: (val) => val != null && val.isNotEmpty
                                ? null
                                : "Cannot be empty",
                            initialValue: widget.user.about,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                prefixIcon: Icon(
                                  IconsaxBold.heart_circle,
                                  color: Colors.white,
                                  size: 30,
                                )),
                          ),
                        ),
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnackbar(
                                  context, "Profile Updated !");
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 29, 29, 29),
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
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: OutlinedButton(
                          onPressed: () async {
                            Dialogs.showProgressBar(context);
                            await APIs.updateActiveStatus(false);
                            await APIs.auth.signOut().then((value) async {
                              await GoogleSignIn().signOut().then((value) {
                                //for hiding progress bar
                                Navigator.pop(context);
                                APIs.auth = FirebaseAuth.instance;

                                //for removing backstack of home screen
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen()));
                              });
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                Color.fromARGB(255, 91, 91, 91),
                            side: BorderSide.none, // Remove border
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconsaxOutline.logout,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "LogOut",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20, bottom: 100),
            children: [
              const Text(
                "Choose your profile Picture",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //camera ko lagi
                    ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          //pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            developer.log('Image Path: ${image.path}');

                            setState(() {
                              _image = image.path;
                            });
                            APIs.updateProfilePicture(File(_image!));

                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset(
                          'assets/images/camera.jpg',
                          height: 90,
                          width: 100,
                        )),

                    //gallary ko lagi
                    ElevatedButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          //pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (image != null) {
                            developer.log(
                                'Image Path: ${image.path} -- MineType: ${image.mimeType}');

                            setState(() {
                              _image = image.path;
                            });
                            APIs.updateProfilePicture(File(_image!));

                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset(
                          'assets/images/gallary.jpg',
                          height: 90,
                          width: 100,
                        )),
                  ],
                ),
              )
            ],
          );
        });
  }

}
