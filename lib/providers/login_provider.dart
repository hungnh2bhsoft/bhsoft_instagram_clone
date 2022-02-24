import 'package:bhsoft_instagram_clone/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool isLoading = false;
  String email = "";
  String password = "";
  String? error;

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  Future<void> login() async {
    try {
      isLoading = true;
      notifyListeners();
      await AuthMethods().logIn(email: email, password: password);
      isLoading = false;
    } on LogInWithEmailAndPasswordFailure catch (e) {
      isLoading = false;
      error = e.message;
      notifyListeners();
    }
  }
}
