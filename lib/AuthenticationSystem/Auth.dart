import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthServices{

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Stream<auth.User> get user {
    return _auth.authStateChanges();
  }
}