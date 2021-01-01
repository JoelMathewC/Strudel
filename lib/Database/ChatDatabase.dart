import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strudel/Database/ChatClass.dart';
import 'package:strudel/Database/UserDatabase.dart';

class ChatDatabase{

    final CollectionReference chats = FirebaseFirestore.instance.collection('ChatStream');



    Future<void> sendMessage(MessageClass message,String uid) async{
      await chats.add({
        'Message': message.message,
        'Owner': message.messageOwner,
        'TimeStamp': message.time,
        'First':false,
        'Chat_id': uid,
      });
    }

    Future<void> createNewChat(dynamic groupName, List<dynamic> participants,List<dynamic> participants_id) async {
      dynamic id = chats.doc().id;
      await chats.doc(id).set({
        'ChatName': groupName,
        'Chat_id': id,
        'First':true,
        'TimeStamp': Timestamp.fromDate(DateTime.now()),
        'Members': participants_id,
      });
      await addChatToUsers(participants_id,id);
    }
    Future<void> addChatToUsers(List<dynamic> participants_id,dynamic chat_id) async {
      for(dynamic id in participants_id){
        await UserDatabase().addChatToUser(id,chat_id);
      }
    }
}