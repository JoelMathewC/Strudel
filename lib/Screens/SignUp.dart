import 'package:flutter/material.dart';
import 'package:strudel/AuthenticationSystem/Auth.dart';
import 'package:strudel/Screens/Loading.dart';



class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String name = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(

        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton(
              child: Text("Sign In",style: TextStyle(
                color: Colors.white
              ),),
              onPressed: () {
                widget.toggleView();
              },
            )
          ],
        ),
        body:
        Padding(
            padding: const EdgeInsets.fromLTRB(39.0, 70.0, 38.0, 0.0),
            child: Form(
              key: _formKey,
              child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Stru',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 60.0,
                              color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text('del',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 60.0,
                            color: Theme.of(context).accentColor,
                          ),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Communicate',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text('Securely.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Theme.of(context).accentColor,
                          ),),
                      ],
                    ),
                    SizedBox(height: 90.0),

                    TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            fillColor: Theme.of(context).primaryColorDark,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark, width: 2.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor, width: 2.0)
                            )
                        ),
                        validator: (val) =>val.isEmpty ? 'Please enter your name' : null,
                        onChanged: (val) {
                          setState(() => name = val);
                        }
                    ),
                    SizedBox(height: 10.0),

                    TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            fillColor: Theme.of(context).primaryColorDark,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark, width: 2.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor, width: 2.0)
                            )
                        ),
                        validator: (val) =>val.isEmpty ? 'Enter a valid Email Address' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            fillColor: Theme.of(context).primaryColorDark,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark, width: 2.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor, width: 2.0)
                            )
                        ),
                        validator: (val) =>
                        val.length < 6
                            ? 'Password must contain minimum 6 characters'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        }

                    ),

                    SizedBox(height: 10.0),

                    TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                            hintText: 'Re-type Password',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            fillColor: Theme.of(context).primaryColorDark,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark, width: 2.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor, width: 2.0)
                            )
                        ),
                        validator: (val) =>
                        val == password
                            ? null
                            : 'Password does not match',
                        obscureText: true,
                        onChanged: (val) {

                        }

                    ),

                    SizedBox(height: 40.0),

                    RaisedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (_formKey.currentState.validate()) {
                            dynamic result = await _auth.registerWithEmailAndPassword(name,email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error =
                                'Please enter a valid Email Id and corresponding Password';
                              });
                            }
                          }
                          else{
                            setState(() {
                              loading = false;
                              error =
                              'Please enter a valid Email Id and corresponding Password';
                            });
                          }
                        },
                        child: Text('Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Theme.of(context).accentColor,

                    ),
                    SizedBox(height: 20.0),
                    Text(error,
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic
                        )
                    )
                  ]
              ),
            )

        ));
  }
}

