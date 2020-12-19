import 'package:flutter/material.dart';

class AddChatScreen extends StatefulWidget {
  static String id = 'AddChatScreen';
  @override
  _AddChatScreenState createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {

  final nameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    super.dispose();
  }
  List<String> participants = ['Joel','Jaison'];
  List<String> participants_id = ['12','11'];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery. of(context). size. height;
    double width = MediaQuery. of(context). size. width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue[900],
        title: Text(
          'Start a new Conversation'
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        child: Icon(Icons.check),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
            child: Container(
              color: Colors.blue[900],
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

                        decoration: InputDecoration(
                          filled: true,
                            fillColor: Colors.white,
                            hintText: 'Name your Conversation',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 2.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 2.0)
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
              onTap: (){},
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
                color: Colors.blue[900],),
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
                        color: Color(0xfff2f9f3),
                        border: Border(
                          top: BorderSide(
                            width: 2.0,
                            color: Colors.blue[900],
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
                                    color: Colors.blue[900],
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
                                  color: Colors.white,
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
    );
  }
}
