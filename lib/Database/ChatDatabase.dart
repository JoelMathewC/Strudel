import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strudel/Database/ChatClass.dart';
import 'package:strudel/Database/UserDatabase.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:strudel/Security/RSA.dart';

class ChatDatabase{

    final CollectionReference chats = FirebaseFirestore.instance.collection('ChatStream'); //ChatStream
    final CollectionReference chatCollection = FirebaseFirestore.instance.collection('Chats');


    Future<void> sendMessage(MessageClass message,String uid,Map<dynamic,dynamic> publicKeysOfUsers) async{
      Map<String,List<String>> mapUserToEncryptMessage = {};
      publicKeysOfUsers.forEach((key, value) {
        mapUserToEncryptMessage[key] = RSA().dataEncrypt(message.message, RSA().parsePublicKeyFromPem(value));
      });
      await chats.add({
        'Message':  mapUserToEncryptMessage,
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
      Map<String,String> membersPublicKeys = await addChatToUsers(participants_id,id);
      await chatCollection.doc(id).set({
        'ChatName': groupName,
        'Chat_id': id,
        'Members': participants_id,
        'PublicKeys': membersPublicKeys,
      });
    }

    Future<Map<String,String>> addChatToUsers(List<dynamic> participants_id,dynamic chat_id) async {
      String userPublicKey;
      Map<String,String> userToKey = {};
      for (dynamic id in participants_id) {
        userPublicKey = await UserDatabase().addChatToUser(id, chat_id);
        userToKey[id.toString()] = userPublicKey;
      }
      return userToKey;
    }

    Future<Map<dynamic,dynamic>> returnMembersPublicKeys(String id)async{
        Map<dynamic,dynamic> map = {};
        await chatCollection.doc(id).get().then((DocumentSnapshot documentSnapshot){
          map = documentSnapshot.data()['PublicKeys'];
        });
        return map;
    }
}