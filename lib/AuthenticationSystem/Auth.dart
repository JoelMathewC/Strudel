import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:strudel/Database/UserDatabase.dart';

class AuthServices{




  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Stream<auth.User> get user {
    return _auth.authStateChanges();
  }


  Future registerWithEmailAndPassword(String name,String email,String password) async {
    try{
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await UserDatabase().createUser(email, name);


      return result.user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future LoginWithEmailAndPassword(String email,String password) async {
    try{
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
     return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }


}