import 'package:flutter/material.dart';
import 'package:strudel/AuthenticationSystem/Auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
