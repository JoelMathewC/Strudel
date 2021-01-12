import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:strudel/Database/ChatDatabase.dart';
import 'package:strudel/Database/UserDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:strudel/Screens/Home.dart';
import 'package:strudel/Screens/Loading.dart';




class AddChatScreen extends StatefulWidget {
  static String id = 'AddChatScreen';
  @override
  _AddChatScreenState createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {

  final nameController = TextEditingController();
  final userAddController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    userAddController.dispose();
    super.dispose();
  }
  List<dynamic> participants = [];
  List<dynamic> participants_id = [];



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery. of(context). size. height;
    double width = MediaQuery. of(context). size. width;
    return loading? Loading(): Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          'Start a new Conversation',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         if(nameController.text == null || nameController.text == ""){
           Alert(
             context: context,
             title: 'A name has to be given to the conversation',
             buttons: [],
             style: AlertStyle(titleStyle: TextStyle(color: Colors.red)),
           ).show();
          }
         else if(participants.isEmpty){
           Alert(
             context: context,
             title: 'No members have been added to the conversation',
             buttons: [],
             style: AlertStyle(titleStyle: TextStyle(color: Colors.red)),
           ).show();
         }
         else{
           dynamic name = await UserDatabase().returnName();
           participants_id.add(auth.FirebaseAuth.instance.currentUser.email);
           participants.add(name);
           setState(() {
             loading = true;
           });
           await ChatDatabase().createNewChat(nameController.text, participants,participants_id);
           Navigator.pop(context);

         }
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.check),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60,
              child: Container(
                color: Theme.of(context).canvasColor,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Chat Name:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0,

                        ),
                      ),
                      SizedBox(width: 10.0,),
                      SizedBox(
                        height: 50,
                        width: (width - 150),
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(
                            color: Colors.white
                          ),
                          decoration: InputDecoration(
                            filled: true,
                              fillColor: Theme.of(context).primaryColorDark,
                              hintText: 'Name your Conversation',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColorDark, width: 2.0)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor, width: 2.0)
                              )
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),

            SizedBox(
              height: 40.0,
              width: 100,
              child: GestureDetector(
                onTap: (){
                  Alert(context: context,
                      title: 'Add Member',
                  desc: 'Enter Id of user to be added',
                  content: TextField(
                    controller: userAddController,

                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                      labelText: 'User ID'
                    ),

                  ),
                  buttons: [
                    DialogButton(
                      color: Theme.of(context).accentColor,
                        child: Text(
                      'SUBMIT',style: TextStyle(
                      color: Colors.white
                    ),
                    ), onPressed: () async {
                        if(userAddController.text == null){
                          Alert(
                            context: context,
                            title: 'Please enter the ID to add a user',
                            buttons: [],
                            style: AlertStyle(titleStyle: TextStyle(color: Colors.red)),
                          ).show();
                        }
                        else{
                          if(participants_id.contains(userAddController.text) || auth.FirebaseAuth.instance.currentUser.email == userAddController.text){
                            Alert(
                              context: context,
                              title: 'User has already been added',
                              buttons: [],
                              style: AlertStyle(titleStyle: TextStyle(color: Colors.red)),
                            ).show();
                          }
                          else{

                            dynamic user = await UserDatabase().getName(userAddController.text);
                            if(user != null) {
                              Navigator.pop(context);
                              setState(() {
                                participants.add(user);
                                participants_id.add(userAddController.text);
                                userAddController.clear();
                              });
                            }
                            else{
                              Alert(
                                context: context,
                                title: 'User does not exist',
                                buttons: [],
                                style: AlertStyle(titleStyle: TextStyle(color: Colors.red)),
                              ).show();
                            }





                          }
                        }
                    }),
                  ]).show();
                },
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'ADD',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                    ),
                  ),
                  color: Theme.of(context).accentColor,),
              ),
            ),
            SizedBox(height: 20.0,),

            Container(
              alignment: Alignment.center,
              height: height - 230,
              width: width - 40,
              child: ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context,index){

                    return Container(

                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          border: Border(
                            top: BorderSide(
                              width: 2.0,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
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
                                  participants[index],
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold),
                                ),

                              ],
                            ),

                            SizedBox(
                              height: 27,
                              width: 27,
                              child: RawMaterialButton(onPressed: () {
                                setState(() {
                                  participants_id.removeAt(index);
                                  participants.removeAt(index);
                                });

                              },
                                  elevation: 2.0,
                                  fillColor: Colors.blue[900],
                                  child: Icon(Icons.cancel, size: 25,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  padding: EdgeInsets.all(0.0),
                                  shape: CircleBorder()
                              ),
                            )

                          ],
                        ),
                      );

                  }),
            ),


          ]
        ),
      ),
    );
  }
}
