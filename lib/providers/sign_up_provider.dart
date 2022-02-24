import 'dart:typed_data';

import 'package:bhsoft_instagram_clone/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  bool isLoading = false;
  Uint8List? file;
  String username = "";
  String email = "";
  String password = "";
  String bio = "";
  String? error;

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setUsername(String username) {
    this.username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setBio(String bio) {
    this.bio = bio;
    notifyListeners();
  }

  void setFile(Uint8List? file) {
    this.file = file;
    notifyListeners();
  }

  Future<void> signUp() async {
    try {
      isLoading = true;
      notifyListeners();
      await AuthMethods().signUpUser(
        email: email,
        password: password,
        bio: bio,
        username: username,
        file: file,
      );
      isLoading = false;
      error = null;
      notifyListeners();
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      isLoading = false;
      error = e.message;
      notifyListeners();
    }
  }
}
