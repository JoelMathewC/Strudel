import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strudel/Database/ChatClass.dart';
import 'package:strudel/Database/UserDatabase.dart';

class ChatDatabase{

    final CollectionReference chats = FirebaseFirestore.instance.collection('Chats');

    Future<List<DocumentSnapshot>> returnDocumentSnapshotsOfChats(List<dynamic> uids) async {  //Works
      List<DocumentSnapshot> chats_docSnap = [];

      for (String uid in uids){
        await chats.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
          chats_docSnap.add(documentSnapshot);
        });
      }

      return chats_docSnap;
    }

    Future<void> sendMessage(MessageClass message,String uid) async{
      await chats.doc(uid).collection('Messages').add({
        'Message': message.message,
        'Owner': message.messageOwner,
        'TimeStamp': message.time,
      });
    }

    Future<void> createNewChat(dynamic groupName, List<dynamic> participants,List<dynamic> participants_id) async {
      dynamic id = chats.doc().id;
      await chats.doc(id).set({
        'Name': groupName,
        'Participants': participants,
      });
      await addChatToUsers(participants_id,id);
    }
    Future<void> addChatToUsers(List<dynamic> participants_id,dynamic chat_id) async {
      for(dynamic id in participants_id){
        await UserDatabase().addChatToUser(id,chat_id);
      }
    }
}