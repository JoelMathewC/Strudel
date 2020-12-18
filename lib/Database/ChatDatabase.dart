import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDatabase{

    final CollectionReference chats = FirebaseFirestore.instance.collection('Chats');

    Future<List<String>> returnChatName(List<dynamic> uids) async {  //Works
      List<String> names = [];
      String name;

      for (String uid in uids){
        await chats.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
          name = documentSnapshot.data()['Name'];
          names.add(name);
        });
      }

      return names;
    }
}