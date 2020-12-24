import 'package:flutter/material.dart';
import 'package:strudel/AuthenticationSystem/Auth.dart';
import 'package:strudel/Database/UserDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:strudel/Screens/Loading.dart';

class SettingsPage extends StatefulWidget {
  static String id = 'SettingsPage';
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String name;
  bool loading = true;

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
  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Name:'
                ),
                SizedBox(width: 10,),
                Text(
                  name
                )
              ],
            ),
            SizedBox(height: 20,),
            FlatButton(onPressed:(){
              AuthServices().signOut();
              Navigator.pop(context);
            },
            child: Text('SignOut'),)
          ],
        ),
      ),
    );
  }
}
