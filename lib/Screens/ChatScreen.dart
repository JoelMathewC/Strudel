import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:strudel/Database/ChatClass.dart';
import 'package:strudel/Database/ChatDatabase.dart';
import 'package:strudel/Database/UserDatabase.dart';
import 'package:strudel/Screens/Loading.dart';
import 'package:strudel/Security/RSA.dart';


class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool loading = true;
  String name = "";
  String prevIndividual = "";
  String prevDate = "";
  String currentDate = "";
  Widget MessageWidget;
  @override
  void initState() {
    // TODO: implement initState
    UserDatabase().returnName().then((value) async {
      setState(() {
        name = value;
        loading = false;
      });
    });
    super.initState();
  }

  final messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChatClass thisChat = ModalRoute.of(context).settings.arguments;

    double height = MediaQuery. of(context). size. height;
    double width = MediaQuery. of(context). size. width;
    int numOfMessages = 0;
    List<MessageClass> messages = [];


    return loading ? Loading(): StreamBuilder(
      stream: FirebaseFirestore.instance.collection('ChatStream').orderBy('TimeStamp',descending: true).snapshots(),
      builder:(context,snapshot){
        prevIndividual = "";
        prevDate = "";
        if(snapshot.data == null)
          return Loading();
        else {
          messages = [];
          numOfMessages = 0;
          int i = 0;
          for (DocumentSnapshot doc in snapshot.data.documents) {
            if (doc['Chat_id'] == thisChat.uid) {
              if (doc['First'] == false) {
                numOfMessages += 1;
                MessageClass message = MessageClass(message: RSA().dataDecrypt(doc['Message'][auth.FirebaseAuth.instance.currentUser.email],thisChat.privateKey),
                    time: doc['TimeStamp'],
                    messageOwner: doc['Owner'],
                    date: null);
                currentDate = returnDate(message.time);


                if (prevIndividual != message.messageOwner &&
                    prevIndividual != name) {
                  messages.add(MessageClass(message: null,
                      time: null,
                      messageOwner: prevIndividual,
                      date: null));
                }

                if ((prevDate != "" && prevDate != currentDate)) {
                  messages.add(MessageClass(message: null,
                      time: null,
                      messageOwner: null,
                      date: prevDate));
                }

                prevIndividual = message.messageOwner;
                prevDate = currentDate;
                messages.add(message);
                i = i + 1;
              }
            }
          }
          if (prevIndividual != name) {
            messages.add(MessageClass(message: null,
                time: null,
                messageOwner: prevIndividual,
                date: null));
          }
          messages.add(MessageClass(message: null,
              time: null,
              messageOwner: null,
              date: prevDate));


          return Scaffold(
            backgroundColor: Theme
                .of(context)
                .canvasColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  Navigator.pop(context,true);
                  await UserDatabase().updateSeenMessagesCount(auth.FirebaseAuth.instance.currentUser.email, thisChat.uid, numOfMessages);

                },
              ),
              brightness: Brightness.dark,
              backgroundColor: Theme
                  .of(context)
                  .canvasColor,
              title: Text(thisChat.name,
                style: TextStyle(
                  color: Colors.white,
                ),),
              iconTheme: IconThemeData(
                  color: Theme
                      .of(context)
                      .primaryColor
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: height - 200,
                      //Covers everything from app bar till the input position
                      width: width,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ListView.builder(

                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              MessageClass message = messages[index];

                              if (message.message != null) {
                                return ChatMessage(width: width,
                                  message: message,
                                  byUser: message.messageOwner == name,);
                              }

                              else if (message.messageOwner != null) {
                                return PrintOwnerNameWidget(
                                  width: width, message: message,);
                              }
                              else {
                                return PrintDateWidget(date: message.date,);
                              }
                            }),
                      )
                  ),


                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          width: (width - 80),
                          child: TextField(
                            style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                            controller: messageController,
                            cursorColor: Theme
                                .of(context)
                                .accentColor,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme
                                    .of(context)
                                    .primaryColorDark,
                                hintText: 'Type Something...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .primaryColorDark, width: 2.0)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .accentColor, width: 2.0)
                                )
                            ),

                          ),
                        ),
                        SizedBox(width: 10.0),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: RawMaterialButton(onPressed: () {
                            MessageClass messageToSend = MessageClass(
                                message: messageController.text,
                                messageOwner: name,
                                time: Timestamp.fromDate(DateTime.now()));
                            messageController.clear();
                            ChatDatabase().sendMessage(
                                messageToSend, thisChat.uid);
                          },
                              elevation: 2.0,
                              fillColor: Theme
                                  .of(context)
                                  .accentColor,
                              child: Icon(Icons.send, size: 25,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(0.0),
                              shape: CircleBorder()
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),


          );
        }
      });




  }
}


