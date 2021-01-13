import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:strudel/Security/RSA.dart';


class UserDatabase{

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> createUser(String email, String Name,String publicKey) async {
    await users.doc(email).set({
        'Name': Name,
        'Chats':[],
        'NumOfSeenMessages': {},
        'ChattingWith': null,
        'PublicKey': publicKey,
    });
  }

  Future<List<dynamic>> listAllChats(String email) async {
    List<dynamic> chats_uid;
    await users.doc(email).get().then((DocumentSnapshot documentSnapshot){
      chats_uid = documentSnapshot.data()['Chats'];
    });
    return chats_uid;
  }

  Future<Map<dynamic,dynamic>> returnNumOfSeenMessages(String email) async {
    Map<dynamic,dynamic> map = {};
    await users.doc(email).get().then((DocumentSnapshot documentSnapshot){
      map = documentSnapshot.data()['NumOfSeenMessages'];
    });
    return map;
  }

  Future<List<dynamic>> returnChatDetails(String email) async {
    List<dynamic> chats_uid = [];
    Map<dynamic,dynamic> numOfMessages = {};
    dynamic name = null;
    await users.doc(email).get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.data() != null) {
        chats_uid = documentSnapshot.data()['Chats'];
        numOfMessages = documentSnapshot.data()['NumOfSeenMessages'];
        name = documentSnapshot.data()['Name'];
      }
    });

    return [chats_uid, numOfMessages, [name]];
  }

  Future<void> updateSeenMessagesCount(String email,String uid,int numOfMessages) async {
    List<dynamic> list = await returnChatDetails(email);
    Map<dynamic,dynamic> map = list[1];
    map[uid] = numOfMessages;
    users.doc(email).update({
      'NumOfSeenMessages': map,
      'ChattingWith': null, //Since control moves to home page
    });
  }

  Future<dynamic> returnName() async{
    String email = auth.FirebaseAuth.instance.currentUser.email;
    dynamic name;
    await users.doc(email).get().then((DocumentSnapshot documentSnapshot){
      name = documentSnapshot.data()['Name'];
    });
    return name;
  }

  Future<dynamic> getName(String id) async {

    dynamic name;

    DocumentReference doc_ref = users.doc(id);
    if(doc_ref != null) {
      await users.doc(id).get().then((DocumentSnapshot documentSnapshot) {
        name = documentSnapshot.data()['Name'];
      });
    }
    return name;
  }

  Future<String> addChatToUser(dynamic id,dynamic chat_id) async{
    List<dynamic> chats = [];
    Map<dynamic,dynamic> numOfSeenMessages = {};
    String publicKey;
    await users.doc(id).get().then((DocumentSnapshot documentSnapshot){
      chats = documentSnapshot.data()['Chats'];
      numOfSeenMessages = documentSnapshot.data()['NumOfSeenMessages'];
      publicKey = documentSnapshot.data()['PublicKey'];
    });
    chats.add(chat_id);
    numOfSeenMessages[chat_id] = 0;
    await users.doc(id).update({
      'Chats': chats,
      'NumOfSeenMessages':numOfSeenMessages,
    });

    return publicKey;

  }

  Future<void> updateChattingWith(dynamic chat_uid) async {
    await users.doc(auth.FirebaseAuth.instance.currentUser.email).update({
      'ChattingWith': chat_uid,
    });
  }



}