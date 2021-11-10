import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  late String? senderName, senderId, selectedUserId, text;
  late String? photourl;
  late File? photo;
  Timestamp timestamp;
  Message(
      {this.senderName,
        this.senderId,
        this.selectedUserId,
        this.text,
        this.photourl,
        this.photo,
        required this.timestamp});
}