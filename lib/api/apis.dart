import 'dart:developer' as developer;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/chat_user.dart';

class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

//for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //for accessing cloud firebase storage database
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing current user information

  static late ChatUser me;

  static User get user => auth.currentUser!;

//for checking if user exist
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        developer.log('MyData:${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        about: "Aau Gaff Garum !",
        name: user.displayName.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        id: user.uid,
        pushToken: ' ',
        email: user.email.toString());

    return await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set(chatUser.toJson());
  }

//for getting user from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  //update profile picture
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    developer.log('Extension: $ext');
    final ref = storage.ref().child('profile_pictures/${user.uid}.');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      developer.log('Data Transferred: ${p0.bytesTransferred / 100} kb');
    });
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }
}
