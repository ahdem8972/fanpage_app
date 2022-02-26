import 'dart:developer';

import 'package:app/src/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  static final _userRef = FirebaseFirestore.instance.collection("Users");
  static final _postRef = FirebaseFirestore.instance.collection("Posts");

  static void saveUser(fname, lname, uid) async {
    var _body = {"firstName": fname, "lastName": lname, "createdAt": FieldValue.serverTimestamp(), "role": "Customer"};
    await _userRef.doc(uid).set(_body);
    log("User Details Save");
  }

  static Future<DocumentSnapshot> getUserDetails(uid) async {
    return await _userRef.doc(uid).get()
      ..data();
  }

  static createPost(String text) async {
    var _body = {
      "content": text,
      "createdAt": FieldValue.serverTimestamp(),
      "createdBy": AuthService.userUid,
    };
    await _postRef.add(_body);
  }

  static Stream<QuerySnapshot> getAllPosts() {
    return _postRef.orderBy("createdAt", descending: true).snapshots();
  }
}
