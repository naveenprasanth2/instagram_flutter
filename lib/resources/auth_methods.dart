import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //signup the user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        //register the user
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        String url = await _storage
            .ref()
            .child("users")
            .child("dp")
            .child(userCredential.user!.uid)
            .putData(file)
            .toString();

        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "username": username,
          "uid": userCredential.user!.uid,
          "email": email,
          "bio": bio,
          "followers": [],
          "following": []
        });
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
