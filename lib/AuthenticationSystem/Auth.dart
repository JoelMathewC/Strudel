import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:strudel/Database/UserDatabase.dart';
import 'package:strudel/Security/RSA.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:strudel/Security/WritingData.dart';

class AuthServices{




  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Stream<auth.User> get user {
    return _auth.authStateChanges();
  }


  Future registerWithEmailAndPassword(String name,String email,String password) async {
    try{
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      crypto.AsymmetricKeyPair keyPair = await RSA().getKeyPair(); //Generating a private and public key pair
      await UserDatabase().createUser(email, name,RSA().encodePublicKeyToPem(keyPair.publicKey)); //Creating the user in the database
      Map<String,dynamic> privateKey = {'PrivateKey': RSA().encodePrivateKeyToPem(keyPair.privateKey)};
      await WritingData().createFile(privateKey); //Saving the private key in a jsonFile on device
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