import 'package:cloud_firestore/cloud_firestore.dart';


class UserDatabase{

  Future<void> createUser(String email, String Name) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users.doc(email).set({
        'Name': Name,
        'Chats':[]
    });
  }

  Future<List<dynamic>> listAllChats(String email) async {
    List<dynamic> chats_uid;
    final CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users.doc(email).get().then((DocumentSnapshot documentSnapshot){
      chats_uid = documentSnapshot.data()['Chats'];
    });
    return chats_uid;
  }

}