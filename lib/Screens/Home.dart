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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          AuthServices().signOut();
        },
      ),
    );
  }
}
