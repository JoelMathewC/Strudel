import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strudel/AuthenticationSystem/Auth.dart';
import 'package:strudel/Database/ChatDatabase.dart';
import 'package:strudel/Database/UserDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:strudel/Database/ChatClass.dart';
import 'package:strudel/Screens/AddChatScreen.dart';
import 'package:strudel/Screens/ChatScreen.dart';
import 'package:strudel/Screens/SettingsPage.dart';

import 'Loading.dart';


class Home extends StatefulWidget {
  static String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  List<dynamic> listOfChats = [];
  List<DisplayChatClass> chats = [];
  Map<dynamic,int> idToIndex = {};
  Map<dynamic,dynamic> numOfSeenMessages = {};
  bool loading = true;
  String prevOpenedChatID = "";

  @override
  void initState() {
    // TODO: implement initState
    UserDatabase().returnChatDetails(_auth.currentUser.email).then((value){
      setState(() {
        listOfChats = value[0];
        numOfSeenMessages = value[1];
        print(numOfSeenMessages);
        int i = 0;
        for(String chat_id in listOfChats){
          DisplayChatClass displayChat = DisplayChatClass(chatID: chat_id,chatName: null,numOfMessages: 0,time: null,lastMessage: null,lastMessageOwner: null);
          chats.add(displayChat);
          idToIndex.addAll({chat_id:i});
          ++i;
        }
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  loading? Loading():StreamBuilder(
      stream: FirebaseFirestore.instance.collection('ChatStream').orderBy('TimeStamp',descending: true).snapshots(),
      builder: (context,snapshot){
        if(snapshot.data == null)
          return Loading();

        else {
          for(DisplayChatClass displayChat in chats){ //Clears the chats list
            displayChat.numOfMessages = 0;
            displayChat.chatName = null;
            displayChat.time = null;
            displayChat.lastMessage = null;
            displayChat.lastMessageOwner = null;
          }

          for(DocumentSnapshot doc in snapshot.data.documents){ //Updates Messages and New Groups
            if (doc['First'] == true) {
              if(doc['Members'].contains(_auth.currentUser.email) && !(listOfChats.contains(doc['Chat_id']))){
                listOfChats.add(doc['Chat_id']);
                idToIndex.addAll({doc['Chat_id']:listOfChats.length - 1});
                numOfSeenMessages.addAll({doc['Chat_id']:0});
                DisplayChatClass displayChat = DisplayChatClass(chatID: doc['Chat_id'],chatName: null,numOfMessages: 0,time: null,lastMessage: null,lastMessageOwner: null);
                chats.add(displayChat);
                chats[idToIndex[doc['Chat_id']]].chatName = doc['ChatName'];
                chats[idToIndex[doc['Chat_id']]].time = doc['TimeStamp'];
              }
              else if(listOfChats.contains(doc['Chat_id'])){
              chats[idToIndex[doc['Chat_id']]].chatName = doc['ChatName'];
              chats[idToIndex[doc['Chat_id']]].time = doc['TimeStamp'];
              }
            }
            else {
              if (listOfChats.contains(doc['Chat_id'])) {
                chats[idToIndex[doc['Chat_id']]].numOfMessages += 1;
                if (chats[idToIndex[doc['Chat_id']]].lastMessage == null) {
                  chats[idToIndex[doc['Chat_id']]].lastMessage = doc['Message'];
                  chats[idToIndex[doc['Chat_id']]].time = doc['TimeStamp'];
                  chats[idToIndex[doc['Chat_id']]].lastMessageOwner =
                  doc['Owner'];
                }
              }
            }
          }

          for(int i=0;i<chats.length;++i){ //Removes any null chats if they exist
            if(chats[i].chatName == null){
              chats.removeAt(i);
              idToIndex.remove(listOfChats[i]);
              numOfSeenMessages.remove(listOfChats[i]);
              listOfChats.removeAt(i);
            }
          }
          for(DisplayChatClass displayChat in chats){ //For the unseen messages
            if(displayChat.chatID == prevOpenedChatID){
              numOfSeenMessages[displayChat.chatID] = displayChat.numOfMessages;
              prevOpenedChatID = null;
            }
            displayChat.numOfMessages -= numOfSeenMessages[displayChat.chatID];
          }
          return Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            appBar: AppBar(
              brightness: Brightness.dark,
              title: Row(

                children: <Widget>[
                  SizedBox(width: 5.0),
                  Text('Stru',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text('del',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Theme.of(context).accentColor,
                    ),),
                ],
              ),
              backgroundColor: Theme.of(context).canvasColor,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton(
                  child: Icon(Icons.settings,
                  color: Theme.of(context).primaryColor,),
                  onPressed: () {
                    Navigator.pushNamed(context, SettingsPage.id);
                  },)
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add,
              color: Theme.of(context).primaryColor,),
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.pushNamed(context, AddChatScreen.id);
              },
            ),
            body: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ChatClass selectedClass = ChatClass(
                          name: chats[index].chatName, uid: chats[index].chatID);
                      prevOpenedChatID = chats[index].chatID;
                      Navigator.pushNamed(
                          context, ChatScreen.id, arguments: selectedClass);

                    },
                    child: Container(

                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        // border: Border(
                        //   top: BorderSide(
                        //     width: 2.0,
                        //     color: Theme.of(context).primaryColor,
                        //   ),
                        // ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          DisplayNameAndMessage(lastMessage: chats[index].lastMessage,lastMessageOwner: chats[index].lastMessageOwner,chatName: chats[index].chatName,lastMessageExists: chats[index].lastMessage != null,),
                          DisplayNotificationAndTime(time: chats[index].time,numOfMessages: chats[index].numOfMessages,notificationsExist: chats[index].numOfMessages > 0,)
                        ],
                      ),
                    ),
                  );
                }),

          );
        }
      });
  }
}

