import 'dart:developer';
import 'dart:typed_data';

import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    try {
      String photoUrl = await StorageMethod().uploadImageToStorage(
        "posts",
        file,
        isPost: true,
      );
      final post = Post(
          description: description,
          username: username,
          profImage: profileImage,
          uid: uid,
          likes: [],
          comments: [],
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          postId: const Uuid().v4());

      await _firestore.collection("posts").doc(post.postId).set(post.toJson());
      log("Uploaded post: $post");
    } on FirebaseException catch (e) {
      throw UploadPostFailure(message: e.message!);
    }
  }

  Future<void> likePost(List likes, String postId, String uid) async {
    if (likes.contains(uid)) {
      await _firestore.collection("posts").doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await _firestore.collection("posts").doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  Future<String> getUserProfileImage(String uid) async {
    final snapshot = await _firestore.collection("users").doc(uid).get();
    final data = snapshot.data();
    final imageUrl = data!["imageUrl"] as String;
    return imageUrl;
  }
}

class UploadPostFailure implements Exception {
  final String message;
  UploadPostFailure({
    this.message = "Unable to upload post, please try again",
  });
}
