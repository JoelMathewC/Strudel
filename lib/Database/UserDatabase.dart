import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';


class UserDatabase{

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> createUser(String email, String Name) async {
    await users.doc(email).set({
        'Name': Name,
        'Chats':[],
        'NumOfSeenMessages': {},
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
    List<dynamic> chats_uid;
    Map<dynamic,dynamic> numOfMessages;
    dynamic name;
    await users.doc(email).get().then((DocumentSnapshot documentSnapshot){
      chats_uid = documentSnapshot.data()['Chats'];
      numOfMessages = documentSnapshot.data()['NumOfSeenMessages'];
      name = documentSnapshot.data()['Name'];
    });
    return [chats_uid, numOfMessages, [name]];
  }

  Future<void> updateSeenMessagesCount(String email,String uid,int numOfMessages) async {
    List<dynamic> list = await returnChatDetails(email);
    Map<dynamic,dynamic> map = list[1];
    map[uid] = numOfMessages;
    users.doc(email).set({
      'Name': list[2][0],
      'Chats':list[0],
      'NumOfSeenMessages': map,
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

  Future<void> addChatToUser(dynamic id,dynamic chat_id) async{
    List<dynamic> chats = [];
    dynamic name;
    Map<dynamic,dynamic> numOfSeenMessages = {};
    await users.doc(id).get().then((DocumentSnapshot documentSnapshot){
      chats = documentSnapshot.data()['Chats'];
      name = documentSnapshot.data()['Name'];
      numOfSeenMessages = documentSnapshot.data()['NumOfSeenMessages'];
    });
    chats.add(chat_id);
    numOfSeenMessages[chat_id] = 0;
    await users.doc(id).set({
      'Chats': chats,
      'Name' : name,
      'NumOfSeenMessages':numOfSeenMessages,
    });
  }

}