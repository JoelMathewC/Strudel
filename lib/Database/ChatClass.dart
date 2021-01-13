import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:strudel/Security/RSA.dart';

class ChatClass{
  String name;
  String uid;
  crypto.PrivateKey privateKey;
  ChatClass({this.name,this.uid,this.privateKey});
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
  DisplayChatClass({this.chatID,this.chatName,this.time,this.lastMessage,this.numOfMessages,this.lastMessageOwner});
}