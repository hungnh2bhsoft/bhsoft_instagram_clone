import 'dart:developer';
import 'dart:typed_data';

import 'package:bhsoft_instagram_clone/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> signUpUser({
    required String email,
    required String password,
    required String bio,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          username.isNotEmpty) {
        final cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        log(cred.toString());
        final imageUrl = await StorageMethod().uploadImageToStorage(
          "profilePictures",
          file,
          isPost: true,
        );
        log(imageUrl);
        await _firestore.collection("users").doc(cred.user!.uid).set({
          "username": username,
          "email": email,
          "bio": bio,
          "followers": [],
          "following": [],
          "imageUrl": imageUrl,
        });
      }
    } on FirebaseAuthException catch (err) {
      res = err.message!;
      log(res);
    }
  }

  Future<String> logIn({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        res = "Success";
      }
    } on FirebaseAuthException catch (err) {
      res = err.message!;
      log(res);
    }
    log(res);
    return res;
  }
}
