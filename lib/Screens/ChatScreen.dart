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

    double height = MediaQuery. of(context). size. height;
    double width = MediaQuery. of(context). size. width;

    return loading? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Colors.blue[900],
        title: Text(thisChat.name,
        style: TextStyle(
          color: Colors.white,
        ),),
      ),
      body: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: (width-80),
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Type Something...',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 2.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue[900], width: 2.0)
                            )
                        ),

                    ),
                  ),
                  SizedBox(width:10.0),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: RawMaterialButton(onPressed: (){},
                    elevation: 2.0,
                    fillColor: Colors.blue[900],
                    child: Icon(Icons.send, size:25,
                    color: Colors.white,
                    ),
                        padding: EdgeInsets.all(0.0),
                      shape: CircleBorder()
                    ),
                  )
                ],
              ),
            ),
          ),


    );
  }
}
