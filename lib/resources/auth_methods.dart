import 'dart:developer';
import 'dart:typed_data';

import 'package:bhsoft_instagram_clone/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:bhsoft_instagram_clone/models/models.dart';

class AuthMethods {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpUser({
    required String email,
    required String password,
    required String bio,
    required String username,
    required Uint8List? file,
  }) async {
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          username.isNotEmpty) {
        final cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        log(cred.toString(), name: "FirebaseAuth");
        firebase_auth.User currentUser = _auth.currentUser!;
        final imageUrl = file == null
            ? ""
            : await StorageMethod().uploadImageToStorage(
                "profilePictures",
                file,
                isPost: true,
              );
        await _firestore.collection("users").doc(cred.user!.uid).set({
          "username": username,
          "email": email,
          "bio": bio,
          "followers": [],
          "following": [],
          "imageUrl": imageUrl,
        });
        final user = User(
          uid: _auth.currentUser!.uid,
          username: username,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          imageUrl: imageUrl,
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {}
    } on firebase_auth.FirebaseAuthException catch (err) {
      throw LogInWithEmailAndPasswordFailure.fromCode(err.code);
    }
  }

  Future<void> logOut() {
    try {
      return _auth.signOut();
    } on firebase_auth.FirebaseAuthException catch (_) {
      throw LogOutFailure;
    }
  }

  Future<User> getUserDetails() async {
    final firebase_auth.User currentUser = _auth.currentUser!;
    final snapshot =
        await _firestore.collection("users").doc(currentUser.uid).get();
    log(snapshot.data().toString(), name: "Firestore user data");
    return User.fromSnapshot(snapshot);
  }
}

class SignUpWithEmailAndPasswordFailure implements Exception {
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  final String message;
}

class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  final String message;
}

class LogOutFailure implements Exception {}
