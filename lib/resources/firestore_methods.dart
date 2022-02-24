import 'dart:developer';
import 'dart:typed_data';

import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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
      // log("Uploaded post: $post");
    } on FirebaseException catch (e) {
      throw UploadPostFailure(message: e.message!);
    }
  }

  Future<void> likePost(Post post) async {
    final uid = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
    if (post.likes.contains(uid)) {
      await _firestore.collection("posts").doc(post.postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await _firestore.collection("posts").doc(post.postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  Future<void> toggleLikeComment(
      List likes, String postId, String commentId, String uid) async {
    if (likes.contains(uid)) {
      await _firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await _firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .update({
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

  Future<void> postComment(String postId, String content, String uid,
      String name, String profileImage) async {
    try {
      final commentId = const Uuid().v4();
      if (content.isNotEmpty) {
        _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "content": content,
          "profileImage": profileImage,
          "name": name,
          "uid": uid,
          "likes": [],
          "datePublished": DateTime.now(),
        });
      }
      log("Posted comment: $content");
    } catch (e) {
      log(e.toString(), name: "FirebaseMethods");
    }
  }

  Stream<List<Comment>> getPostComments(String postId) {
    return _firestore
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .orderBy("datePublished", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Comment.fromSnapshot(doc)).toList());
  }

  Future<void> deletePost(
    Post post,
  ) async {
    try {
      log("deleting post: ${post.postId} by ${post.uid}");
      await _firestore.collection("posts").doc(post.postId).delete();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<List<User>> searchUsers(String value) async {
    final snapshot = await _firestore
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: value)
        .limit(10)
        .get();
    final results = snapshot.docs.map((e) => User.fromSnapshot(e)).toList();
    return results;
  }

  Future<bool> toggleFollowing(String uid, bool isFollowing) async {
    if (isFollowing) {
      await _firestore.collection("users").doc(uid).update(
        {
          "followers": FieldValue.arrayRemove([uid])
        },
      );
    } else {
      await _firestore.collection("users").doc(uid).update({
        "followers": FieldValue.arrayUnion([uid])
      });
    }
    return !isFollowing;
  }
}

class UploadPostFailure implements Exception {
  final String message;
  UploadPostFailure({
    this.message = "Unable to upload post, please try again",
  });
}
