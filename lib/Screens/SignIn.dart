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

    double height = MediaQuery. of(context). size. height;
    print(height);
    double width = MediaQuery. of(context). size. width;
    return loading ? Loading() : Scaffold(

      backgroundColor: Theme.of(context).canvasColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton(
                child: Text("Sign Up",
                style: TextStyle(
                  color: Colors.white,
                ),),
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
                child: ListView(
                    children: <Widget>[
                      SizedBox(height: 30.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Stru',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 80.0,
                                color: Theme.of(context).primaryColor
                            ),
                          ),
                          Text('del',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 80.0,
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
                                color:  Theme.of(context).primaryColor
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



                      SizedBox(height: height - 396 - 230), //350 - 580 = 230

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
                                      color:  Theme.of(context).accentColor, width: 2.0)
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
                                      color:  Theme.of(context).accentColor, width: 2.0)
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
                              dynamic result = await _auth
                                  .LoginWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                  'Please enter a valid Email Id and corresponding Password';
                                });
                              }
                            }
                          },
                          child: Text('Sign In',
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