//Widgets

class UserMessage extends StatefulWidget {
  double width;
  MessageClass message;
  UserMessage({this.width,this.message});
  @override
  _UserMessageState createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.all(
                  Radius.circular(15.0)),

            ),
            alignment: Alignment.center,

            width: (widget.width / 2) - 10,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(2,7,2,2),
                  child: Text(
                    widget.message.message, style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17.0,
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3,3,5,3),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      toTimeString(widget.message.time), style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.0,
                    ),),
                  ),
                )
              ],
            ),

          ),
        ),

        SizedBox(height: 10.0,)
      ],
    );
  }
}

class OtherMessage extends StatefulWidget {
  double width;
  MessageClass message;
  OtherMessage({this.width,this.message});
  @override
  _OtherMessageState createState() => _OtherMessageState();
}

class _OtherMessageState extends State<OtherMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .primaryColorDark,
              borderRadius: BorderRadius.all(
                  Radius.circular(15.0)),

            ),
            alignment: Alignment.center,

            width: (widget.width / 2) - 10,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      2, 7, 2, 2),
                  child: Text(
                    widget.message.message,
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontSize: 17.0
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets
                      .fromLTRB(3, 3, 5, 3),
                  child: Align(
                    alignment: Alignment
                        .bottomRight,
                    child: Text(
                      toTimeString(
                          widget.message.time),
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontSize: 14.0,
                      ),),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 10.0,)
      ],
    );
  }
}



class ChatMessage extends StatefulWidget {
  double width;
  MessageClass message;
  bool byUser;
  ChatMessage({this.width,this.message,this.byUser});
  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return widget.byUser? UserMessage(width: widget.width,message: widget.message,):OtherMessage(width: widget.width,message: widget.message,);
  }
}
//END OF CHAT MESSAGE WIDGET


class PrintOwnerNameWidget extends StatefulWidget {
  double width;
  MessageClass message;
  PrintOwnerNameWidget({this.width,this.message});
  @override
  _PrintOwnerNameWidgetState createState() => _PrintOwnerNameWidgetState();
}

class _PrintOwnerNameWidgetState extends State<PrintOwnerNameWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          child: Text(widget.message.messageOwner,
            style: TextStyle(
                color: Theme
                    .of(context)
                    .primaryColor
            ),),
          alignment: Alignment.bottomLeft,
        ),
        SizedBox(height: 10.0,),

      ],
    );
  }
}


class PrintDateWidget extends StatefulWidget {
  String date;
  PrintDateWidget({this.date});
  @override
  _PrintDateWidgetState createState() => _PrintDateWidgetState();
}

class _PrintDateWidgetState extends State<PrintDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Text(
            widget.date,
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 13.0
            ),
          ),
        ),
        SizedBox(height: 10.0,),
      ],
    );
  }
}











//Functions
String toTimeString(Timestamp t){
  var date = DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
  String time = date.toString().split(' ')[1];
  List<String> val = time.split(':');
  String result = val[0];
  result = result + ':' + val[1];
  return result;

}

String returnDate(Timestamp t){
  var date = DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
  String result = date.toString().split(' ')[0];
  return result;
}