import 'package:app/src/screens/login_screen.dart';
import 'package:app/src/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  final isAdmin;
  const HomeScreen({Key key, @required this.isAdmin}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _postC = TextEditingController();

  @override
  void dispose() {
    _postC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Container(
              child: TextButton(
                  onPressed: () {
                    showLogoutDialog();
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.red,
                  )))
        ],
        elevation: 0.5,
        centerTitle: true,
        title: Text("Posts", style: TextStyle(color: Colors.black)),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                showPostDialog();
              },
              child: Icon(Icons.add),
            )
          : null,
      body: Container(
        height: size.height,
        width: size.width,
        child: StreamBuilder<QuerySnapshot>(
            stream: DatabaseServices.getAllPosts(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var post = snapshot.data.docs[index].data();
                    return postContainer(post);
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  showLogoutDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        buttonPadding: EdgeInsets.all(14),
        content: Text("Are you sure you want to logout?"),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget postContainer(post) {
    var createdAt = post['createdAt'];
    String _date = "";
    if (createdAt != null) {
      _date = createdAt.toDate().toString().split(" ").first.trim();
      var _dateList = _date.split('-');
      _date = _dateList[1] + "-" + _dateList[2] + "-" + _dateList[0];
    }
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey[400], spreadRadius: 0.4, blurRadius: 0.4)],
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Posted on $_date"), SizedBox(height: 8), Text(post['content'], style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20))],
      ),
    );
  }

  showPostDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.all(12),
            child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Create Post",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: _postC,
                      maxLines: 8,
                      decoration: InputDecoration(
                          hintText: "Write your message",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: _post,
                      child: Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text("Post Message", style: TextStyle(color: Colors.white))))),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
  }

  void _post() async {
    if (_postC.value.text.isNotEmpty) {
      Navigator.pop(context);
      await DatabaseServices.createPost(_postC.value.text);
      _postC.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message Posted!!!")));
    }
  }
}
