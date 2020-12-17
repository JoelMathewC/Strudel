import 'package:flutter/material.dart';
import 'package:strudel/AuthenticationSystem/Auth.dart';
import 'package:strudel/Screens/Loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton(
                child: Text("Sign Up"),
                onPressed: () {
                  widget.toggleView();
                },
              )
            ],
          ),
          body:
          Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 90.0, 30.0, 0.0),
              child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 30.0,),
                      Text('Piggy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 70.0,
                            color: Colors.blue[900]
                        ),
                      ),

                      Text('Records',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 70.0,
                          color: Colors.black,
                        ),),

                      SizedBox(height: 60.0),

                      TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Email Address',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2.0)
                              )
                          ),
                          validator: (val) =>
                          val.isEmpty
                              ? 'Enter a valid Email Address'
                              : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          }
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2.0)
                              )
                          ),
                          validator: (val) =>
                          val.length < 6
                              ? 'Password not Valid'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          }

                      ),

                      SizedBox(height: 20.0),

                      RaisedButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            if (_formKey.currentState.validate()) {
                              // dynamic result = await _auth
                              //     .signInWithEmailAndPassword(email, password);
                              // if (result == null) {
                              //   setState(() {
                              //     loading = false;
                              //     error =
                              //     'Please enter a valid Email Id and corresponding Password';
                              //   });
                              // }
                            }
                          },
                          child: Text('Sign In',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          color: Colors.blue[900]

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