

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatClass{
  String name;
  String uid;
  ChatClass({this.name,this.uid});
}

class MessageClass{
  String message;
  Timestamp time;
  String messageOwner;
  String date;
  MessageClass({this.message,this.time,this.messageOwner,this.date});
}

class DisplayChatClass{
  String lastMessage;
  String lastMessageOwner;
  String chatName;
  String chatID;
  int numOfMessages;
  Timestamp time;
  DisplayChatClass({this.chatID,this.chatName,this.time,this.lastMessage,this.numOfMessages});
}