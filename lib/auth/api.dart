import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:chat/model/chat_user.dart';
import 'package:chat/model/message_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  // firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  // firebase store
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //firebase firestorge
  FirebaseStorage firestorge = FirebaseStorage.instance;

  // get current user
  User get user => auth.currentUser!;

  static late ChatUser me;

  // firebase push messaging
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // getting firebase messaging
  Future<void> getFirebaseMessaging() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then(
      (t) {
        if (t != null) {
          me.pushToken = t;
          log('Push Messaging $t');
        }
      },
    );
  }

  // users
  Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // get selfInfo
  Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessaging();
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((_) => getSelfInfo());
      }
    });
  }

  // create user
  Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chat = ChatUser(
      image: user.photoURL.toString(),
      about: 'Hi I am using chat app',
      name: user.displayName.toString(),
      createdAt: time,
      id: user.uid,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      email: user.email.toString(),
    );

    return await firestore.collection('users').doc(user.uid).set(chat.toJson());
  }

  // get all user
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // update user info
  Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update(
      {
        "name": me.name,
        "about": me.about,
      },
    );
  }

  // update user profile picture
  Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = firestorge.ref().child('profile_picture/${user.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
      (pO) {
        log('Data Transferred: ${pO.bytesTransferred / 1000} kb');
      },
    );
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update(
      {
        "image": me.image,
      },
    );
  }

  // get specific user info
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // active state of user
  Future<void> updateActiveStatus(bool isOnline) async {
    await firestore.collection('users').doc(user.uid).update(
      {
        'is_online': isOnline,
        'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
        'push_token': me.pushToken,
      },
    );
  }

  // ########################### => CHAT SCREEN <= #################################

  String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // get all message
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(ChatUser user) {
    return firestore
        .collection('chat/${getConversationID(user.id)}/message/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // send message
  Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
      msg: msg,
      read: '',
      told: chatUser.id,
      type: type,
      fromId: user.uid,
      sent: time,
    );
    final ref =
        firestore.collection('chat/${getConversationID(chatUser.id)}/message/');
    await ref.doc(time).set(message.toJson());
  }

  // for read message
  Future<void> updateReadMessage(Message message) async {
    // final time = DateTime.now().millisecondsSinceEpoch.toString();

    firestore
        .collection('chat/${getConversationID(message.fromId)}/message/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get last message
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user) {
    return firestore
        .collection('chat/${getConversationID(user.id)}/message/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // send chat image & camera
  Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;
    final ref = firestorge.ref().child(
          'image/${getConversationID(chatUser.id)}${DateTime.now().millisecondsSinceEpoch}.$ext',
        );
    await ref.putFile(file, SettableMetadata(contentType: 'images/$ext')).then(
      (pO) {
        log('Data Transferred: ${pO.bytesTransferred / 1000} kb');
      },
    );
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
