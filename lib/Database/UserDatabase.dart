import 'package:cloud_firestore/cloud_firestore.dart';


class UserDatabase{

  Future<void> createUser(String email, String Name) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users.doc(email).set({
        'Name': Name,
        'Chats':[]
    });
  }

}