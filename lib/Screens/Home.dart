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
  List<dynamic> nameOfChats = [];



  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Users').doc(auth.FirebaseAuth.instance.currentUser.email).snapshots(),
      builder: (context,snapshot){
        if(snapshot.data == null)
          return Loading();

        else {
          listOfChats = snapshot.data['Chats'];

          ChatDatabase().returnChatName(listOfChats).then((value){
            setState(() {
              nameOfChats = value;
            });

          });
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
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.pushNamed(context, AddChatScreen.id);
              },
            ),
            body: ListView.builder(
                itemCount: nameOfChats.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ChatClass selectedClass = ChatClass(
                          name: nameOfChats[index], uid: listOfChats[index]);
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                nameOfChats[index],
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),

                            ],
                          ),

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
