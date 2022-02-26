import 'package:app/src/screens/login_screen.dart';
import 'package:app/src/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  final TextEditingController _firstNameC = TextEditingController();
  final TextEditingController _lastNameC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    _firstNameC.dispose();
    _lastNameC.dispose();
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
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 60,
                        child: TextField(
                          controller: _firstNameC,
                          decoration: InputDecoration(hintText: "First Name"),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 60,
                        child: TextField(
                          controller: _lastNameC,
                          decoration: InputDecoration(hintText: "Last Name"),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 60,
                        child: TextField(
                          controller: _emailC,
                          decoration: InputDecoration(hintText: "Email"),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 60,
                        child: TextField(
                          controller: _passC,
                          decoration: InputDecoration(
                            hintText: "Password",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextButton(
                      onPressed: _register,
                      child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text("Register", style: TextStyle(color: Colors.white))))),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Container(
                          height: 40, child: Center(child: Text("Already have an account? Login.", style: TextStyle(fontWeight: FontWeight.bold)))))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    String email = _emailC.value.text;
    String password = _passC.value.text;
    String fname = _firstNameC.value.text;
    String lname = _lastNameC.value.text;
    if (email.isNotEmpty && password.isNotEmpty && fname.isNotEmpty && lname.isNotEmpty) {
      showLoader();
      await AuthService.register(email, password, fname, lname, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please provide all details")));
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
