import 'package:app/src/screens/home_screen.dart';
import 'package:app/src/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;
  static String get userUid => FirebaseAuth.instance.currentUser.uid;

  static Future<bool> login(String email, String pass, context) async {
    bool result = false;
    try {
      UserCredential _user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      if (_user != null) {
        result = true;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.split(".").first)));
    }
    return result;
  }

  static register(String email, String password, String fname, String lname, context) async {
    try {
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        await DatabaseServices.saveUser(fname, lname, user.user.uid);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(isAdmin: false)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong")));
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  static Future<void> signInWithGoogle(context) async {
    try {
      final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential authCredential =
            GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

        await auth.signInWithCredential(authCredential).then((value) async {
          if (value.user != null) {
            print(value);
            await DatabaseServices.saveUser(
                value.additionalUserInfo.profile['given_name'], value.additionalUserInfo.profile['family_name'], value.user.uid);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(isAdmin: false)));
          }
        });
      } else {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
