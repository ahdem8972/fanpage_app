import 'package:app/src/screens/home_screen.dart';
import 'package:app/src/screens/login_screen.dart';
import 'package:app/src/services/database_services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(seconds: 1));
    var _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      String uid = FirebaseAuth.instance.currentUser.uid;
      var _userDetails = await DatabaseServices.getUserDetails(uid);
      bool isAdmin = _userDetails["role"] == "Customer" ? false : true;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(isAdmin: isAdmin)));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset("assets/splash.jpeg"),
        ),
      ),
    );
  }
}
