import 'package:flutter/material.dart';
import 'package:strudel/Database/ChatClass.dart';
import 'package:strudel/Screens/Loading.dart';


class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final ChatClass thisChat = ModalRoute.of(context).settings.arguments;
    return loading? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(thisChat.name,
        style: TextStyle(
          color: Colors.white,
        ),),
      ),
    );
  }
}
