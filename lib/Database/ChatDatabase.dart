import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDatabase{

    final CollectionReference chats = FirebaseFirestore.instance.collection('Chats');

    Future<String> returnChatName(String uid) async {  //Works
      String name;
      await chats.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
          name = documentSnapshot.data()['Name'];
      });
      return name;
    }
}