import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:strudel/Database/ChatClass.dart';
import 'package:strudel/Database/ChatDatabase.dart';
import 'package:strudel/Database/UserDatabase.dart';
import 'package:strudel/Screens/Loading.dart';


class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool loading = true;
  String name = "";
  List<String> data = ['Hi','Heyya','How do ya do','Imma doing good','Jaco young man how is life fe hasa and is it but beyond the measure of a common man'];

  @override
  void initState() {
    // TODO: implement initState
    UserDatabase().returnName().then((value){
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



    return loading ? Loading(): StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Chats').doc(thisChat.uid).collection('Messages').orderBy('TimeStamp',descending: true).snapshots(),
      builder:(context,snapshot){

        if(snapshot.data == null)
          return Loading();
        else {
          return Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            appBar: AppBar(

              backgroundColor: Theme.of(context).canvasColor,
              title: Text(thisChat.name,
                style: TextStyle(
                  color: Colors.white,
                ),),
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor
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
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc_snap = snapshot.data.documents[index];
                              MessageClass message = MessageClass(message: doc_snap['Message'],time: doc_snap['TimeStamp'],messageOwner: doc_snap['Owner']);
                              if (message.messageOwner == name) {
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

                                        width: (width / 2) - 10,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            message.message, style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 17.0,
                                          ),),
                                        ),

                                      ),
                                    ),

                                    SizedBox(height: 10.0,)
                                  ],
                                );
                              }
                              else
                                return Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColorDark,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),

                                        ),
                                        alignment: Alignment.center,

                                        width: (width / 2) - 10,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            message.message, style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 17.0
                                          ),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Align(
                                      child: Text(message.messageOwner,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor
                                      ),),
                                      alignment: Alignment.bottomLeft,
                                    ),
                                    SizedBox(height: 10.0,)
                                  ],
                                );
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
                              color: Theme.of(context).primaryColor,
                            ),
                            controller: messageController,
                            cursorColor: Theme.of(context).accentColor,
                            decoration: InputDecoration(
                              filled: true,
                                fillColor: Theme.of(context).primaryColorDark,
                                hintText: 'Type Something...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Theme.of(context).primaryColorDark, width: 2.0)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor, width: 2.0)
                                )
                            ),

                          ),
                        ),
                        SizedBox(width: 10.0),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: RawMaterialButton(onPressed: () {
                            MessageClass messageToSend = MessageClass(message: messageController.text,messageOwner: name,time: Timestamp.fromDate(DateTime.now()));
                            messageController.clear();
                            ChatDatabase().sendMessage(messageToSend, thisChat.uid);
                          },
                              elevation: 2.0,
                              fillColor: Theme.of(context).accentColor,
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
