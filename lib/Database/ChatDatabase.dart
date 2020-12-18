import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strudel/Database/ChatClass.dart';

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

    Future<void> sendMessage(MessageClass message,String uid) async{
      await chats.doc(uid).collection('Messages').add({
        'Message': message.message,
        'Owner': message.messageOwner,
        'TimeStamp': message.time,
      });
    }
}