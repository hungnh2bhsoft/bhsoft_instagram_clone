import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<User> results = [];
  bool isEmpty = true;
  bool isSearching = false;

  void onValueChanged(String newKeyword) async {
    if (newKeyword.isEmpty) {
      isEmpty = true;
      isSearching = false;
      notifyListeners();
    } else {
      isEmpty = false;
      isSearching = true;
      notifyListeners();
      results = await FirestoreMethods().searchUsers(newKeyword);
      isSearching = false;
      notifyListeners();
    }
    notifyListeners();
  }
}
