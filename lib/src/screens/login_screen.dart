import 'package:app/src/screens/home_screen.dart';
import 'package:app/src/screens/signup_screen.dart';
import 'package:app/src/services/auth_service.dart';
import 'package:app/src/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    TextField(
                      controller: _emailC,
                      decoration: InputDecoration(hintText: "Email"),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: _passC,
                      decoration: InputDecoration(
                        hintText: "Password",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: _login,
                        child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                            child: Center(child: Text("Login", style: TextStyle(color: Colors.white))))),
                    TextButton(
                        onPressed: _signUpWithGoogle,
                        child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                            child: Center(child: Text("Google", style: TextStyle(color: Colors.white))))),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                    },
                    child: Container(height: 40, child: Center(child: Text("Create an account", style: TextStyle(fontWeight: FontWeight.bold)))))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signUpWithGoogle() async {
    showLoader();
    await AuthService.signInWithGoogle(context);
  }

  void _login() async {
    String email = _emailC.value.text;
    String pass = _passC.value.text;
    if (email.isNotEmpty && pass.isNotEmpty) {
      showLoader();
      bool _isLoggedIn = await AuthService.login(email, pass, context);
      Navigator.pop(context);
      if (_isLoggedIn) {
        String uid = FirebaseAuth.instance.currentUser.uid;
        var _userDetails = await DatabaseServices.getUserDetails(uid);
        bool isAdmin = _userDetails["role"] == "Customer" ? false : true;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      isAdmin: isAdmin,
                    )));
      }
    }
  }

  showLoader() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator.adaptive(),
            ));
  }
}
