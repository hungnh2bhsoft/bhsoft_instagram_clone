import 'dart:typed_data';

import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final User user;
  Uint8List? file;
  String description = "";
  bool isUploading = false;

  PostProvider({
    required this.user,
  });

  void clearPost() {
    file = null;
    description = "";
    notifyListeners();
  }

  Future<void> uploadPost() async {
    try {
      isUploading = true;
      notifyListeners();
      await FirestoreMethods().uploadPost(
        description,
        file!,
        user.uid,
        user.username,
        user.imageUrl,
      );
      file = null;
      description = "";
      isUploading = false;
      notifyListeners();
    } on UploadPostFailure catch (_) {
      isUploading = false;
      notifyListeners();
      rethrow;
    }
  }

  void onDescriptionChanged(String newDescription) {
    description = newDescription;
  }

  void onImageSelected(Uint8List? file) {
    this.file = file;
    notifyListeners();
  }
}
