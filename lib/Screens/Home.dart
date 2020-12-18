import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strudel/AuthenticationSystem/Auth.dart';
import 'package:strudel/Database/ChatDatabase.dart';
import 'package:strudel/Database/UserDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'Loading.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  List<dynamic> listofChats;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    UserDatabase().listAllChats(_auth.currentUser.email).then((value) {
      setState(() {
        listofChats = value; //Works
        loading = false;
      });

      // ChatDatabase().returnChatName(listofChats[0]).then((value){
      //   print(value);
      // });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(

          children: <Widget>[
            SizedBox(width:5.0),
            Text('Stru',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.blue[900]
              ),
            ),
            Text('del',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black,
              ),),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
            child: Text('SignOut',
            style: TextStyle(
              fontSize: 15.0
            ),),
            onPressed: (){
              AuthServices().signOut();
          }, )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[900],
        onPressed: (){

        },
      ),
      body: ListView.builder(
          itemCount: listofChats.length,
          itemBuilder: (context,index){
            return Container(

            );
      }),
    );
  }
}