String convertTimeStamptoUsableFormat(Timestamp t){
  DateTime now = DateTime.now();
  DateTime date = t.toDate();
  if(DateTime(now.year,now.month,now.day).difference(DateTime(date.year,date.month,date.day)).inDays == 0){
    return toTimeString(t);
  }
  else
    return returnDate(t);
}

String toTimeString(Timestamp t){ //returnTime
  var date = DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
  String time = date.toString().split(' ')[1];
  List<String> val = time.split(':');
  String result = val[0];
  result = result + ':' + val[1];
  if(result == '00:00'){
    result = returnDate(t);
  }
  return result;

}

String returnDate(Timestamp t){ //returnDate
  var date = DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
  String result = date.toString().split(' ')[0];
  return result;
}

class DisplayNameAndMessage extends StatefulWidget {
  String chatName;
  String lastMessage;
  String lastMessageOwner;
  bool lastMessageExists;
  DisplayNameAndMessage({this.lastMessage,this.lastMessageOwner,this.chatName,this.lastMessageExists});
  @override
  _DisplayNameAndMessageState createState() => _DisplayNameAndMessageState();
}

class _DisplayNameAndMessageState extends State<DisplayNameAndMessage> {


  @override
  Widget build(BuildContext context) {
    return widget.lastMessageExists ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ' ' + widget.chatName,
          style: TextStyle(
              fontSize: 20.0,
              color: Theme
                  .of(context)
                  .primaryColor,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0,),
        Text(
          '  ' +widget.lastMessageOwner + ':' +widget.lastMessage,
          style: TextStyle(
              fontSize: 15.0,
              color: Theme
                  .of(context)
                  .primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ],
    ): Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ' ' + widget.chatName,
          style: TextStyle(
              fontSize: 20.0,
              color: Theme
                  .of(context)
                  .primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class DisplayNotificationAndTime extends StatefulWidget {
  Timestamp time;
  int numOfMessages;
  bool notificationsExist;
  DisplayNotificationAndTime({this.notificationsExist,this.time,this.numOfMessages});
  @override
  _DisplayNotificationAndTimeState createState() => _DisplayNotificationAndTimeState();
}

class _DisplayNotificationAndTimeState extends State<DisplayNotificationAndTime> {
  @override
  Widget build(BuildContext context) {
    return widget.notificationsExist?Column(
      children: <Widget>[
        Text(
          convertTimeStamptoUsableFormat(widget.time),
          style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0,),
        Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              widget.numOfMessages > 500? '500+': widget.numOfMessages.toString(),

              style: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    ):Column(
      children: <Widget>[
        Text(
          convertTimeStamptoUsableFormat(widget.time),
          style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 38.0,),
      ],
    );
  }
}
