import 'package:flutter/material.dart';

class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.id,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
    required this.email,
  });

  late String image;
  late String about;
  late String name;
  late String createdAt;
  late String id;
  late bool isOnline;
  late String lastActive;
  late String pushToken;
  late String email;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? const Icon(Icons.person);
    about = json['about'] ?? 'Hello,I am using a chatapp';
    name = json['name'] ?? 'User';
    createdAt = json['created_at'] ?? '';
    id = json['id'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['about'] = about;
    _data['name'] = name;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    _data['is_online'] = isOnline;
    _data['last_active'] = lastActive;
    _data['push_token'] = pushToken;
    _data['email'] = email;
    return _data;
  }
}
