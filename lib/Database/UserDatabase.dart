import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';


class UserDatabase{

  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> createUser(String email, String Name) async {
    await users.doc(email).set({
        'Name': Name,
        'Chats':[]
    });
  }

  Future<List<dynamic>> listAllChats(String email) async {
    List<dynamic> chats_uid;
    await users.doc(email).get().then((DocumentSnapshot documentSnapshot){
      chats_uid = documentSnapshot.data()['Chats'];
    });
    return chats_uid;
  }

  Future<dynamic> returnName() async{
    String email = auth.FirebaseAuth.instance.currentUser.email;
    String name;
    await users.doc(email).get().then((DocumentSnapshot documentSnapshot){
      name = documentSnapshot.data()['Name'];
    });
    return name;
  }

  Future<dynamic> getName(String id) async {

    String name;

    DocumentReference doc_ref = users.doc(id);

    if(doc_ref != null) {
      await users.doc(id).get().then((DocumentSnapshot documentSnapshot) {
        name = documentSnapshot.data()['Name'];
      });
    }

    return name;
  }

}